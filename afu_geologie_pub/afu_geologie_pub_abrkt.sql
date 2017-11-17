SELECT  
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    symbol
FROM
    geologie.abrkt
WHERE
    archive = 0
;