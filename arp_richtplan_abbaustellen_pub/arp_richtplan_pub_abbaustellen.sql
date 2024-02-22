DELETE FROM 
    arp_richtplan_pub_v2.richtplankarte_ueberlagernde_flaeche
WHERE
    datenquelle = 'abbaustellen'
;

INSERT INTO arp_richtplan_pub_v2.richtplankarte_ueberlagernde_flaeche (
    objektnummer,
    objekttyp, 
    geometrie,
    gemeindenamen,
    objektname,
    abstimmungskategorie,
    planungsstand,
    astatus,
    rrb_nr,
    rrb_datum,
    datenquelle
    )

SELECT
    substring(aktennummer FROM 5) AS objektnummer,
    CASE
        WHEN rohstoffart = 'Kies'
        THEN 'Abbaustelle.Kies'
        WHEN rohstoffart = 'Kalkstein'
        THEN 'Abbaustelle.Kalkstein'
        WHEN rohstoffart = 'Ton'
        THEN 'Abbaustelle.Ton'
    END AS objekttyp,
    st_multi(mpoly) AS geometrie,
    gemeinde_name  AS gemeindenamen,
    bezeichnung AS objektname,
    'Ausgangslage' AS abstimmungskategorie,
    'rechtsgueltig' AS planungsstand,
    CASE 
        WHEN stand = 'InAbbau'
        THEN 'bestehend'
        WHEN stand = 'Bewilligt'
        THEN 'Erweiterung'
        WHEN stand = 'Richtplan'
        THEN 'neu'
        WHEN stand = 'Inaktiv'
        THEN 'zu_loeschen'
    END AS astatus,
    rrb_nr,
    rrb_datum,
    'abbaustellen' AS datenquelle
FROM
    afu_abbaustellen_pub_v2.abbaustelle
WHERE
    rohstoffart IN ('Kies', 'Kalkstein', 'Ton')
    AND
    stand IN ('InAbbau','Bewilligt','Richtplan','Inaktiv')
;