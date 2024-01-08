WITH beschriftung_p AS (
    SELECT 
        k.t_ili_tid as aref,
        k.t_datasetname as dataset,
        k.astatus,
        k.funktionhierarchisch,
        k.bezeichnung AS textinhalt,
        k.lage AS textpos,
        0 AS textori,
        'Left' AS texthali,
        'Bottom' AS textvali,
        l.funktionhydraulisch AS leitung_funktionhydraulisch,
        CASE
            WHEN k.funktion IN ('Versickerungsanlage','Messstelle','Pumpwerk','Regenbecken_Regenrueckhaltebecken','Regenbecken_Regenrueckhaltekanal','Trennbauwerk','Duekeroberhaupt','Regenueberlauf') THEN 'T_Label_SBW'
            WHEN k.funktion LIKE 'Einleitstelle%' THEN 'T_Label_SBW'
            WHEN k.funktion LIKE 'Regenbecken_%' AND k.funktion NOT IN ('Regenbecken_Regenrueckhaltebecken','Regenbecken_Regenrueckhaltekanal') THEN 'T_Label_SBW'
            WHEN k.funktion IN ('KLARA','ARABauwerk') THEN 'T_Label_SBW'
            WHEN (k.funktion IN ('Behandlungsanlage','Wirbelfallschacht') OR k.funktion LIKE '%abscheider') THEN 'T_Label_SBW'
            WHEN k.funktion IN ('andere','unbekannt') AND sk.paa_knotenref IS NOT NULL THEN 'T_Label_SBW'
            ELSE
                CASE
                    WHEN k.nutzungsart_ist = 'Bachwasser' THEN 'T_Label_Knoten_BW'
                    WHEN k.finanzierung = 'oeffentlich' THEN
                        CASE 
                            WHEN k.nutzungsart_ist = 'entlastetes_Mischabwasser' THEN 'T_Label_Knoten_Entl'
                            WHEN k.nutzungsart_ist = 'Mischabwasser' THEN 'T_Label_Knoten_MA'
                            WHEN k.nutzungsart_ist IN ('Schmutzabwasser','Industrieabwasser') THEN 'T_Label_Knoten_SA'
                            WHEN k.nutzungsart_ist IN ('Reinabwasser','Niederschlagsabwasser') THEN 'T_Label_Knoten_RA'
                            WHEN k.nutzungsart_ist IN ('andere','unbekannt') THEN 'T_Label_Knoten_unbekannt'
                        END
                    WHEN k.finanzierung != 'oeffentlich' AND eig.organisationstyp = 'Privat' THEN
                        CASE
                            WHEN k.nutzungsart_ist = 'Mischabwasser' THEN 'T_Label_Knoten_MA_LE'
                            WHEN k.nutzungsart_ist IN ('Schmutzabwasser','Industrieabwasser') THEN 'T_Label_Knoten_SA_LE'
                            WHEN k.nutzungsart_ist IN ('Reinabwasser','Niederschlagsabwasser') THEN 'T_Label_Knoten_RA_LE'
                            WHEN k.nutzungsart_ist IN ('andere','unbekannt','entlastetes_Mischabwasser') THEN 'T_Label_Knoten_unbekannt_LE'
                        END
                    WHEN k.finanzierung != 'oeffentlich' AND eig.organisationstyp != 'Privat' THEN
                        CASE
                            WHEN k.nutzungsart_ist = 'Mischabwasser' THEN 'T_Label_Knoten_MA_dr'
                            WHEN k.nutzungsart_ist IN ('Schmutzabwasser','Industrieabwasser') THEN 'T_Label_Knoten_SA_dr'
                            WHEN k.nutzungsart_ist IN ('Reinabwasser','Niederschlagsabwasser') THEN 'T_Label_Knoten_RA_dr'
                            WHEN k.nutzungsart_ist IN ('andere','unbekannt','entlastetes_Mischabwasser') THEN 'T_Label_Knoten_unbekannt_dr'
                        END
                END
        END AS stilid
    FROM ${DB_SCHEMA_EDIT}.vsadssmini_knoten k
    LEFT JOIN ${DB_SCHEMA_EDIT}.vsadssmini_leitung l ON l.knoten_vonref = k.t_id
    LEFT JOIN ${DB_SCHEMA_EDIT}.vsadssmini_sk sk ON k.t_id = sk.paa_knotenref
    LEFT JOIN ${DB_SCHEMA_EDIT}.administration_organisation eig ON k.eigentuemerref = eig.t_id
    WHERE k.lage IS NOT NULL
)
INSERT INTO 
    ${DB_SCHEMA_PUB_STAGING}.wk_paa_beschriftung_p 
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
SELECT DISTINCT
    textinhalt,
    textpos,
    textori,
    texthali,
    textvali,
    aref,
    dataset,
    stilid
FROM beschriftung_p
WHERE astatus LIKE 'in_Betrieb%'
AND funktionhierarchisch = 'PAA'
AND textinhalt IS NOT NULL
AND (leitung_funktionhydraulisch NOT IN ('Drainagetransportleitung', 'Sickerleitung')
    OR leitung_funktionhydraulisch IS NULL)
AND stilid IS NOT NULL
;