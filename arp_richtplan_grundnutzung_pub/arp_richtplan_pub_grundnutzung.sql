DELETE FROM 
    arp_richtplan_pub_v2.richtplankarte_grundnutzung
WHERE
    datenquelle = 'grundnutzung'
;

INSERT INTO arp_richtplan_pub_v2.richtplankarte_grundnutzung (
    abstimmungskategorie, 
    grundnutzungsart,
    geometrie,
    dokumente,
    planungsstand,
    datenquelle
    )

SELECT
    'Ausgangslage' AS abstimmungskategorie,
    CASE
        WHEN typ_code_kt = 320
        THEN 'Gewaesser'
        WHEN typ_code_kt = 564
        THEN 'Nationalstrasse'
        WHEN typ_code_kt = 440
        THEN 'Wald'
        WHEN typ_code_ch IN (11,13,14,15,16,17,19)
        THEN 'Siedlungsgebiet.Wohnen_oeffentliche_Bauten'
        WHEN typ_code_ch = 12
        THEN 'Siedlungsgebiet.Industrie_Arbeiten'
        WHEN typ_code_ch = 43
        THEN 'Reservezone'
        WHEN typ_code_ch IN (21,22,23,29)
        THEN 'Landwirtschaftsgebiet'
        WHEN typ_code_ch IN (18,42)
        THEN 'Strasse'
    END AS grundnutzungsart,
    geometrie,
    dokumente,
    'rechtsgueltig' AS planungsstand,
    'grundnutzung' AS datenquelle
FROM
    arp_nutzungsplanung_pub_v1.nutzungsplanung_grundnutzung
WHERE
    typ_code_kt IN (320,564,440)
    OR 
    typ_code_ch IN (11,13,14,15,16,17,19,12,43,21,22,23,29,18,42)
;