-- Dieses SQL File enthält SQL Querys, um Strukturdaten auf Parzellenebene aufzubereiten.
-- Diese Daten sind auch Grundlage für die Datenebenen Zonentyp, Zonenschild und Gemeinde.

-- GRUNDLAGEN -------------------------------------------------------------------------
-- Mapping von GWR-Gebäudeklassen-Codes und -Beschreibungen
drop table if exists export.gklas_10_map cascade;
CREATE TABLE export.gklas_10_map AS
SELECT * FROM (
    VALUES 
    (111, 'Wohnbauten'),
    (112, 'Gebäude mit zwei oder mehr Wohnungen'),
    (113, 'Wohngebäude für Gemeinschaften'),
    (121, 'Hotels und ähnliche Gebäude'),
    (122, 'Bürogebäude'),
    (123, 'Gross- und Einzelhandelsgebäude'),
    (124, 'Gebäude des Verkehrs- und Nachrichtenwesens'),
    (125, 'Industrie- und Lagergebäude'),
    (126, 'Gebäude für Kultur- und Freizeitzwecke sowie das Bildungs- und Gesundheitswesen'),
    (127, 'Sonstige Nichtwohngebäude')
) AS tbl(gklas_10, gklas_10_txt);

-- Alle Ausgangspolygone aus der Bauzonenstatistik (= Grundstück x Zone abzüglich Strassen etc.) plus Reservezonen
drop table if exists export.parzellen_basis cascade;
create table export.parzellen_basis as
	with baustat as (
		select 
			t_ili_tid,
			bfs_nr,
			grundnutzung_typ_kt,
			bebauungsstand,
			ST_Area(ST_Collect(part)) as flaeche,
			-- MultiPolygon wieder zusammensetzen
			ST_Collect(part) as geometrie,
			-- MultiPoint zusammensetzen (benötigt in der Zonenschild-Berechnung)
			ST_Collect(pip) as pip
		from (
			select 
				t_ili_tid,
				bfs_nr,
				grundnutzung_typ_kt,
				bebauungsstand,
				-- MultiPolygon dumpen
				ST_ReducePrecision((ST_Dump(geometrie)).geom, 0.001) as part,
				-- Punkte aus den Teilpolygonen ableiten (benötigt in der Zonenschild-Berechnung)
				ST_PointOnSurface((ST_Dump(geometrie)).geom) as pip
			from import.bauzonenstatistik_liegenschaft_nach_bebauungsstand
		) dump
		-- Kleinst-Teilpolygone eliminieren (unscharfe Verschnitte)
		where (ST_MaximumInscribedCircle(part)).radius > 0.2
		and ST_Area(part) > 0.5
		group by t_ili_tid, bfs_nr, grundnutzung_typ_kt, bebauungsstand
	),
	polys as (
	    select 
			t_ili_tid, 
			bfs_nr, 
			geometrie, 
			grundnutzung_typ_kt as typ_kt, 
			bebauungsstand, 
			flaeche, 
			pip
	    from baustat
	    union
	    select
			t_ili_tid, 
			bfs_nr, 
			ST_ReducePrecision(geometrie, 0.001) as geometrie, 
			typ_kt, 
			null::text as bebauungsstand, 
			st_area(geometrie) as flaeche, 
			ST_PointOnSurface(geometrie) as pip
	    from import.nutzungsplanung_grundnutzung
	    where (ST_MaximumInscribedCircle(geometrie)).radius > 0.2
		and ST_Area(geometrie) > 0.5
	)
	select 
	    t_ili_tid,
	    geometrie,
	    bfs_nr,
	    typ_kt,
	    substring(typ_kt, 2, 2) as typ_bund,
	    bebauungsstand,
	    flaeche,
	    case when bebauungsstand = 'bebaut' then flaeche else 0 end as flaeche_bebaut,
	    case when bebauungsstand = 'unbebaut' then flaeche else 0 end as flaeche_unbebaut,
	    case when bebauungsstand = 'teilweise_bebaut' then flaeche else 0 end as flaeche_teilweise_bebaut,
		pip
	from polys
	;

create index on export.parzellen_basis using gist (geometrie);
create index on export.parzellen_basis using gist (pip);
create index on export.parzellen_basis (t_ili_tid);
create index on export.parzellen_basis (bfs_nr);
create index on export.parzellen_basis (typ_kt);

