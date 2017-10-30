SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    area,
    perimeter,
    grid_code 
FROM
    public.aww_natgef_ubflut
WHERE
    "archive" = 0;