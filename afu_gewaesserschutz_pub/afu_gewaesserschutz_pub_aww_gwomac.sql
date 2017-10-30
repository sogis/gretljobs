SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    gwomac_id,
    maechtigke
FROM
    public.aww_gwomac
WHERE
    "archive" = 0