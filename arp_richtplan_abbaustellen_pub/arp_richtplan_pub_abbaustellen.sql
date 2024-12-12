DELETE FROM 
    arp_richtplan_pub_v2.detailkarten_flaeche
WHERE
    datenquelle = 'abbaustellen'
;

INSERT INTO arp_richtplan_pub_v2.detailkarten_flaeche (
    objekttyp,
    objektname,
    abstimmungskategorie,
    geometrie,
    gemeindenamen,
    datenquelle,
    astatus
    )

SELECT
    CASE 
        WHEN rohstoffart = 'Kies'
        THEN 'Abbaustelle.Kies'
        WHEN rohstoffart = 'Kalkstein'
        THEN 'Abbaustelle.Kalkstein'
        WHEN rohstoffart = 'Ton'
        THEN 'Abbaustelle.Ton'
    END AS objekttyp, 
    bezeichnung AS objektname,
    CASE 
        WHEN art LIKE '%Ausgangslage%'
            THEN 'Ausgangslage'
        WHEN art LIKE '%Vororientierung%'
            THEN 'Vororientierung'
        WHEN art LIKE '%Zwischenergebnis%'
            THEN 'Zwischenergebnis'
        ELSE 'Ausgangslage'
    END AS abstimmungskategorie,
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
    AND
    richtplannummer IS NOT NULL
;