/*
Update der Geometrie der Grosspolygone in der Quelltabelle, sofern in sie Kleinpolygone aufgelöst wurden
*/
UPDATE 
    ${sourcetable} o
SET 
    geometrie = c.geometrie
FROM
    public.poly_cleanup c
WHERE 
        o.t_id = c.id
    AND
        c._center_geom IS NOT NULL
;