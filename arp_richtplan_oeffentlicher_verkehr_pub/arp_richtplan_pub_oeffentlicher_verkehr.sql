DELETE FROM 
    arp_richtplan_pub_v2.richtplankarte_ueberlagernde_linie
WHERE
    datenquelle = 'oeffentlicher_verkehr'
;

INSERT INTO arp_richtplan_pub_v2.richtplankarte_ueberlagernde_linie (
    objekttyp, 
    geometrie,
    abstimmungskategorie,
    planungsstand,
    astatus,
    datenquelle
    )

SELECT
    CASE
        WHEN verkehrsmittel = 'Bahn' AND tunnel is FALSE
        THEN 'Bahnlinie.Schiene'
        WHEN verkehrsmittel = 'Bahn' AND tunnel IS TRUE 
        THEN 'Bahnlinie.Tunnel'
    END AS objekttyp,
    ST_Multi(ST_CurveToLine(geometrie)) AS geometrie,
    'Ausgangslage' AS abstimmungskategorie,
    'rechtsgueltig' AS planungsstand,
    'bestehend' AS astatus,
    'oeffentlicher_verkehr' AS datenquelle
FROM
    avt_oeffentlicher_verkehr_pub.oeffntlchr_vrkehr_netz
WHERE verkehrsmittel = 'Bahn'
;