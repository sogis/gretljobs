SELECT
    geometrie,
    schacht_id,
    kategorie AS kategorie_kurz,
    CASE
        WHEN kategorie = 'KS'
            THEN 'Kontrollschacht'
        WHEN kategorie = 'TS'
            THEN 'Trennschacht'
        WHEN kategorie = 'MS'
            THEN 'Messschacht'
        WHEN kategorie = 'PW'
            THEN 'Pumpwerk'
        WHEN kategorie = 'RA'
            THEN 'Regenauslass'
        WHEN kategorie = 'RB'
            THEN 'Regenbecken'
        WHEN kategorie = 'FB'
            THEN 'Fangbecken'
        WHEN kategorie = 'KB'
            THEN 'Klärbecken'
        WHEN kategorie = 'VB'
            THEN 'Verbundbecken'
        WHEN kategorie = 'RRB'
            THEN 'Regenrückhaltebecken'
        WHEN kategorie = 'ARA'
            THEN 'Abwasserreinigungsanlage'
        WHEN kategorie = 'A'
            THEN 'Auslauf'
        ELSE kategorie
    END AS kategorie,
    astatus,
    teilgebiet,
    qualitaet,
    deckelhoehe,
    ueberdeckung,
    erfassung,
    erfasser,
    bearbeitung,
    bearbeiter,
    CASE
        WHEN eigentum = 1
            THEN 'Gemeinde'
        WHEN eigentum = 2
            THEN 'Abwasserzweckverband'
    END AS eigentum,
    bemerkungen,

    
    --gemeindename,
    
    gemeinde
    
FROM
    afu_abwasserbauwerke_v1.schaechte_und_bauwerke AS schaechte_und_bauwerke
--     LEFT JOIN agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS gemeindegrenze
--         ON schaechte_und_bauwerke.gemeinde = gemeindegrenze.bfs_gemeindenummer
;
