DELETE FROM agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze
;

INSERT INTO agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze (
    kantonsname,
    kantonskuerzel,
    kantonsnummer,
    geometrie
)
SELECT
    hoheitsgrenzen_gemeindegrenze.kantonsname,
    'SO' as kantonskuerzel,
    kantonsnummer,
    ST_Multi(ST_Union(geometrie)) AS geometrie
FROM
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze
    LEFT JOIN agi_hoheitsgrenzen.hoheitsgrenzen_kanton
        ON hoheitsgrenzen_kanton.kantonsname=hoheitsgrenzen_gemeindegrenze.kantonsname
GROUP BY
    hoheitsgrenzen_gemeindegrenze.kantonsname,
    kantonsnummer,
    kantonskuerzel
;