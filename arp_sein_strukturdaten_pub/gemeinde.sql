-- Dieses SQL File enthält SQL Querys, um Strukturdaten auf Ebene Gemeinde aufzubereiten.

-- Gemeinde-Flächenattribute aus Parzellen ableiten
drop table if exists export.gemeinde_basis cascade;

create table export.gemeinde_basis (
	geometrie					public.geometry(MultiPolygon, 2056),
	gemeindename				text,
	bfs_nr						integer,
	flaeche						numeric,
	flaeche_bebaut				numeric,
	flaeche_unbebaut			numeric,
	flaeche_teilweise_bebaut	numeric
);

insert into export.gemeinde_basis
	select
		g.geometrie,
	    g.gemeindename,
	    g.bfs_gemeindenummer as bfs_nr,
	    sum(flaeche) as flaeche,
	    coalesce(sum(flaeche) filter (where bebauungsstand = 'bebaut'), 0) as flaeche_bebaut,
	    coalesce(sum(flaeche) filter (where bebauungsstand = 'unbebaut'), 0) as flaeche_unbebaut,
	    coalesce(sum(flaeche) filter (where bebauungsstand = 'teilweise_bebaut'), 0) as flaeche_teilweise_bebaut
	from import.hoheitsgrenzen_gemeindegrenze g
	join export.parzellen_basis p on g.bfs_gemeindenummer = p.bfs_nr
	group by g.geometrie, g.gemeindename, g.bfs_gemeindenummer
;

create index on export.gemeinde_basis using gist (geometrie);
create index on export.gemeinde_basis (bfs_nr);

-- Gemeinde x Bodenbedeckung
drop table if exists export.gemeinde_bodenbedeckung cascade;

create table export.gemeinde_bodenbedeckung (
    bfs_nr			integer,
    kategorie_text	text,
    flaeche_agg		numeric
);

insert into export.gemeinde_bodenbedeckung
	select
	    bfs_nr,
	    kategorie_text,
	    sum(flaeche_agg) as flaeche_agg
	from export.parzellen_bodenbedeckung
	group by bfs_nr, kategorie_text
;

create index on export.gemeinde_bodenbedeckung (bfs_nr);

-- GRUNDNUTZUNG: Aggregiert auf Gemeinde-Ebene (Array)
drop table if exists export.gemeinde_grundnutzungen_array cascade;
create table export.gemeinde_grundnutzungen_array as
	with zonentyp_basis_agg as (
	    select
	        bfs_nr,
	        typ_kt,
	        typ_bund,
            flaeche,
	        sum(flaeche) over (partition by bfs_nr, typ_bund) as flaeche_bund_agg
	    from export.zonentyp_basis
	)
	select
		bfs_nr,
	    jsonb_agg(jsonb_build_object(
	    	'@type', 'SO_ARP_SEin_Strukturdaten_Publikation_20250407.Strukturdaten.Grundnutzung_Kanton',
	    	'Kategorie_Text', typ_kt,
	    	'Flaeche', round(flaeche::numeric, 2)
	    )) as grundnutzungen_kanton,
	    jsonb_agg(distinct jsonb_build_object(
	        '@type', 'SO_ARP_SEin_Strukturdaten_Publikation_20250407.Strukturdaten.Grundnutzung_Bund',
	        'Kategorie_Text', typ_bund,
	        'Flaeche', round(flaeche_bund_agg::numeric, 2)
	    )) as grundnutzungen_bund
	from zonentyp_basis_agg
	group by bfs_nr
;

-- bodenbedeckung: aggregiert auf gemeinde-ebene (array)
drop table if exists export.gemeinde_bodenbedeckungen_array cascade;
create table export.gemeinde_bodenbedeckungen_array as
	select
		bfs_nr,
		jsonb_agg(jsonb_build_object(
			'@type', 'SO_ARP_SEin_Strukturdaten_Publikation_20250407.Strukturdaten.Bodenbedeckung',
			'Kategorie_Text', kategorie_text,
			'Flaeche', round(flaeche_agg::numeric, 2)
		)) as bodenbedeckungen
	from export.gemeinde_bodenbedeckung
	where round(flaeche_agg::numeric, 2) > 0
	group by bfs_nr
;

