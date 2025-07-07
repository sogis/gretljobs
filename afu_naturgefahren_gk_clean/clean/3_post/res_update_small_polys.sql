WITH 

-- Gibt aus, wieviele Parts eines Kleinpolygons gemerged wurden
small_mergecount AS (
    SELECT 
        count(root_id_ref) AS merged_partcount,
        count(id) AS total_partcount,
        multipoly_id_ref
    FROM 
        public.poly_cleanup 
    WHERE 
        is_big IS FALSE
    GROUP BY 
        multipoly_id_ref         
)

,not_merged AS (
    SELECT 
        p.multipoly_id_ref,
        'not_cleaned' AS clean_result
    FROM 
        public.poly_cleanup p
    JOIN 
        small_mergecount m ON p.multipoly_id_ref = m.multipoly_id_ref
    WHERE 
        m.merged_partcount = 0 
    GROUP BY 
        p.multipoly_id_ref
)

,partial_merged AS (
    SELECT 
        p.multipoly_id_ref,
        'partial' AS clean_result,
        ST_Union(p.singlepoly) AS partial_merged
    FROM 
        public.poly_cleanup p
    JOIN 
        small_mergecount m ON p.multipoly_id_ref = m.multipoly_id_ref
    WHERE 
            m.merged_partcount > 0
        AND
            m.merged_partcount < m.total_partcount  
    GROUP BY 
        p.multipoly_id_ref
)

,complete_merged AS (
    SELECT 
        p.multipoly_id_ref,
        'complete' AS clean_result
    FROM 
        public.poly_cleanup p
    JOIN 
        small_mergecount m ON p.multipoly_id_ref = m.multipoly_id_ref
    WHERE 
            m.merged_partcount > 0
        AND
            m.merged_partcount = m.total_partcount  
    GROUP BY 
        p.multipoly_id_ref
)

,upd_complete_merged AS (
    UPDATE 
        public.interface_table i
    SET 
        out_small_clean_result = clean_result
    FROM 
        complete_merged m
    WHERE 
        i.id = m.multipoly_id_ref
    RETURNING *
)

,upd_not_merged AS (
    UPDATE 
        public.interface_table i
    SET 
        out_small_clean_result = clean_result
    FROM 
        not_merged m
    WHERE 
        i.id = m.multipoly_id_ref
    RETURNING *
)

--update partial merged
UPDATE 
    public.interface_table i
SET 
    out_small_clean_result = clean_result,
    out_small_agglo_geom = m.partial_merged
FROM 
    partial_merged m
WHERE 
    i.id = m.multipoly_id_ref
;