DELETE FROM awjf_waldplan_v2.waldplan_waldeigentum;

WITH

liegenschaften AS (
SELECT DISTINCT
	g.egris_egrid AS egrid,
	we_text,
	fid_eigcod,
	CASE 
		WHEN fid_eigcod BETWEEN 1 AND 199
			THEN 'Buergergemeinde'
		WHEN fid_eigcod BETWEEN 200 AND 399
			THEN 'Einwohnergemeinde'
		WHEN fid_eigcod BETWEEN 400 AND 599
			THEN 'Einheitsgemeinde'
		WHEN fid_eigcod = 602
			THEN 'Staatswald_Allgemein'
		WHEN fid_eigcod = 603 AND we_text LIKE 'BG %'
			THEN 'Buergergemeinde'
		WHEN fid_eigcod = 603 AND we_text LIKE 'EG %'
			THEN 'Einwohnergemeinde'
		WHEN fid_eigcod = 603 AND we_text LIKE 'GE %'
			THEN 'Einheitsgemeinde'	
		WHEN fid_eigcod = 606
			THEN 'Privatwald'
		WHEN fid_eigcod = 611
			THEN 'Einwohnergemeinde'
		WHEN fid_eigcod = 612
			THEN 'Kirchgemeinde'
		WHEN fid_eigcod = 621
			THEN 'Bundeswald_Militaer'
		WHEN fid_eigcod = 622
			THEN 'Bundeswald_SBB'
		WHEN fid_eigcod = 623
			THEN 'Bundeswald_ASTRA'
		WHEN fid_eigcod IN (600,624)
			THEN 'Bundeswald_Andere'
		WHEN fid_eigcod BETWEEN 701 AND 799
			THEN 'Staatswald_Forstbetrieb'
		ELSE NULL
	END AS Typ,
	CASE 
		WHEN position(' ' IN we_text) >0
			THEN split_part(we_text, ' ', 2) ||
				CASE 
					WHEN array_length(string_to_array(we_text, ' '), 1)>2
						THEN ' ' || substring(we_text from position(' ' in we_text)+1+length(split_part(we_text,' ',2)))
                                    ELSE ''
                    END
             ELSE NULL				
	END AS Zusatzinformation,
	CASE
		WHEN fid_fk = 1
			THEN 'Region_Solothurn'
		WHEN fid_fk = 3
			THEN 'Thal_Gaeu'
		WHEN fid_fk = 4
			THEN 'Olten_Goesgen'
		WHEN fid_fk = 6
			THEN 'Dorneck_Thierstein'
	END AS Forstkreis,
	CASE
		WHEN wirt_zone = 1
			THEN 'Jura'
		WHEN wirt_zone = 2
			THEN 'Mittelland'
	END AS Wirtschaftszone,
	CASE 
		WHEN fid_eigcod = 603
			THEN TRUE
		ELSE FALSE
	END AS Ausserkantonal,
	gem_bfs AS bfsnr,
	f.t_id AS Forstrevier,
	w.bemerkung,
	l.geometrie
FROM 
	awjf_waldplan_bestandeskarte_v1.waldplan_bestandeskarte AS w
LEFT JOIN agi_dm01avso24.liegenschaften_liegenschaft AS l
	ON ST_Within(ST_PointOnSurface(w.geometrie), l.geometrie)
LEFT JOIN agi_dm01avso24.liegenschaften_grundstueck AS g
	ON l.liegenschaft_von = g.t_id
LEFT JOIN awjf_waldplan_v2.waldplancatalgues_forstrevier AS f 
	ON (
			(w.fid_fr = 1 AND f.aname = 'Grenchen')
		OR ( w.fid_fr = 2 AND f.aname = 'Leberberg')
		OR ( w.fid_fr = 3 AND f.aname = 'Bucheggberg')
		OR ( w.fid_fr = 4 AND f.aname = 'Wasseramt')
		OR ( w.fid_fr = 5 AND f.aname = 'Solothurn')
		OR ( w.fid_fr = 6 AND f.aname = 'Vorderes Thal')
		OR ( w.fid_fr = 8 AND f.aname = 'Dünnerntal')
		OR ( w.fid_fr = 9 AND f.aname = 'Roggen')
		OR ( w.fid_fr = 10 AND f.aname = 'Oberes Gäu')
		OR ( w.fid_fr = 11 AND f.aname = 'Mittleres Gäu')
		OR ( w.fid_fr = 13 AND f.aname = 'Untergäu')
		OR ( w.fid_fr = 15 AND f.aname = 'Unterer Hauenstein')
		OR ( w.fid_fr = 18 AND f.aname = 'Niederamt')
		OR ( w.fid_fr = 19 AND f.aname = 'Dorneckberg Nord')
		OR ( w.fid_fr = 20 AND f.aname = 'Schwarzbubenland')
		OR ( w.fid_fr = 21 AND f.aname = 'Am Blauen')
		OR ( w.fid_fr = 24 AND f.aname = 'Thierstein West/Laufental')
		)

),

datasets_baskets AS (
SELECT
	b.t_id AS t_basket,
	d.datasetname AS t_datasetname,
	l.egrid,
	l.Typ,
	l.Zusatzinformation,
	l.Forstkreis,
	l.Wirtschaftszone,
	l.Ausserkantonal,
	l.Forstrevier,
	l.bemerkung
FROM
	liegenschaften AS l
LEFT JOIN awjf_waldplan_v2.t_ili2db_dataset AS d
	ON l.bfsnr::text = d.datasetname
LEFT JOIN awjf_waldplan_v2.t_ili2db_basket AS b
	ON d.t_id = b.dataset
)

INSERT INTO awjf_waldplan_v2.waldplan_waldeigentum (
	t_basket,
	t_datasetname,
	egrid,
	Typ,
	Zusatzinformation,
	Forstkreis,
	Wirtschaftszone,
	Ausserkantonal,
	Bemerkung,
	Forstrevier,
	t_lastchange,
	t_createdate,
	t_user
)

SELECT DISTINCT
	t_basket,
	t_datasetname,
	egrid,
	Typ,
	Zusatzinformation,
	Forstkreis,
	Wirtschaftszone,
	Ausserkantonal,
	string_agg(DISTINCT bemerkung, E'\n') AS bemerkung,
	Forstrevier,
	CURRENT_TIMESTAMP AS t_lastchange,
	CURRENT_TIMESTAMP AS t_createdate,
	'Datenmigration' t_user
FROM
	datasets_baskets
GROUP BY 
	t_basket,
	t_datasetname,
	egrid,
	Typ,
	Zusatzinformation,
	Forstkreis,
	Wirtschaftszone,
	Ausserkantonal,
	Forstrevier