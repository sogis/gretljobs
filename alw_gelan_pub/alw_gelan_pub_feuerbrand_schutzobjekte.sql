SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    geoid,
    jahr,
    kulturcode
FROM
    gelan.feba_schobj
WHERE
    archive = 0
    AND
    jahr = ${publikationsjahr_wechsel_herbst}
;
