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
        _root_id_ref IS NOT NULL 
);
