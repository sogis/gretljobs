/*
Aktualisiert die Geometrie der Grosspolygone, in welche Kleinpolygone gemerged werden.
*/
WITH 

big_merge_id AS ( -- Liste aller Grosspolygon-ID's, in welche Kleinpolygone aufgelöst werden (für join in cte big_poly)
    SELECT 
        merge_big_id
    FROM 
        public.poly_cleanup 
    GROUP BY
        merge_big_id
)

,big_poly AS ( -- Liste aller Grosspolygone, in welche Kleinpolygone aufgelöst werden
    SELECT 
        id,
        geom
    FROM
        public.poly_cleanup p
    JOIN
        big_merge_id c ON p.id = c.merge_big_id
)

,small_poly AS ( -- Liste aller Kleinpolygon-Geometrien, jeweils mit der ID des Grosspolygons, in welches sie gemerged werden
    SELECT 
        merge_big_id AS id,
        geom
    FROM
        public.poly_cleanup p
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

UPDATE -- Aktualisierung der Grosspolygon-Geometrie mit der neuen gemergten Geometrie
    public.poly_cleanup p
SET 
    geom = m.geom
FROM 
    merged_unary m
WHERE 
    p.id = m.id
;