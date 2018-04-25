SELECT
    gid AS t_id,
    "ID" AS id,
    elev,
    ST_Multi(wkb_geometry) AS geometrie
FROM
    lidar.contour_simplify
;