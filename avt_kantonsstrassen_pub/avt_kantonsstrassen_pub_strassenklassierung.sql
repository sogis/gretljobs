SELECT 
    ogc_fid AS t_id,
    ST_Multi(wkb_geometry) AS geometrie,
    ck,
    cko_owner,
    pos_code,
    baseid,
    klassierun
FROM
    public.avt_strassenklassierung
WHERE
    archive = 0
;