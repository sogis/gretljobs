/*
Delete der Kleinpolygone, deren Geometrie in ein Grosspolygon aufgelöst wurde
*/
DELETE FROM  
    ${sourcetable} o
WHERE 
    t_id 
IN (
    SELECT 
        id
    FROM 
        public.poly_cleanup 
    WHERE 
        merge_big_id IS NOT NULL 
);
