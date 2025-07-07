/*
Aktualisiert die Geometrie der Root-Polygone, falls diese Flächenanteile von benachbarten Polygonen erhalten.
*/
WITH 

merged AS ( -- Gemergte neue Fläche der Root-Polygone, in welche andere Polygone aufgelöst werden
    SELECT 
        root_id,
        ST_Multi(ST_Union(geom)) AS merged_geom
    FROM 
        public.poly_cleanup
    WHERE
        root_id IS NOT NULL
    GROUP BY
        root_id
)

,merged_unary AS ( -- Auflösen interner aneinandergrenzender Parts in den Multipolygonen
    SELECT 
        root_id,
        ST_UnaryUnion(merged_geom) AS merged_geom
    FROM 
        merged
) 

UPDATE -- Aktualisierung der Root-Polygon Geometrie mit der neuen gemergten Geometrie
    public.poly_cleanup p
SET 
    geom = m.merged_geom,
    geom_updated = TRUE
FROM 
    merged_unary m
WHERE 
    p.id = m.root_id
;