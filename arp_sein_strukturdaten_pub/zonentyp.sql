-- Dieses SQL File enthält SQL Querys, um Strukturdaten auf Ebene Zonentyp aufzubereiten.
-- Diese Daten sind auch Grundlage für die Datenebene Zonenschild (= Dump von Zonentyp) und Gemeinde.

-- Zonentyp
drop table if exists export.zonentyp_basis cascade;

create table export.zonentyp_basis (
	geometrie 					public.geometry(MultiPolygon, 2056),
	bfs_nr						integer,
	typ_kt						text,
	typ_bund					text,
	bebauungsstand				text,
	flaeche						numeric,
	flaeche_bebaut				numeric,
	flaeche_unbebaut			numeric,
	flaeche_teilweise_bebaut	numeric
);

insert into export.zonentyp_basis
	select
		ST_Union(
			ST_MakeValid(
				ST_ReducePrecision(
		        	ST_Buffer(
		        		ST_Buffer(
		        			geometrie, 0.25, 'join=mitre'
		        		), -0.25, 'join=mitre'
		        	), 0.001
		        ), 'method=structure'
	        ), 0.001
        ) as geometrie,
	    bfs_nr,
	    typ_kt,
	    typ_bund,
	    null as bebauungsstand,
	    ST_Area(ST_Union(geometrie)) as flaeche,
	    coalesce(sum(ST_Area(geometrie)) filter (where bebauungsstand = 'bebaut'), 0) as flaeche_bebaut,
	    coalesce(sum(ST_Area(geometrie)) filter (where bebauungsstand = 'unbebaut'), 0) as flaeche_unbebaut,
	    coalesce(sum(ST_Area(geometrie)) filter (where bebauungsstand = 'teilweise_bebaut'), 0) as flaeche_teilweise_bebaut
	from export.parzellen_basis
	group by typ_kt, typ_bund, bfs_nr
;

create index on export.zonentyp_basis using gist (geometrie);
create index on export.zonentyp_basis (typ_kt);
create index on export.zonentyp_basis (bfs_nr);

-- Zonentyp x Bodenbedeckung
drop table if exists export.zonentyp_bodenbedeckung cascade;

create table export.zonentyp_bodenbedeckung (
    bfs_nr			integer,
    typ_kt			text,
    kategorie_text	text,
    flaeche_agg		numeric
);

insert into export.zonentyp_bodenbedeckung
	select
	    bfs_nr,
	    typ_kt,
	    kategorie_text,
	    sum(flaeche_agg) as flaeche_agg
	from export.parzellen_bodenbedeckung
	group by typ_kt, bfs_nr, kategorie_text
;

create index on export.zonentyp_bodenbedeckung (typ_kt);
create index on export.zonentyp_bodenbedeckung (bfs_nr);
create index on export.zonentyp_bodenbedeckung (kategorie_text);

-- GRUNDNUTZUNG: Aggregiert auf Zonentyp-Ebene (Array)
drop table if exists export.zonentyp_grundnutzungen_array cascade;
create table export.zonentyp_grundnutzungen_array as
	select
		typ_kt,
		bfs_nr,
	    jsonb_build_array(jsonb_build_object(
	    	'@type', 'SO_ARP_SEin_Strukturdaten_Publikation_20250407.Strukturdaten.Grundnutzung_Kanton',
	    	'Kategorie_Text', typ_kt,
	    	'Flaeche', round(flaeche::numeric, 2)
	    )) as grundnutzungen_kanton,
	    jsonb_build_array(jsonb_build_object(
	        '@type', 'SO_ARP_SEin_Strukturdaten_Publikation_20250407.Strukturdaten.Grundnutzung_Bund',
	        'Kategorie_Text', typ_bund,
	        'Flaeche', round(flaeche::numeric, 2)
	    )) as grundnutzungen_bund
	FROM export.zonentyp_basis
;

-- BODENBEDECKUNG: Aggregiert auf Zonentyp-Ebene (Array)
drop table if exists export.zonentyp_bodenbedeckungen_array cascade;
create table export.zonentyp_bodenbedeckungen_array as
	select
		typ_kt,
		bfs_nr,
		jsonb_agg(jsonb_build_object(
			'@type', 'SO_ARP_SEin_Strukturdaten_Publikation_20250407.Strukturdaten.Bodenbedeckung',
			'Kategorie_Text', kategorie_text,
			'Flaeche', round(flaeche_agg::numeric, 2)
		)) as bodenbedeckungen
	from export.zonentyp_bodenbedeckung
	where round(flaeche_agg, 2) > 0
	group by typ_kt, bfs_nr
