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
    gem_bfs NOT IN (SELECT DISTINCT t_datasetname::integer FROM arp_npl.nutzungsplanung_grundnutzung) --Jene Gemeinden ausschliessen, welche die Nutzungsplanung schon abgeschlossen haben! 
;