DELETE FROM 
    arp_richtplan_pub_v2.richtplankarte_ueberlagernde_flaeche
WHERE
    datenquelle = 'abbaustellen'
;

DELETE FROM 
    arp_richtplan_pub_v2.detailkarten_flaeche
WHERE
    datenquelle = 'abbaustellen'
;

INSERT INTO arp_richtplan_pub_v2.detailkarten_flaeche (
    objektname,
    abstimmungskategorie,
    geometrie,
    gemeindenamen,
    datenquelle,
    astatus
    )

SELECT
    bezeichnung AS objektname,
    'Ausgangslage' AS abstimmungskategorie,
    (St_Dump(mpoly)).geom AS geometrie,
    gemeinde_name  AS gemeindenamen,
    'abbaustellen' AS datenquelle,
    CASE 
        WHEN stand = 'InAbbau'
        THEN 'bestehend'
        WHEN stand = 'Bewilligt'
        THEN 'Erweiterung'
        WHEN stand = 'Richtplan'
        THEN 'neu'
        WHEN stand = 'Inaktiv'
        THEN 'zu_loeschen'
    END AS astatus
FROM
    afu_abbaustellen_pub_v2.abbaustelle
WHERE
    rohstoffart IN ('Kies', 'Kalkstein', 'Ton')
    AND
    stand IN ('InAbbau','Bewilligt','Richtplan','Inaktiv')
;