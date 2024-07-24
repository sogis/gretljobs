WITH

pubschema AS (
    SELECT
        profilnummer,
        'https://geo.so.ch/api/v1/document/afu_bodenprofilstandorte.pdf?feature=' || t_id || '&x=' || st_x(geometrie) || '&y=' || st_y(geometrie) || '&crs=EPSG%3A2056' AS profilblatt
    FROM
        afu_bodendaten_nabodat_pub.bodenproflstndrte_bodenprofilstandort
)

UPDATE 
    afu_bodendaten_nabodat_abfrage_pub_v1.bodenprofilbfrage_bodenprofil AS abfrageschema
SET 
    profilblatt = pubschema.profilblatt
FROM 
    pubschema
WHERE 
    abfrageschema.profilnummer = pubschema.profilnummer
;