-- Verschnitt Parzelle x Bodenbedeckung
drop table if exists export.parzellen_bodenbedeckung cascade;
create table export.parzellen_bodenbedeckung as
	select
	    p.t_ili_tid,
	    p.bfs_nr,
	    p.typ_kt,
	    mo.art_txt as kategorie_text,
	    sum(st_area(st_intersection(p.geometrie, mo.geometrie, 0.001))) as flaeche_agg
	from export.parzellen_basis p
	join import.mopublic_bodenbedeckung mo on st_intersects(p.geometrie, mo.geometrie)
	group by p.t_ili_tid, p.bfs_nr, p.typ_kt, mo.art_txt;
	;

create index on export.parzellen_bodenbedeckung (t_ili_tid);
create index on export.parzellen_bodenbedeckung (bfs_nr);
create index on export.parzellen_bodenbedeckung (typ_kt);
create index on export.parzellen_bodenbedeckung (kategorie_text);

-- Join Parzelle x GWR Gebäude
drop table if exists export.gebaeude cascade;
create table export.gebaeude as
	select
	    p.t_ili_tid,
	    p.typ_kt,
	    p.bfs_nr,
	    geb.egid,
	    geb.gkat,        -- Gebäudekategorie
	    geb.gkat_txt,
	    g.gklas_10,      -- Gebäudeklasse dreistellig
	    g.gklas_10_txt,
	    geb.gbaup,       -- Gebäudebauperiode
	    geb.gbaup_txt,
	    geb.garea,       -- Gebäudefläche
	    geb.gastw,       -- Anzahl Geschosse
		geb.lage as geometrie
	from export.parzellen_basis p
	join import.gwr_gebaeude geb on st_within(geb.lage, p.geometrie)
	left join export.gklas_10_map g on left(geb.gklas::text,3)::int = g.gklas_10
	where geb.gstat = 1004  -- nur existierende
	;

CREATE INDEX ON export.gebaeude using gist (geometrie);
CREATE INDEX ON export.gebaeude(t_ili_tid);
CREATE INDEX ON export.gebaeude(typ_kt);
CREATE INDEX ON export.gebaeude(bfs_nr);

-- Join Parzelle x GWR Wohnung
drop table if exists export.wohnung cascade;
create table export.wohnung as
	select
	    g.t_ili_tid,
	    g.typ_kt,
	    g.bfs_nr,
	    g.egid,
		g.geometrie,
	    w.ewid,
	    w.warea,       -- Wohnungsfläche
	    w.wazim        -- Anzahl Zimmer
	from export.gebaeude g
	left join import.gwr_wohnung w using (egid)
	;

CREATE INDEX ON export.wohnung using gist (geometrie);
CREATE INDEX ON export.wohnung(t_ili_tid);
CREATE INDEX ON export.wohnung(typ_kt);
CREATE INDEX ON export.wohnung(bfs_nr);

-- Join Parzelle x STATPOP
drop table if exists export.statpop cascade;
create table export.statpop as
	select
	    p.t_ili_tid,
	    p.typ_kt,
	    p.bfs_nr,
		p.geometrie,
	    pop.classagefiveyears
	from export.parzellen_basis p
	join import.statpop_statent_statpop pop on st_within(pop.geometrie, p.geometrie)
	;

CREATE INDEX ON export.statpop(t_ili_tid);
CREATE INDEX ON export.statpop(typ_kt);
CREATE INDEX ON export.statpop(bfs_nr);

-- Join Parzelle x STATENT
drop table if exists export.statent cascade;
create table export.statent as
	select
	    p.t_ili_tid,
	    p.typ_kt,
	    p.bfs_nr,
		p.geometrie,
	    ent.empfte
	from export.parzellen_basis p
	join import.statpop_statent_statent ent on st_within(ent.geometrie, p.geometrie)
	;

CREATE INDEX ON export.statent(t_ili_tid);
CREATE INDEX ON export.statent(typ_kt);
CREATE INDEX ON export.statent(bfs_nr);

