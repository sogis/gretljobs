SELECT
    ogc_fid AS t_id,
    ST_Multi(wkb_geometry) AS geometrie,
    fk,
    fr,
    sw_name,
    prioritaet
    shape_leng,
    shape_area,
    status,
    status_nr,
    jahr
FROM
    awjf.sw_massn_korr
WHERE
    archive = 0
;