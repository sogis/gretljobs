DELETE FROM awjf_waldplan_v2.waldplan_waldplantyp;

WITH 

waldplantyp AS (
SELECT
	b.t_id AS t_basket,
	d.datasetname AS t_datasetname,
	CASE 
		WHEN wptyp = 2
			THEN 'Nachteilige_Nutzung'
		WHEN wptyp = 3
			THEN 'Waldstrasse'
		WHEN wptyp = 4
			THEN 'Maschinenweg'
		WHEN wptyp = 5
			THEN 'Bauten_Anlagen'
		WHEN wptyp = 6
			THEN 'Rodung_temporaer'
		WHEN wptyp = 7
			THEN 'Gewaesser'
	END AS Nutzungskategorie,
	geometrie
FROM 
	awjf_waldplan_bestandeskarte_v1.waldplan_bestandeskarte AS w
LEFT JOIN awjf_waldplan_v2.t_ili2db_dataset AS d
	ON w.gem_bfs::text = d.datasetname
LEFT JOIN awjf_waldplan_v2.t_ili2db_basket AS b
	ON d.t_id = b.dataset
WHERE
	wptyp NOT IN (1,8,9)
),

/*
buffer_geometry AS (
SELECT
	t_basket,
	t_datasetname,
	Nutzungskategorie,
	(ST_Dump(ST_RemoveRepeatedPoints(
		ST_MakeValid(
			ST_Buffer(ST_UnaryUnion(ST_Collect(geometrie)),0))))).geom AS geometrie
FROM
	waldplantyp
GROUP BY 
	t_basket,
	t_datasetname,
	Nutzungskategorie
)
*/
buffer_geometry AS (
SELECT
	t_basket,
	t_datasetname,
	Nutzungskategorie,
	(ST_Dump(ST_UNION(geometrie))).geom AS geometrie
FROM
	waldplantyp
GROUP BY 
	t_basket,
	t_datasetname,
	Nutzungskategorie
)


INSERT INTO awjf_waldplan_v2.waldplan_waldplantyp (
	t_basket,
	t_datasetname,
	Nutzungskategorie,
	Geometrie,
	t_lastchange,
	t_createdate,
	t_user
)

SELECT 
	t_basket,
	t_datasetname,
	Nutzungskategorie,
	Geometrie,
	CURRENT_TIMESTAMP AS t_lastchange,
	CURRENT_TIMESTAMP AS t_createdate,
	'Datenmigration' t_user
FROM
	buffer_geometry

/*
SELECT 
	t_basket,
	t_datasetname,
	Nutzungskategorie,
	(ST_Dump(st_makevalid(st_reduceprecision(geometrie,0.001)))).geom AS geometrie
FROM 
	buffer_geometry
*/
