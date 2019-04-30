SELECT
    area AS flaeche,
    perimeter,
    nr,
    "name",
    hegering, 
    wkb_geometry AS geometrie 
FROM
    "public".jfv_jagdre
WHERE
    archive = 0
;
