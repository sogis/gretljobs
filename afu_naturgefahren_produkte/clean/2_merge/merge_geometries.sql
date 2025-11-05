WITH 

root_id_list AS (
    SELECT 
       _root_id_ref AS root_id
    FROM 
        public.poly_cleanup
    WHERE 
        _root_id_ref IS NOT NULL 
    GROUP BY 
        _root_id_ref
)

UPDATE -- Setzt temporär für Root-Polygone die _root_id_ref, damit beim Merge das Root-Polygon mit seinen Kleinstflächen gemerged werden kann.
    public.poly_cleanup p
SET 
    _root_id_ref = id
FROM 
    root_id_list l
WHERE 
    l.root_id = p.id
;

WITH

merged AS ( -- Gemergte neue Geometrie der Root-Polygone, in welche andere Polygone aufgelöst werden
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
        ST_Multi(ST_UnaryUnion(merged_geom)) AS merged_geom
    FROM 
        merged
)

UPDATE -- Aktualisierung der Root-Polygon Geometrie mit der neuen gemergten Geometrie
    public.poly_cleanup p
SET 
    _center_geom = m.merged_geom,
    _root_id_ref = NULL -- Reset der Selbstreferenz
FROM 
    merged_unary m
WHERE 
    p.id = m._root_id_ref
;