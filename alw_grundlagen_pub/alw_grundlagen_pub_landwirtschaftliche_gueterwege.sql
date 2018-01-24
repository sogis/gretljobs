SELECT
    ogc_fid AS t_id,
    belag,
    wkb_geometry AS geometrie,
    werkeigentuemer,
    letzte_pwi
FROM
    alw_bergwege
WHERE
    archive = 0
;