-- AGGREGATIONEN -------------------------------------------------------------------------
-- GRUNDNUTZUNG: Aggregiert auf Parzellen-Ebene (Array) (faktisch keine Aggregation nötig)
drop table if exists export.parzellen_grundnutzungen_array cascade;
create table export.parzellen_grundnutzungen_array as
	select
		t_ili_tid,
	    jsonb_build_array(jsonb_BUILD_OBJECT(
	    	'@type', 'SO_ARP_SEin_Strukturdaten_Publikation_20250407.Strukturdaten.Grundnutzung_Kanton',
	    	'Kategorie_Text', typ_kt,
	    	'Flaeche', round(flaeche::numeric, 2)
	    )) as grundnutzungen_kanton,
	    jsonb_build_array(jsonb_BUILD_OBJECT(
	        '@type', 'SO_ARP_SEin_Strukturdaten_Publikation_20250407.Strukturdaten.Grundnutzung_Bund',
	        'Kategorie_Text', typ_bund,
	        'Flaeche', round(flaeche::numeric, 2)
	    )) as grundnutzungen_bund
	FROM export.parzellen_basis
	;

-- BODENBEDECKUNG: Aggregiert auf Parzellen-Ebene (Array)
drop table if exists export.parzellen_bodenbedeckungen_array cascade;
create table export.parzellen_bodenbedeckungen_array as
	select
		t_ili_tid,
		jsonb_agg(jsonb_build_object(
			'@type', 'SO_ARP_SEin_Strukturdaten_Publikation_20250407.Strukturdaten.Bodenbedeckung',
			'Kategorie_Text', kategorie_text,
			'Flaeche', round(flaeche_agg::numeric, 2)
		)) as bodenbedeckungen
	from export.parzellen_bodenbedeckung
	where round(flaeche_agg::numeric, 2) > 0
	group by t_ili_tid
	;

-- GWR GEBÄUDE: Aggregiert auf Parzellen-Ebene (Arrays)
drop table if exists export.parzellen_gwr_array cascade;
create table export.parzellen_gwr_array as
	select
	    t_ili_tid,
	    (
	        SELECT jsonb_agg(jsonb_build_object(
	            '@type', 'SO_ARP_SEin_Strukturdaten_Publikation_20250407.Strukturdaten.Gebaeudekategorie',
	            'Kategorie_Id', gkat_group.gkat,
	            'Kategorie_Text', gkat_group.gkat_txt,
	            'Anzahl', gkat_group.anzahl
	        ))
	        FROM (
	            SELECT gkat, gkat_txt, COUNT(*) as anzahl
	            FROM export.gebaeude g2
	            WHERE g2.t_ili_tid = g1.t_ili_tid
	            and gkat is not null
	            GROUP BY gkat, gkat_txt
	        ) gkat_group
	    ) gebaeudekategorien,
	    (
	        SELECT jsonb_agg(jsonb_build_object(
	            '@type', 'SO_ARP_SEin_Strukturdaten_Publikation_20250407.Strukturdaten.Gebaeudeklasse_10',
	            'Kategorie_Id', gklas_group.gklas_10,
	            'Kategorie_Text', gklas_group.gklas_10_txt,
	            'Anzahl', gklas_group.anzahl
	        ))
	        FROM (
	            SELECT gklas_10, gklas_10_txt, COUNT(*) as anzahl
	            FROM export.gebaeude g2
	            WHERE g2.t_ili_tid = g1.t_ili_tid
	            and gklas_10 is not null
	            GROUP BY gklas_10, gklas_10_txt
	        ) gklas_group
	    ) gebaeudeklassen_10,
	    (
	        SELECT jsonb_agg(jsonb_build_object(
	            '@type', 'SO_ARP_SEin_Strukturdaten_Publikation_20250407.Strukturdaten.Gebaeudebauperiode',
	            'Kategorie_Id', gbaup_group.gbaup,
	            'Kategorie_Text', gbaup_group.gbaup_txt,
	            'Anzahl', gbaup_group.anzahl
	        ))
	        FROM (
	            SELECT gbaup, gbaup_txt, COUNT(*) as anzahl
	            FROM export.gebaeude g2
	            WHERE g2.t_ili_tid = g1.t_ili_tid
	            and gbaup is not null
	            GROUP BY gbaup, gbaup_txt
	        ) gbaup_group
	    ) gebaeudebauperioden,
	    (
	        SELECT jsonb_agg(jsonb_build_object(
	            '@type', 'SO_ARP_SEin_Strukturdaten_Publikation_20250407.Strukturdaten.Anzahl_Zimmer',
	            'Kategorie_Id', wazim_group.wazim_cat,
	            'Kategorie_Text', case when wazim_cat >= 6 then '6+ Zimmer' else concat(wazim_cat, ' Zimmer') end,
	            'Anzahl', wazim_group.anzahl
	        ))
	        FROM (
	            SELECT 
	            	case when wazim >= 6 then 6 else wazim end as wazim_cat,
	            	COUNT(*) as anzahl
	            FROM export.wohnung w
	            WHERE w.t_ili_tid = g1.t_ili_tid
	            and wazim is not null
	            GROUP by case when wazim >= 6 then 6 else wazim end
	        ) wazim_group
	    ) verteilung_anzahl_zimmer
    FROM export.parzellen_basis g1
	;

