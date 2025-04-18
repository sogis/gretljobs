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
        ST_ReducePrecision(
            ST_Union(sa.apolygon), 0.001
        ) AS geometrie,
        string_agg(g.gemeindename, ', ') AS gemeindenamen,
        'Festsetzung' AS abstimmungskategorie,
        'rechtsgueltig' AS planungsstand,
        'https://geo.so.ch/docs/ch.so.arp.richtplan/E-1_2.pdf' AS dokumente,
        'bestehend' AS astatus,
        'gewaesserschutz' AS datenquelle
    FROM
        afu_gewaesserschutz_pub_v3.gewaesserschutz_schutzareal AS sa,
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS g
    WHERE
        sa.rechtsstatus IN ('inKraft', 'AenderungMitVorwirkung', 'AenderungOhneVorwirkung')
    AND
        ST_Intersects(sa.apolygon, g.geometrie) = TRUE
    AND
        st_multi(sa.apolygon) IS NOT NULL
    GROUP BY
        sa.rechtskraftdatum

    UNION

    SELECT
        'Grundwasserschutzzone_areal' AS objekttyp,
        'Areal' AS weitere_informationen,
        ST_ReducePrecision(
            ST_Union(sa.apolygon), 0.001
        ) AS geometrie,
        string_agg(g.gemeindename, ', ') AS gemeindenamen,
        'Festsetzung' AS abstimmungskategorie,
        'rechtsgueltig' AS planungsstand,
        'https://geo.so.ch/docs/ch.so.arp.richtplan/E-1_2.pdf' AS dokumente,
        'neu' AS astatus,
        'gewaesserschutz' AS datenquelle
    FROM
        afu_gewaesserschutz_pub_v3.gewaesserschutz_schutzareal AS sa,
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS g
    WHERE
        sa.rechtsstatus LIKE 'RichtplanFestsetzung'
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
        ST_ReducePrecision(
            ST_Union(sz.apolygon), 0.001
        ) AS geometrie,
        string_agg(g.gemeindename, ', ') AS gemeindenamen,
        'Ausgangslage' AS abstimmungskategorie,
        'rechtsgueltig' AS planungsstand,
        'https://geo.so.ch/docs/ch.so.arp.richtplan/E-1_2.pdf' AS dokumente,
        'bestehend' AS astatus,
        'gewaesserschutz' AS datenquelle
    FROM
        afu_gewaesserschutz_pub_v3.gewaesserschutz_schutzzone AS sz,
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS g
    WHERE
        sz.rechtsstatus IN ('inKraft', 'AenderungOhneVorwirkung', 'AenderungMitVorwirkung')
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
