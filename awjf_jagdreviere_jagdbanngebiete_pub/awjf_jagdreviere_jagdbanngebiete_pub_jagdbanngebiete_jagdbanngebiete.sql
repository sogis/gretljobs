SELECT
    jagdbanngebiete.nummer,
    jagdbanngebiete.aname,
    jagdbanngebiete.geometrie,
    art.description AS art,
    round(st_area(jagdbanngebiete.geometrie))::integer AS flache,
    round(st_perimeter(jagdbanngebiete.geometrie))::integer AS umfang
FROM
    awjf_jagdreviere_jagdbanngebiete.jagdbanngebiete_jagdbanngebiete jagdbanngebiete
    LEFT JOIN awjf_jagdreviere_jagdbanngebiete.jagdbanngebiete_jagdbanngebiete_art art
        ON jagdbanngebiete.art = art.ilicode
;
