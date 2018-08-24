SELECT
    ogc_fid AS t_id,
    ST_Multi(wkb_geometry) AS geometrie,
    name,
    betreiber,
    konflikt,
    3 AS ebene
FROM
    netzbetreiber_strom.netz_3
WHERE 
    archive = 0
    
UNION ALL

SELECT
    ogc_fid AS t_id,
    ST_Multi(wkb_geometry) AS geometrie,
    name,
    betreiber,
    konflikt,
    5 AS ebene
FROM
    netzbetreiber_strom.netz_5
WHERE 
    archive = 0
    
UNION ALL

SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    name,
    betreiber,
    konflikt,
    7 AS ebene
FROM
    netzbetreiber_strom.netz_7
WHERE 
    archive = 0
;