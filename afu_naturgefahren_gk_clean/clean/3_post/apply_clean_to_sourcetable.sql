/*
Update der Geometrie der Center-Polygone
*/
UPDATE 
    ${sourcetable} o
SET 
    geometrie = c.out_center_geom
FROM
    public.interface_table c
WHERE 
        o.t_id = c.id
    AND
        c.out_center_geom IS NOT NULL 
;

/*
Update der Geometrie der Klein-Polygone (partial merge)
*/
UPDATE 
    ${sourcetable} o
SET 
    geometrie = c.out_small_agglo_geom
FROM
    public.interface_table c
WHERE 
        o.t_id = c.id
    AND
        c.out_small_agglo_geom IS NOT NULL 
;

/*
Delete der Kleinpolygone, die vollständig gemerged wurden
*/
DELETE FROM  
    ${sourcetable} o
WHERE 
    t_id 
IN (
    SELECT 
        id
    FROM 
        public.interface_table 
    WHERE 
        out_small_clean_result = 'complete'
);