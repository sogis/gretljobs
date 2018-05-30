SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    jahr,
    typ
FROM
    gelan.bienen_sperrgeb
WHERE
    archive = 0
;