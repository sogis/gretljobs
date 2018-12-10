SELECT
    ogc_fid AS t_id,
    ST_Multi(wkb_geometry) AS geometrie,
    kurventyp,
    kote
FROM
    public.aww_gsmiso
WHERE
    archive = 0
;