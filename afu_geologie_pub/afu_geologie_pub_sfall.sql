SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    fallrtg,
    fall,
    symbol,
    "label"
FROM
    geologie.sfall
WHERE
    archive = 0