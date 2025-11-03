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
	END AS eigentuemer,
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
	fb.t_id AS Forstbetrieb,
	w.bemerkung,
	l.geometrie
FROM 
	awjf_waldplan_bestandeskarte_v1.waldplan_bestandeskarte AS w
LEFT JOIN agi_dm01avso24.liegenschaften_liegenschaft AS l
	ON ST_Within(ST_PointOnSurface(w.geometrie), l.geometrie)
LEFT JOIN agi_dm01avso24.liegenschaften_grundstueck AS g
	ON l.liegenschaft_von = g.t_id
LEFT JOIN awjf_waldplan_v2.waldplankatalog_forstrevier AS f 
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
LEFT JOIN awjf_waldplan_v2.waldplankatalog_forstbetrieb AS fb 
	ON  (
			(w.fid_eigcod IN (502,100) AND fb.aname = 'FR Untergäu')
		OR (w.fid_eigcod = 107 AND fb.aname = 'Wangen bei Olten')
		OR (w.fid_eigcod = 101 AND fb.aname = 'Kappel')
		OR (w.fid_eigcod IN (436,515,517,444,509,113,114,115,111,112,612,707,718) AND fb.aname = 'Schwarzbubenland')
		OR (w.fid_eigcod = 518 AND fb.aname = 'Nunningen')
		OR (w.fid_eigcod = 120 AND fb.aname = 'Zullwil')
		OR (w.fid_eigcod IN (435,440,441,719) AND fb.aname = 'Am Blauen')
		OR (w.fid_eigcod IN (414,408,411,719) AND fb.aname = 'Forst Dünnerntal')
		OR (w.fid_eigcod IN (412,10,16) AND fb.aname = 'Forst Thal')
		OR (w.fid_eigcod IN (442,38,39,40) AND fb.aname = 'Dorneckberg')
		OR (w.fid_eigcod IN (508,117) AND fb.aname = 'Laufental-Thierstein West')
		OR (w.fid_eigcod IN (425,429,18,19,20,121,122,21,22,23,24,25,27,28,29,32,33,34,31) AND fb.aname = 'Bucheggberg')
		OR (w.fid_eigcod = 35 AND fb.aname = 'Unterramsern')
		OR (w.fid_eigcod = 123 AND fb.aname = 'Brunnenthal')
		OR (w.fid_eigcod IN (484,80,82,84,87,88,124,89,128,90,91,92,716,712,717) AND fb.aname = 'Leberberg')
		OR (w.fid_eigcod = 79 AND fb.aname = 'Bellach')
		OR (w.fid_eigcod = 485 AND fb.aname = 'Kammersohr')
		OR (w.fid_eigcod IN (47,49,54,55,56,102,710,706) AND fb.aname = 'Unterer Hauenstein')
		OR (w.fid_eigcod IN (93,99,2,4,705) AND fb.aname = 'Forst Mittleres Gäu')
		OR (w.fid_eigcod = 496 AND fb.aname = 'Fulenbach')
		OR (w.fid_eigcod = 1 AND fb.aname = 'Egerkingen')
		OR (w.fid_eigcod IN (452,493,95,98,104,105,51) AND fb.aname = 'Niederamt')
		OR (w.fid_eigcod = 456 AND fb.aname = 'Erlinsbach')
		OR (w.fid_eigcod = 106 AND fb.aname = 'Walterswil')
		OR (w.fid_eigcod = 50 AND fb.aname = 'Niedergösgen')
		OR (w.fid_eigcod = 127 AND fb.aname = 'Obererlinsbach')
		OR (w.fid_eigcod = 447 AND fb.aname = 'Kienberg')
		OR (w.fid_eigcod = 108 AND fb.aname = 'Solothurn')
		OR (w.fid_eigcod = 83 AND fb.aname = 'Grenchen')
		OR (w.fid_eigcod IN (7,701) AND fb.aname = 'Oensingen')
		OR (w.fid_eigcod = 405 AND fb.aname = 'Oberbuchsiten')
		OR (w.fid_eigcod = 3 AND fb.aname = 'Kestenholz')
		OR (w.fid_eigcod = 5 AND fb.aname = 'Niederbuchsiten')
		OR (w.fid_eigcod = 8 AND fb.aname = 'Wolfwil')
		OR (w.fid_eigcod = 711 AND fb.aname = 'Staatswald Buchban')
		OR (w.fid_eigcod = 473 AND fb.aname = 'Wasseramt AG')
		OR (w.fid_eigcod = 58 AND fb.aname = 'Aeschi')
		OR (w.fid_eigcod = 126 AND fb.aname = 'Ammannsegg')
		OR (w.fid_eigcod = 59 AND fb.aname = 'Biberist')
		OR (w.fid_eigcod = 60 AND fb.aname = 'Bolken')
		OR (w.fid_eigcod = 61 AND fb.aname = 'Deitingen')
		OR (w.fid_eigcod = 62 AND fb.aname = 'Derendingen')
		OR (w.fid_eigcod = 63 AND fb.aname = 'Etziken')
		OR (w.fid_eigcod = 64 AND fb.aname = 'Gerlafingen')
		OR (w.fid_eigcod = 65 AND fb.aname = 'Halten')
		OR (w.fid_eigcod = 68 AND fb.aname = 'Horriwil')
		OR (w.fid_eigcod = 468 AND fb.aname = 'Hüniken')
		OR (w.fid_eigcod = 469 AND fb.aname = 'Krigestetten')
		OR (w.fid_eigcod = 71 AND fb.aname = 'Lohn')
		OR (w.fid_eigcod = 72 AND fb.aname = 'Luterbach')
		OR (w.fid_eigcod = 73 AND fb.aname = 'Obergerlafingen')
		OR (w.fid_eigcod = 75 AND fb.aname = 'Recherswil')
		OR (w.fid_eigcod = 76 AND fb.aname = 'Subingen')
		OR (w.fid_eigcod = 66 AND fb.aname = 'Winistorf')
		OR (w.fid_eigcod = 77 AND fb.aname = 'Zuchwil')
		OR (w.fid_eigcod = 520 AND fb.aname = 'Drei Höfe')
	)

),

datasets_baskets AS (
SELECT
	b.t_id AS t_basket,
	d.datasetname AS t_datasetname,
	l.egrid,
	l.eigentuemer,
	l.Zusatzinformation,
	l.Forstkreis,
	l.Wirtschaftszone,
	l.Ausserkantonal,
	l.Forstrevier,
	l.Forstbetrieb,
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
	eigentuemer,
	Zusatzinformation,
	Forstkreis,
	Wirtschaftszone,
	Ausserkantonal,
	Bemerkung,
	Forstrevier,
	Forstbetrieb,
	t_lastchange,
	t_createdate,
	t_user
)

SELECT DISTINCT
	t_basket,
	t_datasetname,
	egrid,
	eigentuemer,
	Zusatzinformation,
	Forstkreis,
	Wirtschaftszone,
	Ausserkantonal,
	string_agg(DISTINCT bemerkung, E'\n') AS bemerkung,
	Forstrevier,
	Forstbetrieb,
	CURRENT_TIMESTAMP AS t_lastchange,
	CURRENT_TIMESTAMP AS t_createdate,
	'Datenmigration' t_user
FROM
	datasets_baskets
GROUP BY 
	t_basket,
	t_datasetname,
	egrid,
	eigentuemer,
	Zusatzinformation,
	Forstkreis,
	Wirtschaftszone,
	Ausserkantonal,
	Forstrevier,
	Forstbetrieb