;

-- GWR: Gebäudedaten aggregiert auf Zonentyp-Ebene (Arrays)
drop table if exists export.zonentyp_gwr_array cascade;
create table export.zonentyp_gwr_array as
	select
	    typ_kt,
		bfs_nr,
	    (
	        select jsonb_agg(jsonb_build_object(
	            '@type', 'SO_ARP_SEin_Strukturdaten_Publikation_20250407.Strukturdaten.Gebaeudekategorie',
	            'Kategorie_Id', gkat_group.gkat,
	            'Kategorie_Text', gkat_group.gkat_txt,
	            'Anzahl', gkat_group.anzahl
	        ))
	        from (
	            select gkat, gkat_txt, count(*) as anzahl
	            from export.gebaeude g2
	            where g2.typ_kt = g1.typ_kt
	            and gkat is not null
	            group by gkat, gkat_txt
	        ) gkat_group
	    ) gebaeudekategorien,
	    (
	        select jsonb_agg(jsonb_build_object(
	            '@type', 'SO_ARP_SEin_Strukturdaten_Publikation_20250407.Strukturdaten.Gebaeudeklasse_10',
	            'Kategorie_Id', gklas_group.gklas_10,
	            'Kategorie_Text', gklas_group.gklas_10_txt,
	            'Anzahl', gklas_group.anzahl
	        ))
	        from (
	            select gklas_10, gklas_10_txt, count(*) as anzahl
	            from export.gebaeude g2
	            where g2.typ_kt = g1.typ_kt
	            and gklas_10 is not null
	            group by gklas_10, gklas_10_txt
	        ) gklas_group
	    ) gebaeudeklassen_10,
	    (
	        select jsonb_agg(jsonb_build_object(
	            '@type', 'SO_ARP_SEin_Strukturdaten_Publikation_20250407.Strukturdaten.Gebaeudebauperiode',
	            'Kategorie_Id', gbaup_group.gbaup,
	            'Kategorie_Text', gbaup_group.gbaup_txt,
	            'Anzahl', gbaup_group.anzahl
	        ))
	        from (
	            select gbaup, gbaup_txt, count(*) as anzahl
	            from export.gebaeude g2
	            where g2.typ_kt = g1.typ_kt
	            and gbaup is not null
	            group by gbaup, gbaup_txt
	        ) gbaup_group
	    ) gebaeudebauperioden,
	    (
	        select jsonb_agg(jsonb_build_object(
	            '@type', 'SO_ARP_SEin_Strukturdaten_Publikation_20250407.Strukturdaten.Anzahl_Zimmer',
	            'Kategorie_Id', wazim_group.wazim_cat,
	            'Kategorie_Text', case when wazim_cat >= 6 then '6+ Zimmer' else concat(wazim_cat, ' Zimmer') end,
	            'Anzahl', wazim_group.anzahl
	        ))
	        from (
	            select 
	            	case when wazim >= 6 then 6 else wazim end as wazim_cat,
	            	count(*) as anzahl
	            from export.wohnung w
	            where w.typ_kt = g1.typ_kt
	            and wazim is not null
	            group by case when wazim >= 6 then 6 else wazim end
	        ) wazim_group
	    ) verteilung_anzahl_zimmer
    from export.zonentyp_basis g1
;

-- GWR: Gebäudedaten aggregiert auf Zonentyp-Ebene (Summen und Anzahlen)
drop table if exists export.zonentyp_gwr_geb_agg cascade;

create table export.zonentyp_gwr_geb_agg (
    typ_kt						text,
    bfs_nr						integer,
    total_gebaeude				integer,
    flaeche_gebaeude			numeric,
    flaeche_gebaeude_anz_null	integer,
    total_geschosse				integer,
    anzahl_geschosse_avg		numeric,
    anzahl_geschosse_anz_null	integer   
);

