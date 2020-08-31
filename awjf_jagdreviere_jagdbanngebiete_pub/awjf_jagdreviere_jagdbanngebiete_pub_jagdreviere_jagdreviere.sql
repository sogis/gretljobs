WITH gemeinden AS (
    SELECT
        jagdreviere_jagdreviere.t_id,
        string_agg(DISTINCT hoheitsgrenzen_gemeindegrenze.gemeindename, ', ' ORDER BY hoheitsgrenzen_gemeindegrenze.gemeindename ASC) AS gemeinden
    FROM
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze,
        awjf_jagdreviere_jagdbanngebiete.jagdreviere_jagdreviere
    WHERE
        ST_DWithin(jagdreviere_jagdreviere.geometrie, hoheitsgrenzen_gemeindegrenze.geometrie, 0)
    GROUP BY
       jagdreviere_jagdreviere.t_id
)

SELECT
    jagdreviere.nummer,
    jagdreviere.aname,
    jagdreviere.pacht,
    jagdreviere.geometrie,
    round(st_perimeter(jagdreviere.geometrie))::integer AS umfang,
    round(st_area(jagdreviere.geometrie))::integer AS flache,
    hegering.aname AS hegering,
    gemeinden.gemeinden
	
FROM
    awjf_jagdreviere_jagdbanngebiete.jagdreviere_jagdreviere jagdreviere
    LEFT JOIN awjf_jagdreviere_jagdbanngebiete.jagdreviere_hegering hegering
        ON jagdreviere.hegering_jagdrevier = hegering.t_id
    LEFT JOIN gemeinden
        ON gemeinden.t_id = jagdreviere.t_id
