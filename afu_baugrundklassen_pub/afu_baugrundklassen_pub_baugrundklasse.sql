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
            THEN '<b>Baugrundklasse A</b><br>
                  Harter Fels (z.B. Kalk) oder weicher Fels (z.B. Sandstein, Nagelfluh, Mergel, Opalinuston) unter maximal 5 m Lockergesteinsbedeckung'
        WHEN bgk = 'C'
            THEN '<b>Baugrundklasse C</b><br>
                  Ablagerungen von normal konsolidiertem und unzementierten Kies und Sand und/oder Moränenmaterial mit einer Mächtigkeit über 30m'
        WHEN bgk = 'D'
            THEN '<b>Baugrundklasse D</b><br>
                  Ablagerungen von unkonsolidiertem Feinsand, Silt und Ton mit einer Mächtigkeit über 30m'
        WHEN bgk = 'E'
            THEN '<b>Baugrundklasse E</b><br>
                  Alluviale Oberflächenschicht der Baugrundklassen C und D mit einer Mächtigkeit zwischen 5 und 30 m über einer steiferen Schicht der Baugrundklasse A oder B'
        WHEN bgk = 'F2'
            THEN '<b>Baugrundklasse F2</b><br>
                  Aktive oder reaktivierbare Rutschungen'
    END AS bgk_txt,
    CASE
        WHEN gz = '1'
            THEN '<b>Erdbebengefährdungszone: Z1</b>'
        WHEN gz = '2'
            THEN '<b>Erdbebengefährdungszone: Z2</b>'
    END AS gz_txt,
    '<a href="http://geo.so.ch/doks/afu/baugk/synthesebericht.pdf">Synthesebericht anzeigen (als pdf-Datei)</a>' AS bericht
    
FROM 
    afu_baugrundklassen
WHERE
    archive = 0
;
