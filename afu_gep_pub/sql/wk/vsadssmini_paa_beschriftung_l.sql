WITH beschriftung_l AS (
    SELECT 
        l.t_ili_tid as aref,
        l.t_datasetname as dataset,
        l.astatus,
        l.funktionhierarchisch,
        CASE
            WHEN (l.lichte_breite <> 0 AND l.laengeeffektiv > 0 AND l.kote_von > 0 AND l.kote_nach > 0) THEN l.lichte_breite || ' - ' || ROUND(((l.kote_von - l.kote_nach) / l.laengeeffektiv * 1000), 1) || ' ‰'
            WHEN l.lichte_breite <> 0 THEN l.lichte_breite::TEXT
        END AS textinhalt,
        lt.textpos,
        CASE
            WHEN lt.textori >= 90 THEN
                lt.textori - 90
            ELSE
                lt.textori + 270
        END AS textori,
        lt.texthali,
        lt.textvali,
        CASE
            WHEN l.nutzungsart_ist = 'Bachwasser' AND profiltyp != 'offenes_Profil' THEN NULL
            WHEN l.funktionhydraulisch IN ('Pumpendruckleitung','Vakuumleitung') THEN NULL
            WHEN l.funktionhydraulisch IN ('Drainagetransportleitung', 'Sickerleitung') THEN NULL
            ELSE
                CASE 
                    WHEN l.finanzierung = 'oeffentlich' THEN
                        CASE 
                            WHEN l.nutzungsart_ist = 'entlastetes_Mischabwasser' THEN 'T_Label_Leitung_Entl'
                            WHEN l.nutzungsart_ist = 'Mischabwasser' THEN 'T_Label_Leitung_MA'
                            WHEN l.nutzungsart_ist IN ('Schmutzabwasser','Industrieabwasser') THEN 'T_Label_Leitung_SA'
                            WHEN l.nutzungsart_ist IN ('Reinabwasser','Niederschlagsabwasser') THEN 'T_Label_Leitung_RA'
                            WHEN l.nutzungsart_ist IN ('andere','unbekannt') THEN 'T_Label_Leitung_unbekannt'
                        END
                    WHEN l.finanzierung != 'oeffentlich' AND eig.organisationstyp = 'Privat' THEN
                        CASE
                            WHEN l.nutzungsart_ist = 'Mischabwasser' THEN 'T_Label_Leitung_MA_LE'
                            WHEN l.nutzungsart_ist IN ('Schmutzabwasser','Industrieabwasser') THEN 'T_Label_Leitung_SA_LE'
                            WHEN l.nutzungsart_ist IN ('Reinabwasser','Niederschlagsabwasser') THEN 'T_Label_Leitung_RA_LE'
                            WHEN l.nutzungsart_ist IN ('andere','unbekannt','entlastetes_Mischabwasser') THEN 'T_Label_Leitung_unbekannt_LE'
                        END
                    WHEN l.finanzierung != 'oeffentlich' AND eig.organisationstyp != 'Privat' THEN
                        CASE
                            WHEN l.nutzungsart_ist = 'Mischabwasser' THEN 'T_Label_Leitung_MA_dr'
                            WHEN l.nutzungsart_ist IN ('Schmutzabwasser','Industrieabwasser') THEN 'T_Label_Leitung_SA_dr'
                            WHEN l.nutzungsart_ist IN ('Reinabwasser','Niederschlagsabwasser') THEN 'T_Label_Leitung_RA_dr'
                            WHEN l.nutzungsart_ist IN ('andere','unbekannt','entlastetes_Mischabwasser') THEN 'T_Label_Leitung_unbekannt_dr'
                        END
                END
        END AS stilid
    FROM ${DB_SCHEMA_EDIT}.vsadssmini_leitung l
    JOIN ${DB_SCHEMA_EDIT}.vsadssmini_leitung_text lt ON lt.leitungref = l.t_id
    LEFT JOIN ${DB_SCHEMA_EDIT}.administration_organisation eig ON l.eigentuemerref = eig.t_id
    WHERE lt.textpos IS NOT NULL AND lt.plantyp = 'Werkplan' AND l.verlauf IS NOT NULL
)
INSERT INTO 
    ${DB_SCHEMA_PUB_STAGING}.wk_paa_beschriftung_l 
    (
        textinhalt, 
        textpos, 
        textori, 
        texthali, 
        textvali, 
        aref, 
        dataset, 
        stilid
    )
SELECT
    textinhalt,
    textpos,
    textori,
    texthali,
    textvali,
    aref,
    dataset,
    stilid
FROM beschriftung_l
WHERE astatus LIKE 'in_Betrieb%'
AND funktionhierarchisch LIKE 'PAA.%'
AND textinhalt IS NOT NULL
AND stilid IS NOT NULL
;