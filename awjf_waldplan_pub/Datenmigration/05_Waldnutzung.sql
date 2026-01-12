DELETE FROM awjf_waldplan_v2.waldplan_waldnutzung;

WITH 

waldnutzung AS (
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
			THEN 'Rodungsflaechen_temporaer'
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

union_geometry AS (
    SELECT
		t_basket,
		t_datasetname,
		Nutzungskategorie,
        (ST_Dump(
            ST_Union(
                ST_SnapToGrid(
                    ST_RemoveRepeatedPoints(
                        ST_MakeValid(geometrie),
                        0.0005
                    ),
                    0.0005
                )
            )
        )).geom AS geometrie
    FROM
        waldnutzung
	GROUP BY 
		t_basket,
		t_datasetname,
		Nutzungskategorie
),

cleaned_geometry AS (
    SELECT
		t_basket,
		t_datasetname,
		Nutzungskategorie,
        CASE 
            WHEN ST_GeometryType(geometrie) = 'ST_Polygon' THEN
                ST_MakePolygon(
                    ST_ExteriorRing(geometrie),
                    ARRAY(
                        SELECT ST_ExteriorRing(ring.geom)
                        FROM (
                            SELECT (ST_DumpRings(ug.geometrie)).*
                        ) AS ring
                        WHERE ring.path[1] > 0
                        AND (4 * 3.14159 * ST_Area(ring.geom)) / 
                            (ST_Perimeter(ring.geom) ^ 2) > 0.005
                    )
                )
            ELSE geometrie
        END AS geometrie
    FROM
        union_geometry AS ug
)

INSERT INTO awjf_waldplan_v2.waldplan_waldnutzung (
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
	cleaned_geometry