insert into export.zonentyp_gwr_geb_agg
    select
        typ_kt,
		bfs_nr,
        count(egid) as total_gebaeude,
        sum(garea) as flaeche_gebaeude,
        count(*) filter (where garea is null) as flaeche_gebaeude_anz_null,
        sum(gastw) as total_geschosse,
        round(avg(gastw),2) as anzahl_geschosse_avg,
        count(*) filter (where gastw is null) as anzahl_geschosse_anz_null
    from export.gebaeude
    group by typ_kt, bfs_nr
;

 -- GWR: Wohnungsdaten aggregiert auf Zonentyp-Ebene (Summen und Anzahlen)
drop table if exists export.zonentyp_gwr_wohn_agg cascade;

create table export.zonentyp_gwr_wohn_agg (
    typ_kt						text,
    bfs_nr						integer,
	total_wohnungen				integer,
    anzahl_wohnungen_avg		numeric,
	flaeche_wohnungen			numeric,
	flaeche_wohnung_avg			numeric,
	flaeche_wohnung_anz_null	integer,
	total_zimmer				integer,
	anzahl_zimmer_avg			numeric,
	anzahl_zimmer_anz_null		integer
);

insert into export.zonentyp_gwr_wohn_agg
	select
		typ_kt,
		bfs_nr,
		count(ewid) as total_wohnungen,
        -- mind. 1 Wert muss nach numeric gecastet werden, damit keine integer division durchgeführt wird
    	round((count(ewid) / count(distinct egid)::numeric), 2) as anzahl_wohnungen_avg,
		sum(warea) as flaeche_wohnungen,
		round(avg(warea),2) as flaeche_wohnung_avg,
		count(*) filter (where warea is null) flaeche_wohnung_anz_null,
		sum(wazim) as total_zimmer,
		round(avg(wazim),2) as anzahl_zimmer_avg,
		count(*) filter (where wazim is null) anzahl_zimmer_anz_null
	from export.wohnung
	group by typ_kt, bfs_nr
;

-- STATPOP: Aggregiert auf Zonentyp-Ebene
drop table if exists export.zonentyp_statpop_array cascade;
create table export.zonentyp_statpop_array as
    select 
		typ_kt,
		bfs_nr,
    	sum(anzahl)::integer as popcount,
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
    from (
        select typ_kt, bfs_nr, classagefiveyears, count(*) as anzahl
        from export.statpop
        where classagefiveyears is not null
        group by typ_kt, bfs_nr, classagefiveyears
    ) agg
    group by typ_kt, bfs_nr
;

-- STATENT: Aggregiert auf Zonentyp-Ebene
drop table if exists export.zonentyp_statent_agg cascade;
create table export.zonentyp_statent_agg as
	select
		typ_kt,
		bfs_nr,
		sum(empfte) as beschaeftigte_fte
	from export.statent
	group by typ_kt, bfs_nr
;

delete from export.strukturdaten_zonentyp;
insert into export.strukturdaten_zonentyp (geometrie, 
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
	-- Raumnutzendendichte: division by zero vermeiden mit NULLIF
	a.flaeche / nullif(coalesce(h.popcount, 0) + coalesce(i.beschaeftigte_fte, 0), 0) as raumnutzendendichte,
	-- Flächendichte: Umrechnung von m2 auf ha = Faktor 10'000
	(coalesce(h.popcount, 0) + coalesce(i.beschaeftigte_fte, 0)) / a.flaeche * 10000 as flaechendichte,
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
from export.zonentyp_basis a
left join export.zonentyp_bodenbedeckungen_array b using (typ_kt, bfs_nr)
left join export.zonentyp_gwr_array c using (typ_kt, bfs_nr)
left join export.zonentyp_gwr_geb_agg d using (typ_kt, bfs_nr)
left join export.zonentyp_gwr_wohn_agg e using (typ_kt, bfs_nr)
left join export.zonentyp_grundnutzungen_array f using (typ_kt, bfs_nr)
left join export.zonentyp_statpop_array h using (typ_kt, bfs_nr)
left join export.zonentyp_statent_agg i using (typ_kt, bfs_nr)
left join import.hoheitsgrenzen_gemeindegrenze g1 on a.bfs_nr = g1.bfs_gemeindenummer
left join import.grundlagen_gemeinde g2 on a.bfs_nr = g2.bfsnr
;