-- Dieses SQL File enthält SQL Querys, um Strukturdaten auf Ebene Zonenschild aufzubereiten.

-- Zonenschild aus Zonentyp ableiten
drop table if exists export.zonenschild_dump cascade;
create table export.zonenschild_dump as
	select
		uuid_generate_v4() as schild_uuid,
	    typ_kt,
	    typ_bund,
	    bfs_nr,
		(ST_Dump(geometrie)).geom as geometrie
	from export.zonentyp_basis
	;

create index on export.zonenschild_dump using gist (geometrie);

-- Zonenschild-Flächenattribute aus Parzellen ableiten
drop table if exists export.zonenschild_basis cascade;
create table export.zonenschild_basis as
	select
		z.schild_uuid,
		z.geometrie,
	    z.typ_kt,
	    z.typ_bund,
	    z.bfs_nr,
	    sum(flaeche) as flaeche,
	    coalesce(sum(flaeche) filter (where bebauungsstand = 'bebaut'), 0) as flaeche_bebaut,
	    coalesce(sum(flaeche) filter (where bebauungsstand = 'unbebaut'), 0) as flaeche_unbebaut,
	    coalesce(sum(flaeche) filter (where bebauungsstand = 'teilweise_bebaut'), 0) as flaeche_teilweise_bebaut
	from export.zonenschild_dump z
	join export.parzellen_basis p on st_intersects(p.pip, z.geometrie)  -- tbd Denkfehler: ein Zonenschild kann kleiner sein als Parzelle, ich darf nicht die ganze Parzelle joinen!
	group by z.schild_uuid, z.geometrie, z.typ_kt, z.typ_bund, z.bfs_nr
	;

create index on export.zonenschild_basis using gist (geometrie);

-- Zonenschild x Bodenbedeckung
drop table if exists export.zonenschild_bodenbedeckung cascade;
create table export.zonenschild_bodenbedeckung as
	select
	    z.schild_uuid,
	    b.kategorie_text,
	    sum(b.flaeche_agg) as flaeche_agg
	from export.zonenschild_basis z
	join export.parzellen_basis p on st_intersects(p.pip, z.geometrie)  -- tbd Denkfehler: ein Zonenschild kann kleiner sein als Parzelle, ich darf nicht die ganze Parzelle joinen!
	join export.parzellen_bodenbedeckung b using (t_ili_tid)
	group by z.schild_uuid, b.kategorie_text
	;

create index on export.zonenschild_bodenbedeckung (kategorie_text);

-- GRUNDNUTZUNG: Aggregiert auf Zonenschild-Ebene (Array) (faktisch kein Aggregieren nötig)
drop table if exists export.zonenschild_grundnutzungen_array cascade;
create table export.zonenschild_grundnutzungen_array as
	select
		schild_uuid,
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
	FROM export.zonenschild_basis
	;

-- BODENBEDECKUNG: Aggregiert auf Zonenschild-Ebene (Array)
drop table if exists export.zonenschild_bodenbedeckungen_array cascade;
create table export.zonenschild_bodenbedeckungen_array as
	select
		schild_uuid,
		jsonb_agg(jsonb_build_object(
			'@type', 'SO_ARP_SEin_Strukturdaten_Publikation_20250407.Strukturdaten.Bodenbedeckung',
			'Kategorie_Text', kategorie_text,
			'Flaeche', round(flaeche_agg::numeric, 2)
		)) as bodenbedeckungen
	from export.zonenschild_bodenbedeckung
	where round(flaeche_agg::numeric, 2) > 0
	group by schild_uuid
	;

-- GWR Daten mit Zonenschild-ID anreichern
drop table if exists export.zonenschild_basis_geb cascade;
create table export.zonenschild_basis_geb as
	select g.*, z.schild_uuid
	from export.gebaeude g
	join export.zonenschild_basis z on st_within(g.geometrie, z.geometrie)
	;
create index on export.zonenschild_basis_geb using gist (geometrie);
CREATE INDEX ON export.zonenschild_basis_geb(schild_uuid);

drop table if exists export.zonenschild_basis_wohn cascade;
create table export.zonenschild_basis_wohn as
	select w.*, z.schild_uuid
	from export.wohnung w
	join export.zonenschild_basis z on st_within(w.geometrie, z.geometrie)
	;
create index on export.zonenschild_basis_wohn using gist (geometrie);
CREATE INDEX ON export.zonenschild_basis_wohn(schild_uuid);

