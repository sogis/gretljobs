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
    dokumente,
    astatus,
    datenquelle
    )

WITH

Areal AS (
    SELECT
        'Grundwasserschutzzone_areal' AS objekttyp,
        'Areal' AS weitere_informationen,
        st_multi(sa.apolygon) AS geometrie,
        string_agg(g.gemeindename, ', ') AS gemeindenamen,
        'Ausgangslage' AS abstimmungskategorie,
        'rechtsgueltig' AS planungsstand,
        sa.dokumente AS dokumente,
        'bestehend' AS astatus,
        'gewaesserschutz' AS datenquelle
    FROM
        afu_gewaesserschutz_pub_v1.gewaesserschutz_schutzareal AS sa,
        agi_hoheitsgrenzen_pub.gemeindegrenze AS g
    WHERE
        sa.rechtsstatus = 'inKraft'
    AND
        ST_Intersects(sa.apolygon, g.geometrie) = TRUE
    AND
        st_multi(sa.apolygon) IS NOT NULL
    GROUP BY
        sa.apolygon,
        sa.dokumente
    ORDER BY
        gemeindenamen
    ),
    
Zone AS(
    SELECT
        'Grundwasserschutzzone_areal' AS objekttyp,
        'Zone' AS weitere_informationen,
        st_multi(sz.apolygon) AS geometrie,
        string_agg(g.gemeindename, ', ') AS gemeindenamen,
        'Ausgangslage' AS abstimmungskategorie,
        'rechtsgueltig' AS planungsstand,
        sz.dokumente AS dokumente,
        'bestehend' AS astatus,
        'gewaesserschutz' AS datenquelle
    FROM
        afu_gewaesserschutz_pub_v1.gewaesserschutz_schutzzone AS sz,
        agi_hoheitsgrenzen_pub.gemeindegrenze AS g
    WHERE
        sz.rechtsstatus = 'inKraft'
    AND
        ST_Intersects(sz.apolygon, g.geometrie) = TRUE
    AND
        st_multi(sz.apolygon) IS NOT NULL
    GROUP BY
        sz.apolygon,
        sz.dokumente
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
    dokumente,
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
    dokumente,
    astatus,
    datenquelle
FROM
    Zone
;