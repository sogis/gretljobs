SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    name,
    betreiber,
    konflikt
FROM
    netzbetreiber_strom.netz_7
WHERE 
    archive = 0
;