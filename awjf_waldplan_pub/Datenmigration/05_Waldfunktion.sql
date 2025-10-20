DELETE FROM awjf_waldplan_v2.waldfunktion;

WITH

waldfunktionen AS ( 
SELECT DISTINCT
	b.t_id AS t_basket,
	d.datasetname AS t_datasetname,
	CASE 
		WHEN wpnr = 501
			THEN 'Wirtschaftswald'
		WHEN wpnr = 502
			THEN 'Schutzwald'
		WHEN wpnr = 503
			THEN 'Erholungswald'
		WHEN wpnr = 504
			THEN 'Biodiversitaet'
		WHEN wpnr = 505
			THEN 'Schutzwald_Biodiversitaet'
	END AS funktion,
	objnummer AS biodiversitaet_id,
	CASE 
		WHEN bsttyp = 71
			THEN 'Wytweide'
		WHEN bsttyp = 72
			THEN 'Lebensraum_prioritaer'
		WHEN bsttyp = 73
			THEN 'Lichter_Wald'
		WHEN bsttyp = 75
			THEN 'Altholzinsel'
		WHEN bsttyp = 76
			THEN 'Andere_Foerderflaeche'
		WHEN bsttyp = 77
			THEN 'Waldrand'
		WHEN bsttyp = 79
			THEN 'Waldreservat'
	END AS Biodiversitaet_Objekt,
	CASE 
		WHEN bsttyp = 71
			THEN TRUE
		ELSE
			FALSE
	END AS Wytweide,
	geometrie
FROM 
	awjf_waldplan_bestandeskarte_v1.waldplan_bestandeskarte AS w
LEFT JOIN awjf_waldplan_v2.t_ili2db_dataset AS d
	ON w.gem_bfs::text = d.datasetname
LEFT JOIN awjf_waldplan_v2.t_ili2db_basket AS b
	ON d.t_id = b.dataset
WHERE 
	wpnr != 509
),

buffer_geometry AS (
SELECT
	t_basket,
	t_datasetname,
	funktion,
	biodiversitaet_id,
	biodiversitaet_objekt,
	wytweide,
	(ST_Dump(ST_Union(geometrie))).geom AS geometrie
FROM 
	waldfunktionen
GROUP BY
	t_basket,
	t_datasetname,
	funktion,
	biodiversitaet_id,
	biodiversitaet_objekt,
	wytweide
)

/*
reduce_precision AS (
SELECT 
	t_basket,
	t_datasetname,
	funktion,
	biodiversitaet_id,
	biodiversitaet_objekt,
	wytweide,
	(ST_Dump(ST_MakeValid(st_reduceprecision(geometrie,0.001)))).geom AS geometrie
FROM 
	buffer_geometry
)
*/

INSERT INTO awjf_waldplan_v2.waldfunktion  (
	t_basket,
	t_datasetname,
	funktion,
	biodiversitaet_id,
	biodiversitaet_objekt,
	wytweide,
	bemerkung,
	geometrie
)

SELECT 
	r.t_basket,
	r.t_datasetname,
	r.funktion,
	r.biodiversitaet_id,
	r.biodiversitaet_objekt,
	r.wytweide,
    CASE 
        WHEN r.funktion IN ('Schutzwald', 'Schutzwald_Biodiversitaet') 
        	THEN 'Mögliche Schutzwald-Nr.: ' || E'\n' || string_agg(DISTINCT s.schutzwald_nr2, E'\n')
    END AS bemerkung,
	r.geometrie
FROM 
	buffer_geometry AS r
LEFT JOIN awjf_schutzwald_v1.schutzwald AS s
	ON ST_Within(ST_PointOnSurface(s.geometrie), r.geometrie)
GROUP BY 
	r.t_basket,
	r.t_datasetname,
	r.funktion,
	r.biodiversitaet_id,
	r.biodiversitaet_objekt,
	r.wytweide,
	r.geometrie