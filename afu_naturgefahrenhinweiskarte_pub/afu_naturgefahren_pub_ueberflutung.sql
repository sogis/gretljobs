SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    area,
    perimeter,
    grid_code,
    CASE
        WHEN grid_code = 4
             THEN 'Überflutungsgebiete'
    END AS grid_code_text
FROM
    public.aww_natgef_ubflut
WHERE
    archive = 0;
