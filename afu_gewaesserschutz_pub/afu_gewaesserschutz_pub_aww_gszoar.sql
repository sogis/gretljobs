SELECT
    ogc_fid AS t_id,
    ST_Multi(wkb_geometry) as geometrie,
    zone,
    rrbnr,
    rrb_date
FROM
    aww_gszoar
WHERE
    archive = 0;
