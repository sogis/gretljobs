DELETE FROM agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze_generalisiert
;

INSERT INTO agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze_generalisiert (
    kantonsname,
    kantonskuerzel,
    kantonsnummer,
    geometrie
)

SELECT
    hoheitsgrenzen_gemeindegrenze_generalisiert.kantonsname,
    'SO' as kantonskuerzel,
    hoheitsgrenzen_kanton.kantonsnummer,
    ST_Multi(ST_Union(hoheitsgrenzen_gemeindegrenze_generalisiert.geometrie)) AS geometrie
FROM
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze_generalisiert
    LEFT JOIN agi_hoheitsgrenzen_v1.hoheitsgrenzen_kanton
        ON hoheitsgrenzen_kanton.kantonsname = hoheitsgrenzen_gemeindegrenze_generalisiert.kantonsname 
GROUP BY
    hoheitsgrenzen_gemeindegrenze_generalisiert.kantonsname,
    hoheitsgrenzen_kanton.kantonsnummer,
    kantonskuerzel
;
