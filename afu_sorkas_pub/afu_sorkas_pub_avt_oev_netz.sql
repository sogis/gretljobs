SELECT
    gid AS t_id,
    ogc_fid,
    typ,
    herkunft,
    tunnel,
    the_geom AS geometrie
FROM
    sorkas.avt_oev_netz
WHERE
    "archive" = 0