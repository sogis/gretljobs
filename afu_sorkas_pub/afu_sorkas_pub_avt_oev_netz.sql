SELECT
    gid AS t_id,
    ogc_fid,
    typ,
    herkunft,
    the_geom_1,
    tunnel,
    the_geom AS geometrie
FROM
    sorkas.avt_oev_netz
WHERE
    "archive" = 0