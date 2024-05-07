SELECT
    'Ausgangslage' AS abstimmungskategorie,
    CASE
        WHEN typ_bezeichnung = 'Landwirtschaftszone'
        THEN 'Landwirtschaftsgebiet'
        WHEN typ_bezeichnung = 'Wald'
        THEN 'Wald'
    END AS grundnutzungsart,
    geometrie,
    'rechtsgueltig' AS planungsstand,
    'richtplan_prov' AS datenquelle
FROM
    arp_nutzungsplanung_digizone_v1.nutzungsplanung_grundnutzung
WHERE
    bemerkungen = 'provisorisch erfasst für Richtplan'