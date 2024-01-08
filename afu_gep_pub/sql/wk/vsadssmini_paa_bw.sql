WITH bw AS (
    SELECT
        k.t_ili_tid as oid_dss,
        k.t_datasetname as dataset,
        REPLACE(k.nutzungsart_ist, '_', ' ') AS nutzungsart_ist,
        k.detailgeometrie,
        k.funktionhierarchisch,
        k.finanzierung,
        k.astatus,
        eig.organisationstyp AS eigentuemer_organisationstyp,
        CASE
            WHEN k.finanzierung = 'oeffentlich' THEN
                CASE 
                    WHEN k.nutzungsart_ist = 'entlastetes_Mischabwasser' THEN 'A_Entl'
                    WHEN k.nutzungsart_ist = 'Mischabwasser' THEN 'A_MA'
                    WHEN k.nutzungsart_ist IN ('Schmutzabwasser','Industrieabwasser') THEN 'A_SA'
                    WHEN k.nutzungsart_ist IN ('Reinabwasser','Niederschlagsabwasser') THEN 'A_RA'
                    WHEN k.nutzungsart_ist IN ('andere','unbekannt','Bachwasser') THEN 'A_unbekannt'
                END
            WHEN k.finanzierung != 'oeffentlich' AND eig.organisationstyp = 'Privat' THEN
                CASE
                    WHEN k.nutzungsart_ist = 'Mischabwasser' THEN 'A_MA_LE'
                    WHEN k.nutzungsart_ist IN ('Schmutzabwasser','Industrieabwasser') THEN 'A_SA_LE'
                    WHEN k.nutzungsart_ist IN ('Reinabwasser','Niederschlagsabwasser') THEN 'A_RA_LE'
                    WHEN k.nutzungsart_ist IN ('andere','unbekannt','Bachwasser','entlastetes_Mischabwasser') THEN 'A_unbekannt_LE'
                END
            WHEN k.finanzierung != 'oeffentlich' AND eig.organisationstyp != 'Privat' THEN
                CASE
                    WHEN k.nutzungsart_ist = 'Mischabwasser' THEN 'A_MA_dr'
                    WHEN k.nutzungsart_ist IN ('Schmutzabwasser','Industrieabwasser') THEN 'A_SA_dr'
                    WHEN k.nutzungsart_ist IN ('Reinabwasser','Niederschlagsabwasser') THEN 'A_RA_dr'
                    WHEN k.nutzungsart_ist IN ('andere','unbekannt','Bachwasser','entlastetes_Mischabwasser') THEN 'A_unbekannt_dr'
                END
        END AS stilid
    FROM ${DB_SCHEMA_EDIT}.vsadssmini_knoten k
    LEFT JOIN ${DB_SCHEMA_EDIT}.administration_organisation eig ON k.eigentuemerref = eig.t_id 
    LEFT JOIN ${DB_SCHEMA_EDIT}.administration_organisation betr ON k.betreiberref = betr.t_id
    WHERE detailgeometrie IS NOT NULL
)
INSERT INTO 
    ${DB_SCHEMA_PUB_STAGING}.wk_paa_bw 
    (
        eigentuemer_organisationstyp, 
        finanzierung, 
        funktionhierarchisch, 
        nutzungsart_ist, 
        detailgeometrie, 
        oid_dss, 
        astatus, 
        dataset, 
        stilid
    )
SELECT
    eigentuemer_organisationstyp,
    finanzierung,
    funktionhierarchisch,
    nutzungsart_ist,
    detailgeometrie,
    oid_dss,
    astatus,
    dataset,
    stilid
FROM bw
WHERE astatus LIKE 'in_Betrieb%'
AND funktionhierarchisch = 'PAA'
AND stilid IS NOT NULL
;
