SELECT
    hoheitsgrenzen_gemeindegrenze.bezirksname,
    hoheitsgrenzen_bezirk.bezirksnummer,
    hoheitsgrenzen_gemeindegrenze.kantonsname,
    ST_Multi(ST_Union(hoheitsgrenzen_gemeindegrenze.geometrie)) AS geometrie
FROM
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze
    LEFT JOIN agi_hoheitsgrenzen.hoheitsgrenzen_bezirk
        ON hoheitsgrenzen_bezirk.bezirksname=hoheitsgrenzen_gemeindegrenze.bezirksname
GROUP BY
    hoheitsgrenzen_gemeindegrenze.bezirksname,
    hoheitsgrenzen_bezirk.bezirksnummer,
    hoheitsgrenzen_gemeindegrenze.kantonsname
;