DELETE FROM 
    arp_richtplan_pub_v2.richtplankarte_ueberlagernde_flaeche
WHERE
    datenquelle = 'fruchtfolgeflaeche'
;

INSERT INTO arp_richtplan_pub_v2.richtplankarte_ueberlagernde_flaeche (
    objekttyp, 
    geometrie,
    gemeindenamen,
    abstimmungskategorie,
    planungsstand,
    dokumente,
    astatus,
    datenquelle
    )

SELECT
    'Fruchtfolgeflaeche' AS objekttyp,
    st_multi(f.geometrie) AS geometrie,
    string_agg(g.gemeindename, ', ') AS gemeindenamen,
    'Ausgangslage' AS abstimmungskategorie,
    'rechtsgueltig' AS planungsstand,
    'https://geo.so.ch/docs/ch.so.arp.richtplan/L-1_2.pdf' AS dokumente,
    'bestehend' AS astatus,
    'fruchtfolgeflaeche' AS datenquelle
FROM
    alw_fruchtfolgeflaechen_pub_v1.fruchtfolgeflaeche AS f,
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS g
WHERE 
    ST_Intersects(f.geometrie, g.geometrie) = TRUE
    AND
    st_multi(f.geometrie) IS NOT NULL
GROUP BY 
    f.geometrie
ORDER by 
    gemeindenamen
;