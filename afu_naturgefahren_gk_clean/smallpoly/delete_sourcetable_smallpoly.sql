/*
Delete der Polygone, deren Geometrie in ein Root-Polygon aufgelöst wurde
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
        root_id IS NOT NULL 
);
