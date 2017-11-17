SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    symbol
FROM
    geologie.karst
WHERE
    archive = 0
;