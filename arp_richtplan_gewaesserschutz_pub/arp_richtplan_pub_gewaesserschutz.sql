DELETE FROM 
    arp_richtplan_pub_v2.richtplankarte_ueberlagernde_flaeche
WHERE
    datenquelle = 'gewaesserschutz'
;

INSERT INTO arp_richtplan_pub_v2.richtplankarte_ueberlagernde_flaeche (
    objekttyp,
    weitere_informationen,
    geometrie,
    gemeindenamen,
    abstimmungskategorie,
    planungsstand,
    astatus,
    datenquelle
    )

WITH

Areal AS (
    SELECT
        'Grundwasserschutzzone_areal' AS objekttyp,
        'Areal' AS weitere_informationen,
        st_multi(st_union(sa.apolygon)) AS geometrie,
        string_agg(g.gemeindename, ', ') AS gemeindenamen,
        'Ausgangslage' AS abstimmungskategorie,
        'rechtsgueltig' AS planungsstand,
        'bestehend' AS astatus,
        'gewaesserschutz' AS datenquelle
    FROM
        afu_gewaesserschutz_pub_v1.gewaesserschutz_schutzareal AS sa,
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS g
    WHERE
        sa.rechtsstatus = 'inKraft'
    AND
        ST_Intersects(sa.apolygon, g.geometrie) = TRUE
    AND
        st_multi(sa.apolygon) IS NOT NULL
    GROUP BY
        sa.rechtskraftdatum
    ORDER BY
        gemeindenamen
    ),
    
Zone AS(
    SELECT
        'Grundwasserschutzzone_areal' AS objekttyp,
        'Zone' AS weitere_informationen,
        st_multi(st_union(sz.apolygon)) AS geometrie,
        string_agg(g.gemeindename, ', ') AS gemeindenamen,
        'Ausgangslage' AS abstimmungskategorie,
        'rechtsgueltig' AS planungsstand,
        'bestehend' AS astatus,
        'gewaesserschutz' AS datenquelle
    FROM
        afu_gewaesserschutz_pub_v1.gewaesserschutz_schutzzone AS sz,
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS g
    WHERE
        sz.rechtsstatus = 'inKraft'
    AND
        ST_Intersects(sz.apolygon, g.geometrie) = TRUE
    AND
        st_multi(sz.apolygon) IS NOT NULL
    GROUP BY
        sz.rechtskraftdatum
    ORDER BY
        gemeindenamen
    )

SELECT
    objekttyp,
    weitere_informationen,
    geometrie,
    gemeindenamen,
    abstimmungskategorie,
    planungsstand,
    astatus,
    datenquelle
FROM
    Areal

UNION ALL

SELECT
    objekttyp,
    weitere_informationen,
    geometrie,
    gemeindenamen,
    abstimmungskategorie,
    planungsstand,
    astatus,
    datenquelle
FROM
    Zone
;