SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    area,
    perimeter,
    karst_,
    karst_id,
    symbol,
    storme_nr
FROM
    public.aww_natgef_doline
WHERE
     archive = 0
