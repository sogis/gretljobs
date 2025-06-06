/*
Update der Geometrie der Grosspolygone in der Quelltabelle, sofern in sie Kleinpolygone aufgelöst werden
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

,updated AS ( -- Liste aller aktualisierten Grosspolygone
    SELECT 
        id,
        geom
    FROM 
        public.poly_cleanup u
    JOIN 
        big_merge_id i ON u.id = i.merge_big_id
)

UPDATE 
    ${sourcetable} o
SET 
    geometrie = u.geom
FROM
    updated u
WHERE 
    o.t_id = u.id
;