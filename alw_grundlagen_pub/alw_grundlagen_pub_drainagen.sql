SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    location
FROM
    alw_grundlagen.drainagen
WHERE
    archive = 0
;