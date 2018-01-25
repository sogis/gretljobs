SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    area,
    perimeter,
    nr,
    "name",
    art 
FROM
    "public".jfv_jagdba
WHERE
    archive = 0
;