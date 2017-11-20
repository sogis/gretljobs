SELECT 
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    objectid,
    liniennumm,
    verkehrsmi,
    verkehrs_1,
    fplnr
FROM 
    public.avt_oev_netz_ausserkantonal
WHERE
    archive = 0
;