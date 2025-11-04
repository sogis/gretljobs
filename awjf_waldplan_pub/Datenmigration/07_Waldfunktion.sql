DELETE FROM awjf_waldplan_v2.waldplan_waldfunktion;

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

union_geometry AS (
    SELECT
        t_basket,
        t_datasetname,
        funktion,
        biodiversitaet_id,
        biodiversitaet_objekt,
        wytweide,
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
        waldfunktionen
    GROUP BY
        t_basket,
        t_datasetname,
        funktion,
        biodiversitaet_id,
        biodiversitaet_objekt,
        wytweide
),

cleaned_geometry AS (
    SELECT
        t_basket,
        t_datasetname,
        funktion,
        biodiversitaet_id,
        biodiversitaet_objekt,
        wytweide,
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

INSERT INTO awjf_waldplan_v2.waldplan_waldfunktion  (
	t_basket,
	t_datasetname,
	funktion,
	biodiversitaet_id,
	biodiversitaet_objekt,
	wytweide,
	bemerkung,
	geometrie,
	schutzwald_r,
	t_lastchange,
	t_createdate,
	t_user
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
	r.geometrie,
	CASE 
		WHEN r.funktion IN ('Schutzwald', 'Schutzwald_Biodiversitaet')
			AND COUNT(DISTINCT s.schutzwald_nr2) = 1
		THEN MAX(sn.t_id)
		ELSE NULL
	END AS schutzwald_r,
	CURRENT_TIMESTAMP AS t_lastchange,
	CURRENT_TIMESTAMP AS t_createdate,
	'Datenmigration' t_user
FROM 
	cleaned_geometry AS r
LEFT JOIN awjf_schutzwald_v1.schutzwald AS s
	ON ST_Within(ST_PointOnSurface(s.geometrie), r.geometrie)
LEFT JOIN awjf_waldplan_v2.waldplan_schutzwald AS sn
	ON s.schutzwald_nr2 = sn.schutzwald_nr
GROUP BY 
	r.t_basket,
	r.t_datasetname,
	r.funktion,
	r.biodiversitaet_id,
	r.biodiversitaet_objekt,
	r.wytweide,
	r.geometrie