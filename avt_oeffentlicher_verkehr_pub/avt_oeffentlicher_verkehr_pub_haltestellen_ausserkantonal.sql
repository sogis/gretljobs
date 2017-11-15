SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    didook,
    haltestell,
    gemeinde,
    point_x,
    point_y
FROM 
    public.avt_oev_haltestellen_ausserkantonal
WHERE
    archive = 0;
