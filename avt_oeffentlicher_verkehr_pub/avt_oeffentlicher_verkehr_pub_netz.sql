SELECT
    ogc_fid AS t_id,
    ST_Multi(wkb_geometry) AS geometrie,
    typ,
    herkunft
FROM
    public.avt_oev_netz
WHERE
    "archive" = 0