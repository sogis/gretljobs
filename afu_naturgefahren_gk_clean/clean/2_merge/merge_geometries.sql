/*
Aktualisiert die Geometrie der Root-Polygone, falls diese Flächenanteile von benachbarten Polygonen erhalten.
*/
WITH 

merged AS ( -- Gemergte neue Fläche der Root-Polygone, in welche andere Polygone aufgelöst werden
    SELECT 
        _root_id_ref,
        ST_Multi(ST_Union(geometrie)) AS merged_geom
    FROM 
        public.poly_cleanup
    WHERE
        _root_id_ref IS NOT NULL
    GROUP BY
        _root_id_ref
)

,merged_unary AS ( -- Auflösen interner aneinandergrenzender Parts in den Multipolygonen
    SELECT 
        _root_id_ref,
        ST_UnaryUnion(merged_geom) AS merged_geom
    FROM 
        merged
) 

UPDATE -- Aktualisierung der Root-Polygon Geometrie mit der neuen gemergten Geometrie
    public.poly_cleanup p
SET 
    _center_geom = m.merged_geom
FROM 
    merged_unary m
WHERE 
    p.id = m._root_id_ref
;