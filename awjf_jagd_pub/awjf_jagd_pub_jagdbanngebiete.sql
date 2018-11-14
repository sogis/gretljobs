SELECT
    area AS flaeche,
    perimeter,
    nr,
    "name",
    CASE 
        WHEN art = '1' 
            THEN 'kantonal' 
        WHEN art = '2' 
            THEN 'kantonal für Vogelwelt'
        WHEN art = '3' 
            THEN 'Wasser und Zugvogelreservate von nationaler Bedeutung'
    END AS art, 
    wkb_geometry AS geometrie 
FROM
    "public".jfv_jagdba
WHERE
    archive = 0
;
