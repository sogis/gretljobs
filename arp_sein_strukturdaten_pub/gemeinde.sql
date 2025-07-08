-- Gemeinde tbd Erklärung

-- Gemeinde-Flächenattribute aus Parzellen ableiten  -- tbd könnte man auch Zonentypen ableiten?
drop table if exists export.gemeinde_basis cascade;
create table export.gemeinde_basis as
	select
		g.geometrie,
	    g.gemeindename,
	    g.bfs_gemeindenummer as bfs_nr,
	    sum(flaeche) as flaeche,  -- tbd Gemeindegebiet oder (aktuell) Summe der Bauzonen?
	    coalesce(sum(flaeche) filter (where bebauungsstand = 'bebaut'), 0) as flaeche_bebaut,
	    coalesce(sum(flaeche) filter (where bebauungsstand = 'unbebaut'), 0) as flaeche_unbebaut,
	    coalesce(sum(flaeche) filter (where bebauungsstand = 'teilweise_bebaut'), 0) as flaeche_teilweise_bebaut
	from import.hoheitsgrenzen_gemeindegrenze g
	join export.parzellen_basis p on g.bfs_gemeindenummer = p.bfs_nr
	group by g.geometrie, g.gemeindename, g.bfs_gemeindenummer
	;

create index on export.gemeinde_basis using gist (geometrie);
create index on export.gemeinde_basis (bfs_nr);

-- Gemeinde x Bodenbedeckung  -- tbd könnte man auch aus Zonentypen ableiten?
drop table if exists export.gemeinde_bodenbedeckung cascade;
create table export.gemeinde_bodenbedeckung as
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
	    SELECT
	        bfs_nr,
	        typ_kt,
	        typ_bund,
            flaeche,
	        SUM(flaeche) OVER (PARTITION BY bfs_nr, typ_bund) AS flaeche_bund_agg
	    FROM export.zonentyp_basis
	)
	select
		bfs_nr,
	    jsonb_agg(jsonb_BUILD_OBJECT(
	    	'@type', 'SO_ARP_SEin_Strukturdaten_Publikation_20250407.Strukturdaten.Grundnutzung_Kanton',
	    	'Kategorie_Text', typ_kt,
	    	'Flaeche', round(flaeche::numeric, 2)
	    )) as grundnutzungen_kanton,
	    jsonb_agg(distinct jsonb_BUILD_OBJECT(
	        '@type', 'SO_ARP_SEin_Strukturdaten_Publikation_20250407.Strukturdaten.Grundnutzung_Bund',
	        'Kategorie_Text', typ_bund,
	        'Flaeche', round(flaeche_bund_agg::numeric, 2)
	    )) as grundnutzungen_bund
	FROM zonentyp_basis_agg
	group by bfs_nr
	;

-- BODENBEDECKUNG: Aggregiert auf Gemeinde-Ebene (Array)
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
	        SELECT jsonb_agg(jsonb_build_object(
	            '@type', 'SO_ARP_SEin_Strukturdaten_Publikation_20250407.Strukturdaten.Gebaeudekategorie',
	            'Kategorie_Id', gkat_group.gkat,
	            'Kategorie_Text', gkat_group.gkat_txt,
	            'Anzahl', gkat_group.anzahl
	        ))
	        FROM (
	            SELECT gkat, gkat_txt, COUNT(*) as anzahl
	            FROM export.gebaeude g2
	            WHERE g2.bfs_nr = g1.bfs_nr
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
	            FROM export.gebaeude g2
	            WHERE g2.bfs_nr = g1.bfs_nr
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
	            FROM export.gebaeude g2
	            WHERE g2.bfs_nr = g1.bfs_nr
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
	            WHERE w.bfs_nr = g1.bfs_nr
	            and wazim is not null
	            GROUP by case when wazim >= 6 then 6 else wazim end
	        ) wazim_group
	    ) verteilung_anzahl_zimmer
    FROM export.gemeinde_basis g1
	;