-- GWR GEBÄUDE: Aggregiert auf Parzellen-Ebene (Summen und Anzahlen)
drop table if exists export.parzellen_gwr_geb_agg cascade;
create table export.parzellen_gwr_geb_agg as
    SELECT
        t_ili_tid,
        COUNT(egid) AS total_gebaeude,
        sum(garea) as flaeche_gebaeude,
        COUNT(*) FILTER (WHERE garea IS NULL) AS flaeche_gebaeude_anz_null,
        SUM(gastw) AS total_geschosse,
        round(AVG(gastw),2) AS anzahl_geschosse_avg,
        COUNT(*) FILTER (WHERE gastw IS NULL) AS anzahl_geschosse_anz_null
    FROM export.gebaeude
    GROUP BY t_ili_tid
    ;

 -- GWR WOHNUNG: Aggregiert auf Parzellen-Ebene (Summen und Anzahlen)
drop table if exists export.parzellen_gwr_wohn_agg cascade;
create table export.parzellen_gwr_wohn_agg as
	select
		t_ili_tid,
		COUNT(ewid) as total_wohnungen,
        CASE 
            WHEN COUNT(DISTINCT egid) = 0 THEN 0 
            ELSE round((COUNT(DISTINCT ewid) / COUNT(DISTINCT egid)),2)
        END AS anzahl_wohnungen_avg,
		sum(warea) as flaeche_wohnungen,
		round(avg(warea),2) as flaeche_wohnung_avg,
		count(*) filter (where warea is null) flaeche_wohnung_anz_null,
		sum(wazim) as total_zimmer,
		round(avg(wazim),2) as anzahl_zimmer_avg,
		count(*) filter (where wazim is null) anzahl_zimmer_anz_null
	from export.wohnung
	group by t_ili_tid
	;

-- STATPOP: Aggregiert auf Parzellen-Ebene
drop table if exists export.parzellen_statpop_array cascade;
create table export.parzellen_statpop_array as
    SELECT 
    	t_ili_tid,
    	sum(anzahl) as popcount,
    	jsonb_agg(jsonb_build_object(
	        '@type', 'SO_ARP_SEin_Strukturdaten_Publikation_20250407.Strukturdaten.Altersklasse_5j',
	        'Kategorie_Id', classagefiveyears,
			'Kategorie_Text', 
				case 
					when classagefiveyears between 0 and 110 then concat(classagefiveyears, '-', classagefiveyears + 4, ' Jahre')
					when classagefiveyears = 115 then '115+ Jahre'
				end
			,
	        'Anzahl', anzahl
		)) altersklassen_5j
    FROM (
        SELECT t_ili_tid, classagefiveyears, COUNT(*) as anzahl
        FROM export.statpop
        where classagefiveyears is not null
        GROUP BY t_ili_tid, classagefiveyears
    ) agg
   group by t_ili_tid;

 -- STATENT: Aggregiert auf Parzellen-Ebene
drop table if exists export.parzellen_statent_agg cascade;
create table export.parzellen_statent_agg as
	select
		t_ili_tid,
		sum(empfte) as beschaeftigte_fte
	from export.statent
	group by t_ili_tid
	;

