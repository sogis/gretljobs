SELECT 
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    symbol
FROM
    geologie.tekton
WHERE
    archive = 0