SELECT 
    geometrie,
    baugrundklasse,
    ST_Area(geometrie) AS area,
    ST_Perimeter(geometrie) AS perimeter,
    methode,
    shapefile,
    zuordnung,
    hilfsattribut,
    gefaehrdungszone
FROM 
    afu_baugrundklassen_v1.baugrundklasse
;
