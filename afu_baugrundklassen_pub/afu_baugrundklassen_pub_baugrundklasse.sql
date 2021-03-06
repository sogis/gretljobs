SELECT 
    ogc_fid AS t_id, 
    wkb_geometry AS geometrie, 
    bgk,
    area,
    perimeter,
    methode,
    shapefile,
    zuordnung,
    agd,
    gz,
    CASE
        WHEN bgk = 'A'
            THEN 'Baugrundklasse A: 
                  Harter Fels (z.B. Kalk) oder weicher Fels (z.B. Sandstein, Nagelfluh, Mergel, Opalinuston) unter maximal 5 m Lockergesteinsbedeckung'
        WHEN bgk = 'C'
            THEN 'Baugrundklasse C:
                  Ablagerungen von normal konsolidiertem und unzementierten Kies und Sand und/oder Moränenmaterial mit einer Mächtigkeit über 30m'
        WHEN bgk = 'D'
            THEN 'Baugrundklasse D:
                  Ablagerungen von unkonsolidiertem Feinsand, Silt und Ton mit einer Mächtigkeit über 30m'
        WHEN bgk = 'E'
            THEN 'Baugrundklasse E:
                  Alluviale Oberflächenschicht der Baugrundklassen C und D mit einer Mächtigkeit zwischen 5 und 30 m über einer steiferen Schicht der Baugrundklasse A oder B'
        WHEN bgk = 'F2'
            THEN 'Baugrundklasse F2: 
                  Aktive oder reaktivierbare Rutschungen'
    END AS bgk_txt,
    CASE
        WHEN gz = '1'
            THEN 'Erdbebengefährdungszone: Z1'
        WHEN gz = '2'
            THEN 'Erdbebengefährdungszone: Z2'
    END AS gz_txt,
    'https://geo.so.ch/docs/ch.so.afu.baugrundklassen/synthesebericht.pdf' AS bericht
    
FROM 
    afu_baugrundklassen
WHERE
    archive = 0
;