-- GWR: Gebäudedaten aggregiert auf Gemeinde-Ebene (Arrays)
drop table if exists export.gemeinde_gwr_array cascade;
create table export.gemeinde_gwr_array as
	select
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
	            where g2.bfs_nr = g1.bfs_nr
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
	            where g2.bfs_nr = g1.bfs_nr
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
	            where g2.bfs_nr = g1.bfs_nr
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
	            where w.bfs_nr = g1.bfs_nr
	            and wazim is not null
	            group by case when wazim >= 6 then 6 else wazim end
	        ) wazim_group
	    ) verteilung_anzahl_zimmer
    from export.gemeinde_basis g1
;

-- GWR: Gebäudedaten aggregiert auf Zonenschild-Ebene (Summen und Anzahlen)
drop table if exists export.gemeinde_gwr_geb_agg cascade;

create table export.gemeinde_gwr_geb_agg (
    bfs_nr						integer,
    total_gebaeude				integer,
    flaeche_gebaeude			numeric,
    flaeche_gebaeude_anz_null	integer,
    total_geschosse				integer,
    anzahl_geschosse_avg		numeric,
    anzahl_geschosse_anz_null	integer   
);

insert into export.gemeinde_gwr_geb_agg
    select
        bfs_nr,
        count(egid) as total_gebaeude,
        sum(garea) as flaeche_gebaeude,
        count(*) filter (where garea is null) as flaeche_gebaeude_anz_null,
        sum(gastw) as total_geschosse,
        round(avg(gastw),2) as anzahl_geschosse_avg,
        count(*) filter (where gastw is null) as anzahl_geschosse_anz_null
    from export.gebaeude
    group by bfs_nr
    ;

 -- GWR: Wohnungsdaten aggregiert auf Zonentyp-Ebene (Summen und Anzahlen)
drop table if exists export.gemeinde_gwr_wohn_agg cascade;

create table export.gemeinde_gwr_wohn_agg (
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

insert into export.gemeinde_gwr_wohn_agg
	select
		bfs_nr,
		count(ewid) as total_wohnungen,
        case 
            when count(distinct egid) = 0 then 0 
            else round((count(distinct ewid) / count(distinct egid)),2)
        end as anzahl_wohnungen_avg,
		sum(warea) as flaeche_wohnungen,
		round(avg(warea),2) as flaeche_wohnung_avg,
		count(*) filter (where warea is null) flaeche_wohnung_anz_null,
		sum(wazim) as total_zimmer,
		round(avg(wazim),2) as anzahl_zimmer_avg,
		count(*) filter (where wazim is null) anzahl_zimmer_anz_null
	from export.wohnung
	group by bfs_nr
;

-- STATPOP: Aggregiert auf Gemeinde-Ebene
drop table if exists export.gemeinde_statpop_array cascade;
create table export.gemeinde_statpop_array as
    select 
		bfs_nr,
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
    from (
        select bfs_nr, classagefiveyears, count(*) as anzahl
        from export.statpop
        where classagefiveyears is not null
        group by bfs_nr, classagefiveyears
    ) agg
    group by bfs_nr
    ;

-- STATENT: Aggregiert auf Gemeinde-Ebene
drop table if exists export.gemeinde_statent_agg cascade;
create table export.gemeinde_statent_agg as
	select
		bfs_nr,
		sum(empfte) as beschaeftigte_fte
	from export.statent
	group by bfs_nr
;

delete from export.strukturdaten_gemeinde;
insert into export.strukturdaten_gemeinde (geometrie, 
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
	g.handlungsraum,
	a.gemeindename,
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
from export.gemeinde_basis a
left join export.gemeinde_bodenbedeckungen_array b using (bfs_nr)
left join export.gemeinde_gwr_array c using (bfs_nr)
left join export.gemeinde_gwr_geb_agg d using (bfs_nr)
left join export.gemeinde_gwr_wohn_agg e using (bfs_nr)
left join export.gemeinde_grundnutzungen_array f using (bfs_nr)
left join export.gemeinde_statpop_array h using (bfs_nr)
left join export.gemeinde_statent_agg i using (bfs_nr)
left join import.grundlagen_gemeinde g on a.bfs_nr = g.bfsnr
;