-- FINALE TABELLE BEFÜLLEN (wird in nachgelagertem Task in die pub-db kopiert)
delete from export.strukturdaten_parzelle;
insert into export.strukturdaten_parzelle (geometrie, 
	flaeche, flaeche_bebaut, flaeche_unbebaut, flaeche_teilweise_bebaut, flaeche_gebaeude, flaeche_wohnungen, 
	handlungsraum, gemeindename, gemeindenummer,
	altersklassen_5j, beschaeftigte_fte, raumnutzendendichte, flaechendichte,
	grundnutzungen_kanton, grundnutzungen_bund,
	gebaeudekategorien, gebaeudeklassen_10,gebaeudebauperioden,
	total_gebaeude, total_geschosse, total_wohnungen, total_zimmer, 
	verteilung_anzahl_zimmer,
	anzahl_wohnungen_avg, anzahl_geschosse_avg, anzahl_geschosse_anz_null, anzahl_zimmer_avg, anzahl_zimmer_anz_null, flaeche_wohnung_avg, flaeche_wohnung_anz_null, flaeche_gebaeude_anz_null,
	bodenbedeckungen
	)
select
    -- "coalesce" wird angewendet, um NULL Werte zu vemeiden, wenn kein Objekt gejoined ist (Gebäude, Wohnung, Person, Firma)
	a.geometrie,
	a.flaeche,
	a.flaeche_bebaut,
	a.flaeche_unbebaut,
	a.flaeche_teilweise_bebaut,
	coalesce(d.flaeche_gebaeude, 0) as flaeche_gebaeude,
	coalesce(e.flaeche_wohnungen, 0) as flaeche_wohnungen,
	g2.handlungsraum,
	g1.gemeindename,
	a.bfs_nr as gemeindenummer,
    h.altersklassen_5j,
	coalesce(i.beschaeftigte_fte, 0) as beschaeftigte_fte,
	coalesce(a.flaeche / (h.popcount + i.beschaeftigte_fte), 0) as raumnutzendendichte,
	coalesce((h.popcount + i.beschaeftigte_fte) / a.flaeche * 10000, 0) as flaechendichte,
	grundnutzungen_kanton,
	grundnutzungen_bund,
	c.gebaeudekategorien,
	c.gebaeudeklassen_10,
	c.gebaeudebauperioden,
	coalesce(d.total_gebaeude, 0) as total_gebaeude,
	coalesce(d.total_geschosse, 0) as total_geschosse,
	coalesce(e.total_wohnungen, 0) as total_wohnungen,
	coalesce(e.total_zimmer, 0) as total_zimmer,
	c.verteilung_anzahl_zimmer,
	coalesce(e.anzahl_wohnungen_avg, 0) as anzahl_wohnungen_avg,
	coalesce(d.anzahl_geschosse_avg, 0) as anzahl_geschosse_avg,
	coalesce(d.anzahl_geschosse_anz_null, 0) as anzahl_geschosse_anz_null,
	coalesce(e.anzahl_zimmer_avg, 0) as anzahl_zimmer_avg,
	coalesce(e.anzahl_zimmer_anz_null, 0) as anzahl_zimmer_anz_null,
	coalesce(e.flaeche_wohnung_avg, 0) as flaeche_wohnung_avg,
	coalesce(e.flaeche_wohnung_anz_null, 0) as flaeche_wohnung_anz_null,
	coalesce(d.flaeche_gebaeude_anz_null, 0) as flaeche_gebaeude_anz_null,
	b.bodenbedeckungen
from export.parzellen_basis a
left join export.parzellen_bodenbedeckungen_array b using (t_ili_tid)
left join export.parzellen_gwr_array c using (t_ili_tid)
left join export.parzellen_gwr_geb_agg d using (t_ili_tid)
left join export.parzellen_gwr_wohn_agg e using (t_ili_tid)
left join export.parzellen_grundnutzungen_array f using (t_ili_tid)
left join export.parzellen_statpop_array h using (t_ili_tid)
left join export.parzellen_statent_agg i using (t_ili_tid)
left join import.hoheitsgrenzen_gemeindegrenze g1 on a.bfs_nr = g1.bfs_gemeindenummer
left join import.grundlagen_gemeinde g2 on a.bfs_nr = g2.bfsnr
;