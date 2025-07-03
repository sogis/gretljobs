WITH 

parts_mergecount AS (
    SELECT 
        count(root_id) AS merged_partcount,
        count(id) AS total_partcount,
        multipoly_id
    FROM 
        public.poly_cleanup 
    GROUP BY 
        multipoly_id         
)

,partial_merged AS (
    SELECT 
        p.multipoly_id, 
        ST_Union(p.singlepoly) AS partial_merged 
    FROM 
        public.poly_cleanup p
    JOIN 
        parts_mergecount m ON p.multipoly_id = m.multipoly_id
    WHERE 
        m.merged_partcount < m.total_partcount  
    GROUP BY 
        p.multipoly_id
)

,complete_merged AS (
    SELECT 
        p.multipoly_id
    FROM 
        public.poly_cleanup p
    JOIN 
        parts_mergecount m ON p.multipoly_id = m.multipoly_id
    WHERE 
        m.merged_partcount = m.total_partcount  
    GROUP BY 
        p.multipoly_id
)

,upd_complete_merged AS (
    UPDATE 
        public.interface_table i
    SET 
        out_agglo_delete = TRUE
    FROM 
        complete_merged m
    WHERE 
        i.id = m.multipoly_id
    RETURNING *
)

--update partial merged
UPDATE 
    public.interface_table i
SET 
    out_agglo_geom = m.partial_merged
FROM 
    partial_merged m
WHERE 
    i.id = m.multipoly_id
;