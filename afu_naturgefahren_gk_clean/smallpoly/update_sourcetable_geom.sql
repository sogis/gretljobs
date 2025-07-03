/*
Update der Geometrie der Grosspolygone in der Quelltabelle, sofern in sie Kleinpolygone aufgelöst wurden
*/
UPDATE 
    ${sourcetable} o
SET 
    geometrie = c.singlepoly
FROM
    public.poly_cleanup c
WHERE 
        o.t_id = c.id
    AND
        c.singlepoly_updated IS TRUE
;