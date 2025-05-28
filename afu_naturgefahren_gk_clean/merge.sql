
DELETE FROM 
    afu_schutzbauten_v1.tmp_polygon
;

WITH 

hazard_level_map AS ( -- Zuordnung der gefahrenstufen auf Ganzzahlen. Grössere Gefährdung = grössere Zahl.
    SELECT
        varchar AS l_string,
        int AS l_int
    FROM ( VALUES -- $td vervollständigen gemäss modell
        ('restgefaehrdung', 10),
        ('gering', 20),
        ('mittel', 30),
        ('erheblich', 40)
    ) AS t(varchar, int) 
)

INSERT INTO -- Insert aus Quelle in Verarbeitungstabelle
    afu_schutzbauten_v1.tmp_polygon(
        id,
        hazard_level,
        g_area,
        geom
    )
    SELECT
        t_id AS id,
        COALESCE(l_int, -1) AS hazard_level,
        ST_Area(geometrie) AS g_area,
        geometrie AS geom
    FROM 
        afu_schutzbauten_v1.gk_wasser_1 p
    LEFT JOIN 
        hazard_level_map m ON p.gefahrenstufe = m.l_string 
    --LIMIT 1000 --$td LIMIT entfernen
;

UPDATE -- Ergänzung aller Polygone unter der definierten Grösse mit Wert für den max. Durchmesser (max_diameter)
    afu_schutzbauten_v1.tmp_polygon t
SET 
    g_max_diameter = max_diameter
FROM (
    SELECT 
        (ST_MaximumInscribedCircle(geom)).radius * 2 AS max_diameter,
        id
    FROM 
        afu_schutzbauten_v1.tmp_polygon
    WHERE 
        g_area < 10    
) AS s
WHERE t.id = s.id
;

UPDATE -- Setzen von is_small für alle Polygone
    afu_schutzbauten_v1.tmp_polygon t
SET 
    is_small = s.is_small 
FROM (
    SELECT 
        COALESCE(g_max_diameter, 999) < 1 AS is_small,
        id
    FROM 
        afu_schutzbauten_v1.tmp_polygon  
) AS s
WHERE t.id = s.id
;

WITH 
intersecting AS ( 
    -- INTERSECT aller Kleinpolygone mit Grosspolygonen unter Berücksichtigung der zulässigen Gefahrenstufen-Unterschiede (Auflösen in kleinere Gefahrenstufe verboten).
    -- merge_rank ist klein bei kleinem Unterschied der Gefahrenstufen Kleinpolygon - Grosspolygon
    SELECT 
        small.id AS small_id,
        big.id AS big_id,
        big.hazard_level - small.hazard_level AS merge_level_diff,
        ROW_NUMBER() OVER (PARTITION BY small.id ORDER BY big.hazard_level - small.hazard_level ASC) AS merge_rank
        --ROW_NUMBER() OVER (PARTITION BY small.id ORDER BY big.g_area DESC) AS merge_rank
    FROM 
    (
        SELECT 
            *
        FROM 
            afu_schutzbauten_v1.tmp_polygon 
        WHERE
            is_small IS TRUE 
    ) AS small
    ,(
        SELECT 
            *
        FROM 
            afu_schutzbauten_v1.tmp_polygon 
        WHERE
            is_small IS FALSE  
    ) AS big
    WHERE 
            ST_Intersects(small.geom,big.geom)
        AND 
            small.hazard_level <= big.hazard_level
)

UPDATE -- Aktualisierung der Kleinpolygon-Informationen mit der ID des Grosspolygons, auf welches gemergt wird.
    afu_schutzbauten_v1.tmp_polygon t
SET 
    merge_big_id = i.big_id,
    merge_level_diff = i.merge_level_diff,
FROM 
    intersecting i
WHERE 
        t.id = i.small_id
    AND 
        i.merge_rank = 1   
;

SELECT -- Ausgabe der Zusammenfassung der resultierenden Anzahl merges and "skips" von Kleinpolygonen
    operation,
    count(*) AS poly_count
FROM (
    SELECT 
        id, 
        CASE WHEN merge_big_id IS NOT NULL THEN 'merge' ELSE 'delete' END AS operation
    FROM 
       afu_schutzbauten_v1.tmp_polygon
    WHERE 
        is_small IS TRUE
)
GROUP BY 
    operation
;

-- Merge der Kleinpolygone auf ihr jeweiliges Grosspolygon
WITH 

big_merge_id AS ( -- Liste aller Grosspolygon-ID's, in welche Kleinpolygone aufgelöst werden (für join in cte big_poly)
    SELECT 
        merge_big_id
    FROM 
        afu_schutzbauten_v1.tmp_polygon 
    GROUP BY
        merge_big_id
)

,big_poly AS ( -- Liste aller Grosspolygone, in welche Kleinpolygone aufgelöst werden
    SELECT 
        id,
        geom
    FROM
        afu_schutzbauten_v1.tmp_polygon p
    JOIN
        big_merge_id c ON p.id = c.merge_big_id
)

,small_poly AS ( -- Liste aller Kleinpolygon-Geometrien, jeweils mit der ID des Grosspolygons, in welches sie gemerged werden
    SELECT 
        merge_big_id AS id,
        geom
    FROM
        afu_schutzbauten_v1.tmp_polygon p
    WHERE 
        merge_big_id IS NOT NULL 
)

,merged AS ( -- Gemergte neue Fläche der Grosspolygone, in welche Kleinpolygone aufgelöst werden
    SELECT 
        id,
        ST_Multi(ST_Union(geom)) AS geom
    FROM (
        SELECT id, geom FROM big_poly
        UNION ALL
        SELECT id, geom FROM small_poly
    )
    GROUP BY
        id
)

,merged_unary AS ( -- Auflösen interner aneinandergrenzender Parts in den Multipolygonen
    SELECT 
        id,
        ST_UnaryUnion(geom) AS geom
    FROM 
        merged
) 

--Todo
--Update auf zweite tmp-Table legen
--Löschen ergänzen

UPDATE -- Aktualisierung der Grosspolygon-Geometrie mit der neuen gemergten Geometrie
    afu_schutzbauten_v1.tmp_polygon p
SET 
    geom = m.geom
FROM 
    merged_unary m
WHERE 
    p.id = m.id
;



/*

CREATE TABLE afu_schutzbauten_v1.tmp_polygon (
    id int4 NOT NULL,
    geom public.geometry(multipolygon, 2056) NULL,
    hazard_level int4 NULL,
    g_area float8 NULL,
    g_max_diameter float8 NULL,
    is_small bool NULL,
    merge_big_id int4 NULL,
    merge_level_diff int4 NULL,
    --merge_length float8 NULL,
    CONSTRAINT tmp_polygon_pkey PRIMARY KEY (id)
);
CREATE INDEX sidx_tmp_polygon_geom ON afu_schutzbauten_v1.tmp_polygon USING gist (geom);
 */
