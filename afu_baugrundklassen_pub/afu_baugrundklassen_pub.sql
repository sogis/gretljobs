SELECT 
    geometrie,
    CASE
        WHEN baugrundklasse = 'A'
            THEN 'Baugrundklasse A: Harter Fels (z.B. Kalk) oder weicher Fels (z.B. Sandstein, Nagelfluh, Mergel, Opalinuston) unter maximal 5 m Lockergesteinsbedeckung'
        WHEN baugrundklasse = 'C'
            THEN 'Baugrundklasse C: Ablagerungen von normal konsolidiertem und unzementierten Kies und Sand und/oder Moränenmaterial mit einer Mächtigkeit über 30m'
        WHEN baugrundklasse = 'D'
            THEN 'Baugrundklasse D: Ablagerungen von unkonsolidiertem Feinsand, Silt und Ton mit einer Mächtigkeit über 30m'
        WHEN baugrundklasse = 'E'
            THEN 'Baugrundklasse E: Alluviale Oberflächenschicht der Baugrundklassen C und D mit einer Mächtigkeit zwischen 5 und 30 m über einer steiferen Schicht der Baugrundklasse A oder B'
        WHEN baugrundklasse = 'F2'
            THEN 'Baugrundklasse F2: Aktive oder reaktivierbare Rutschungen'
    END AS baugrundklasse,
    ST_Area(geometrie) AS area,
    ST_Perimeter(geometrie) AS perimeter,
    methode,
    shapefile,
    zuordnung,
    hilfsattribut,
    CASE
        WHEN gefaehrdungszone = 'Kantonsflaeche_ohne_Thierstein_Dorneck'
            THEN 'Erdbebengefährdungszone: Z1'
        WHEN gefaehrdungszone = 'Thierstein_Dorneck'
            THEN 'Erdbebengefährdungszone: Z2'
    END AS gefaehrdungszone,
    'https://geo.so.ch/docs/ch.so.afu.baugrundklassen/synthesebericht.pdf' AS bericht
FROM 
    afu_baugrundklassen_v1.baugrundklasse
;
