SELECT
    ogc_fid AS t_id,
    ST_Multi(wkb_geometry) AS geometrie,
    zcode,
    zcode_text,
    gem_bfs,
    exact,
    bearbeiter,
    verifiziert,
    datum 
FROM
    digizone.zonenplan
WHERE
    archive = 0
;