SELECT
    objekt,
    gemeinde,
    koordinate_x,
    koordinate_y,
    stand,
    bauherr,
    wkb_geometry AS geometrie,
    ogc_fid AS t_id 
FROM
    naturschutz.amphibienstandorte
WHERE
    archive = 0
;