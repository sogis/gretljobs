WITH

big_ids AS (
    SELECT 
        id
    FROM 
        public.poly_cleanup  
    WHERE
        COALESCE(g_max_diameter, 999999) > ${clean_max_diameter}
)

UPDATE -- Setzen der Attribute der big polygone
    public.poly_cleanup t
SET 
    is_big = TRUE,
    parent_id_ref = t.id
FROM
    big_ids b
WHERE 
    t.id = b.id
;