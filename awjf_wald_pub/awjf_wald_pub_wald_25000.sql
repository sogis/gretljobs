SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie
FROM
    "public".sogis_wall25
WHERE
    archive = 0
;