-- GWR: Gebäudedaten aggregiert auf Zonenschild-Ebene (Arrays)
drop table if exists export.zonenschild_gwr_array cascade;
create table export.zonenschild_gwr_array as
	select
	    schild_uuid,
	    (
	        SELECT jsonb_agg(jsonb_build_object(
	            '@type', 'SO_ARP_SEin_Strukturdaten_Publikation_20250407.Strukturdaten.Gebaeudekategorie',
	            'Kategorie_Id', gkat_group.gkat,
	            'Kategorie_Text', gkat_group.gkat_txt,
	            'Anzahl', gkat_group.anzahl
	        ))
	        FROM (
	            SELECT gkat, gkat_txt, COUNT(*) as anzahl
	            FROM export.zonenschild_basis_geb g2
	            WHERE g2.schild_uuid = g1.schild_uuid
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
	            SELECT left(gklas::text,3)::int as gklas_10, 'tbd' as gklas_10_txt, COUNT(*) as anzahl
	            FROM export.zonenschild_basis_geb g2
	            WHERE g2.schild_uuid = g1.schild_uuid
	            and gklas is not null
	            GROUP BY left(gklas::text,3)
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
	            FROM export.zonenschild_basis_geb g2
	            WHERE g2.schild_uuid = g1.schild_uuid
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
	            FROM export.zonenschild_basis_wohn w
	            WHERE w.schild_uuid = g1.schild_uuid
	            and wazim is not null
	            GROUP by case when wazim >= 6 then 6 else wazim end
	        ) wazim_group
	    ) verteilung_anzahl_zimmer
    FROM export.zonenschild_basis g1
	;

-- GWR: Gebäudedaten aggregiert auf Zonenschild-Ebene (Summen und Anzahlen)
drop table if exists export.zonenschild_gwr_geb_agg cascade;
create table export.zonenschild_gwr_geb_agg as
    SELECT
        schild_uuid,
        COUNT(egid) AS total_gebaeude,
        sum(garea) as flaeche_gebaeude,
        COUNT(*) FILTER (WHERE garea IS NULL) AS flaeche_gebaeude_anz_null,
        SUM(gastw) AS total_geschosse,
        round(AVG(gastw),2) AS anzahl_geschosse_avg,
        COUNT(*) FILTER (WHERE gastw IS NULL) AS anzahl_geschosse_anz_null
    FROM export.zonenschild_basis_geb
    GROUP BY schild_uuid
    ;

 -- GWR: Wohnungsdaten aggregiert auf Zonentyp-Ebene (Summen und Anzahlen)
drop table if exists export.zonenschild_gwr_wohn_agg cascade;
create table export.zonenschild_gwr_wohn_agg as
	select
		schild_uuid,
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
	from export.zonenschild_basis_wohn
	group by schild_uuid
	;

-- STATPOP/STATENT Daten mit Zonenschild-ID anreichern
drop table if exists export.zonenschild_basis_statpop cascade;
create table export.zonenschild_basis_statpop as
	select pop.*, z.schild_uuid
	from export.statpop pop
	join export.zonenschild_basis z on st_within(pop.geometrie, z.geometrie)
	;
create index on export.zonenschild_basis_statpop using gist (geometrie);
CREATE INDEX ON export.zonenschild_basis_statpop(schild_uuid);

drop table if exists export.zonenschild_basis_statent cascade;
create table export.zonenschild_basis_statent as
	select ent.*, z.schild_uuid
	from export.statent ent
	join export.zonenschild_basis z on st_within(ent.geometrie, z.geometrie)
	;
create index on export.zonenschild_basis_statent using gist (geometrie);
CREATE INDEX ON export.zonenschild_basis_statent(schild_uuid);

-- STATPOP: Aggregiert auf Zonenschild-Ebene
drop table if exists export.zonenschild_statpop_array cascade;
create table export.zonenschild_statpop_array as
    SELECT 
		schild_uuid,
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
        SELECT schild_uuid, classagefiveyears, COUNT(*) as anzahl
        FROM export.zonenschild_basis_statpop
        where classagefiveyears is not null
        GROUP BY schild_uuid, classagefiveyears
    ) agg
    GROUP BY schild_uuid
    ;

-- STATENT: Aggregiert auf Zonenschild-Ebene
drop table if exists export.zonenschild_statent_agg cascade;
create table export.zonenschild_statent_agg as
	select
		schild_uuid,
		sum(empfte) as beschaeftigte_fte
	from export.zonenschild_basis_statent
	GROUP BY schild_uuid
	;

delete from export.strukturdaten_zonenschild;
insert into export.strukturdaten_zonenschild (geometrie, 
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
from export.zonenschild_basis a
left join export.zonenschild_bodenbedeckungen_array b using (schild_uuid)
left join export.zonenschild_gwr_array c using (schild_uuid)
left join export.zonenschild_gwr_geb_agg d using (schild_uuid)
left join export.zonenschild_gwr_wohn_agg e using (schild_uuid)
left join export.zonenschild_grundnutzungen_array f using (schild_uuid)
left join export.zonenschild_statpop_array h using (schild_uuid)
left join export.zonenschild_statent_agg i using (schild_uuid)
left join import.hoheitsgrenzen_gemeindegrenze g1 on a.bfs_nr = g1.bfs_gemeindenummer
left join import.grundlagen_gemeinde g2 on a.bfs_nr = g2.bfsnr
;