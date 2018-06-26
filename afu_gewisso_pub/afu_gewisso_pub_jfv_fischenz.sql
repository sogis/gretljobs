SELECT 
    ST_Multi(ST_Force_2D(ST_Union(wkb_geometry))) AS geometrie,
    revier_id ,
    grenzen
FROM 
    gewisso.jfv_fischenz
WHERE 
    archive = 0
GROUP BY
    revier_id ,
    grenzen
;