-- GWR: Gebäudedaten aggregiert auf Zonenschild-Ebene (Summen und Anzahlen)
drop table if exists export.gemeinde_gwr_geb_agg cascade;
create table export.gemeinde_gwr_geb_agg as
    SELECT
        bfs_nr,
        COUNT(egid) AS total_gebaeude,
        sum(garea) as flaeche_gebaeude,
        COUNT(*) FILTER (WHERE garea IS NULL) AS flaeche_gebaeude_anz_null,
        SUM(gastw) AS total_geschosse,
        round(AVG(gastw),2) AS anzahl_geschosse_avg,
        COUNT(*) FILTER (WHERE gastw IS NULL) AS anzahl_geschosse_anz_null
    FROM export.gebaeude
    GROUP BY bfs_nr
    ;

 -- GWR: Wohnungsdaten aggregiert auf Zonentyp-Ebene (Summen und Anzahlen)
drop table if exists export.gemeinde_gwr_wohn_agg cascade;
create table export.gemeinde_gwr_wohn_agg as
	select
		bfs_nr,
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
	group by bfs_nr
	;

-- STATPOP: Aggregiert auf Gemeinde-Ebene (Arrays)
drop table if exists export.gemeinde_statpop_array cascade;
create table export.gemeinde_statpop_array as
    SELECT 
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
    FROM (
        SELECT bfs_nr, classagefiveyears, COUNT(*) as anzahl
        FROM export.statpop
        where classagefiveyears is not null
        GROUP BY bfs_nr, classagefiveyears
    ) agg
    GROUP BY bfs_nr
    ;

-- STATENT: Aggregiert auf Gemeinde-Ebene (Summen und Anzahlen)
drop table if exists export.gemeinde_statent_agg cascade;
create table export.gemeinde_statent_agg as
	select
		bfs_nr,
		sum(empfte) as beschaeftigte_fte
	from export.statent
	GROUP BY bfs_nr
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
	a.geometrie,
	a.flaeche,
	a.flaeche_bebaut,
	a.flaeche_unbebaut,
	a.flaeche_teilweise_bebaut,
	coalesce(d.flaeche_gebaeude,0) as flaeche_gebaeude,  -- wenn Attr alle NULL oder kein Gebäude gejoined: 0
	coalesce(e.flaeche_wohnungen,0) as flaeche_wohnungen,  -- dito
	g.handlungsraum,
	a.gemeindename,
	a.bfs_nr as gemeindenummer,
    h.altersklassen_5j,
	coalesce(i.beschaeftigte_fte,0) as beschaeftigte_fte,
	coalesce(a.flaeche / (h.popcount + i.beschaeftigte_fte), 0) as raumnutzendendichte,
	coalesce((h.popcount + i.beschaeftigte_fte) / a.flaeche * 10000, 0) as flaechendichte,
	grundnutzungen_kanton,
	grundnutzungen_bund,
	c.gebaeudekategorien,
	c.gebaeudeklassen_10,
	c.gebaeudebauperioden,
	coalesce(d.total_gebaeude,0) as total_gebaeude,  -- wenn kein Gebäude gejoined: 0
	coalesce(d.total_geschosse,0) as total_geschosse,  -- dito (attr od join)
	coalesce(e.total_wohnungen,0) as total_wohnungen,  -- wenn keine Wohnung gejoined: 0
	coalesce(e.total_zimmer,0) as total_zimmer,  -- dito attr od join
	c.verteilung_anzahl_zimmer,
	coalesce(e.anzahl_wohnungen_avg,0) as anzahl_wohnungen_avg,  -- dito
	coalesce(d.anzahl_geschosse_avg,0) as anzahl_geschosse_avg,  -- dito
	coalesce(d.anzahl_geschosse_anz_null,0) as anzahl_geschosse_anz_null,  --dito
	coalesce(e.anzahl_zimmer_avg,0) as anzahl_zimmer_avg,
	coalesce(e.anzahl_zimmer_anz_null,0) as anzahl_zimmer_anz_null,
	coalesce(e.flaeche_wohnung_avg,0) as flaeche_wohnung_avg,
	coalesce(e.flaeche_wohnung_anz_null,0) as flaeche_wohnung_anz_null,
	coalesce(d.flaeche_gebaeude_anz_null,0) as flaeche_gebaeude_anz_null,
	coalesce(b.bodenbedeckungen, '[]'::jsonb) as bodenbedeckungen  -- eigentlich ein Workaround; sollte nie NULL sein, aber Verschnittfehler in den Ausgangsdaten führen zu Kleinst-Bodenbedeckungen, die wegfallen
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