SELECT
    ogc_fid AS t_id,
    object_id,
    wkb_geometry AS geometrie,
    "name",
    uuid
FROM
    ada_adagis_d.point_geometrie
WHERE
    archive = 0
;