WITH 

modified_source__id AS (
    SELECT 
        multipoly_id_ref
    FROM 
        poly_cleanup 
    WHERE 
        root_merged_poly IS NOT NULL
    GROUP BY 
        multipoly_id_ref 
)

,merged AS (
    SELECT 
        ST_Multi(
            ST_UnaryUnion(
                ST_Union(p.root_merged_poly)
            )
        ) AS merged_geom,
        p.multipoly_id_ref
    FROM 
        public.poly_cleanup p
    JOIN 
        modified_source__id s ON p.multipoly_id_ref = s.multipoly_id_ref
    GROUP BY 
        p.multipoly_id_ref 
)

UPDATE 
    public.interface_table i
SET 
    out_center_geom = m.merged_geom
FROM 
    merged m 
WHERE 
    i.id = m.multipoly_id_ref
;