/*
Aktualisiert die Geometrie der Root-Polygone, falls diese Flächenanteile von benachbarten Polygonen erhalten.
*/
WITH 

merged AS ( -- Gemergte neue Fläche der Root-Polygone, in welche andere Polygone aufgelöst werden
    SELECT 
        root_id,
        ST_Multi(
            ST_Union(singlepoly) 
        ) AS merged_poly
    FROM 
        public.poly_cleanup
    WHERE
        root_id IS NOT NULL
    GROUP BY
        root_id
)

UPDATE
    public.poly_cleanup p
SET 
    root_merged_poly = m.merged_poly
FROM 
    merged m
WHERE 
    p.id = m.root_id
;