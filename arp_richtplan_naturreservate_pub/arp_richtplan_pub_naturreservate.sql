DELETE FROM 
    arp_richtplan_pub_v2.richtplankarte_ueberlagernde_flaeche
WHERE
    datenquelle = 'naturreservate'
;

INSERT INTO arp_richtplan_pub_v2.richtplankarte_ueberlagernde_flaeche (
    objektnummer,
    objekttyp, 
    geometrie,
    gemeindenamen,
    objektname,
    abstimmungskategorie,
    planungsstand,
    dokumente,
    astatus,
    datenquelle
    )

SELECT
    nummer AS objektnummer,
    'kantonales_Naturreservat' AS objekttyp,
    st_multi(ST_BuildArea(geometrie)) AS geometrie,
    gemeinden AS gemeindenamen,
    teilgebietsnamen AS objektname,
    'Ausgangslage' AS abstimmungskategorie,
    'rechtsgueltig' AS planungsstand,
    dokumente,
    'bestehend' AS astatus,
    'naturreservate' AS datenquelle
FROM
    arp_naturreservate_pub.reservat
;