SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    jahr,
    typ
FROM 
    gelan.feba_schper
WHERE
    archive = 0
;