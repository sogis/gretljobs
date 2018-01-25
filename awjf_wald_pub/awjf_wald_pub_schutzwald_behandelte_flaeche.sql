SELECT
    ogc_fid AS t_id,
    ST_Multi(wkb_geometry) AS geometrie,
    id,
    id_sw_db,
    schutzwald,
    flaeche_nr,
    abr_nr,
    massnahme_,
    massnahme,
    status,
    status_txt,
    jahr,
    area_gemes,
    area_beitr,
    bemerkung,
    bem_db,
    beschr,
    x_beschr,
    y_beschr
FROM
    awjf.sw_beh_flaeche
WHERE
    archive = 0
;