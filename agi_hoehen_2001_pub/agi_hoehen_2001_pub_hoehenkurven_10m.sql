SELECT
    gid AS t_id,
    "level",
    wkb_geometry AS geometrie,
    kategorie 
FROM
    public.sogis_dtm_contour_10m
;