SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    area,
    perimeter,
    nr,
    "name",
    hegering 
FROM
    "public".jfv_jagdre
WHERE
    archive = 0
;