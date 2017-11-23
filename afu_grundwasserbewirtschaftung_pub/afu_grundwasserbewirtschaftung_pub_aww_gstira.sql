SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    maechtigke
FROM
    public.aww_gstira
WHERE
    archive = 0
;