SELECT
    schaechte_und_bauwerke.geometrie,
    schaechte_und_bauwerke.schacht_id,
    schaechte_und_bauwerke.kategorie AS kategorie_kurz,
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
        ELSE schaechte_und_bauwerke.kategorie
    END AS kategorie,
    schaechte_und_bauwerke.astatus,
    schaechte_und_bauwerke.teilgebiet,
    schaechte_und_bauwerke.qualitaet,
    schaechte_und_bauwerke.deckelhoehe,
    schaechte_und_bauwerke.ueberdeckung,
    schaechte_und_bauwerke.erfassung,
    schaechte_und_bauwerke.erfasser,
    schaechte_und_bauwerke.bearbeitung,
    schaechte_und_bauwerke.bearbeiter,
    CASE
        WHEN schaechte_und_bauwerke.eigentum = 1
            THEN 'Gemeinde'
        WHEN schaechte_und_bauwerke.eigentum = 2
            THEN 'Abwasserzweckverband'
    END AS eigentum,
    schaechte_und_bauwerke.bemerkungen,
    gemeindegrenze.gemeindename
    
FROM
    afu_abwasserbauwerke_v1.schaechte_und_bauwerke AS schaechte_und_bauwerke,
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS gemeindegrenze
WHERE
     schaechte_und_bauwerke.gemeinde = gemeindegrenze.bfs_gemeindenummer
AND 
    schaechte_und_bauwerke.kategorie IS NOT NULL
AND 
    schaechte_und_bauwerke.eigentum IS NOT NULL
;
