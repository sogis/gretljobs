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
AND 
    gem_bfs NOT IN (2401,2403,2405,2407,2408,2456,2457,2473,2474,2475,2476,2479,2498,2501,2502,2514,2573,2580,2613,2614,2615,2616)
;
