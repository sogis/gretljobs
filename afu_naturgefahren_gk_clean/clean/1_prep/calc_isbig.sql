WITH 

big_small_area AS (
    SELECT 
        ST_Area(geometrie) AS area_,
        geometrie,
        id
    FROM 
        public.poly_cleanup
)

,big_small_diameter AS (
    SELECT    
        CASE 
            WHEN area_ < ${clean_max_area} THEN (ST_MaximumInscribedCircle(geometrie)).radius * 2
            ELSE NULL
        END
        AS max_diameter,
        big_small_area.*
    FROM 
        big_small_area
)

,big_small AS (
    SELECT
        coalesce(max_diameter, 999999) < ${clean_max_diameter} AS is_small, -- 999999 ist sicher grösser wie param clean_max_diameter
        area_,
        max_diameter,
        p.id
    FROM 
        public.poly_cleanup p 
    LEFT JOIN 
        big_small_diameter bs ON p.id = bs.id
)

UPDATE 
    public.poly_cleanup t
SET 
    _is_big = (NOT is_small)    
FROM
    big_small b
WHERE 
    t.id = b.id
;