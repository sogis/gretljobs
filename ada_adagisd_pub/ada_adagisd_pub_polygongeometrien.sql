SELECT
    ogc_fid AS t_id,
    object_id,
    ST_Multi(wkb_geometry) AS geometrie,
    extent,
    "name",
    uuid,
    "_area",
    "_area_old",
    overlays
FROM
    ada_adagis_d.poly_geometrie
WHERE
    archive = 0
;