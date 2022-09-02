DELETE FROM agi_hoheitsgrenzen_pub.hoheitsgrenzen_bezirksgrenze_generalisiert
;

INSERT INTO agi_hoheitsgrenzen_pub.hoheitsgrenzen_bezirksgrenze_generalisiert (
    bezirksname,
    bezirksnummer,
    kantonsname, 
    geometrie
)

SELECT 
    hoheitsgrenzen_gemeindegrenze_generalisiert.bezirksname,
    hoheitsgrenzen_bezirk.bezirksnummer,
    hoheitsgrenzen_gemeindegrenze_generalisiert.kantonsname,
    ST_Multi(ST_Union(hoheitsgrenzen_gemeindegrenze_generalisiert.geometrie))
FROM
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze_generalisiert
    LEFT JOIN agi_hoheitsgrenzen_v1.hoheitsgrenzen_bezirk
        ON hoheitsgrenzen_bezirk.bezirksname = hoheitsgrenzen_gemeindegrenze_generalisiert.bezirksname
GROUP BY
    hoheitsgrenzen_gemeindegrenze_generalisiert.bezirksname,
    hoheitsgrenzen_bezirk.bezirksnummer,
    hoheitsgrenzen_gemeindegrenze_generalisiert.kantonsname
;
