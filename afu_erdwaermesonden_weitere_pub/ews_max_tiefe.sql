SELECT
    ogc_fid AS t_id,
    gebiet,
    gridcode,
    frei,
    horizont,
    wkb_geometry AS geometrie,
    bearbeiter 
FROM
    gerda.ews_max_tiefe
WHERE
    archive = 0
;