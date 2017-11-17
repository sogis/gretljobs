SELECT 
    ogc_fid AS t_id,
    ST_Force_2D(wkb_geometry) AS geometrie,
    revier_id,
    gnrso,
    von,
    bis,
    gewaesser,
    grenzen,
    eigentum,
    bonitierung,
    nutzung,
    fischbestand,
    fischerei
FROM 
    gewisso.jfv_fischenz
WHERE 
    archive = 0
;
