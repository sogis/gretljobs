WITH schaechte AS (
    SELECT
        k.t_id,
        k.t_ili_tid AS oid_dss,
        k.t_datasetname as dataset,
        REPLACE(k.nutzungsart_ist, '_', ' ') AS nutzungsart_ist,
        REPLACE(k.nutzungsart_geplant, '_', ' ') AS nutzungsart_geplant,
        CASE
            WHEN k.funktion = 'Abflusslose_Toilette' THEN 'Abflusslose Toilette'
            WHEN k.funktion = 'abflussloseGrube' THEN 'Abflusslose Grube'
            WHEN k.funktion = 'ARABauwerk' THEN 'ARA'
            WHEN k.funktion = 'Duekerkammer' THEN 'Dükerkammer'
            WHEN k.funktion = 'Duekeroberhaupt' THEN 'Dükeroberhaupt'
            WHEN k.funktion IN ('Einleitstelle_gewaesserrelevant','Einleitstelle_nicht_gewaesserrelevant') THEN 'Einleitstelle'
            WHEN k.funktion IN ('andere','Behandlungsanlage','Fettabscheider','Oelabscheider','Schwimmstoffabscheider','unbekannt','Vorbehandlungsanlage','Wirbelfallschacht') THEN 'Übrige Sonderbauwerke'
            WHEN k.funktion = 'Guellegrube' THEN 'Güllegrube'
            WHEN k.funktion = 'Klaergrube' THEN 'Klärgrube'
            WHEN k.funktion = 'KLARA' THEN 'Kleinkläranlage'
            WHEN k.funktion = 'Kontroll_Einsteigschacht' THEN 'Kontrollschacht'
            WHEN k.funktion = 'Regenbecken_Regenklaerbecken' THEN 'Regenklärbecken'
            WHEN k.funktion = 'Regenbecken_Regenrueckhaltebecken' THEN 'Regenrückhaltebecken'
            WHEN k.funktion = 'Regenbecken_Regenrueckhaltekanal' THEN 'Regenrückhaltekanal'
            WHEN k.funktion IN ('Regenbecken_Durchlaufbecken','Regenbecken_Fangbecken','Regenbecken_Fangkanal','Regenbecken_Stauraumkanal','Regenbecken_Verbundbecken') THEN 'Regenüberlaufbecken'
            WHEN k.funktion = 'Regenueberlauf' THEN 'Regenüberlauf'
            ELSE REPLACE(k.funktion, '_', ' ')
        END AS funktion,
        k.finanzierung,
        k.funktionhierarchisch,
        k.lage,
        k.astatus,
        TRUE AS istneuesteversion,
        k.baujahr,
        CASE 
            WHEN k.baulicherzustand = 'Z0' THEN 'Z0: Nicht mehr funktionstüchtig'
            WHEN k.baulicherzustand = 'Z1' THEN 'Z1: Starke Mängel'
            WHEN k.baulicherzustand = 'Z2' THEN 'Z2: Mittlere Mängel'
            WHEN k.baulicherzustand = 'Z3' THEN 'Z3: Leichte Mängel'
            WHEN k.baulicherzustand = 'Z4' THEN 'Z4: Keine Mängel'
            ELSE k.baulicherzustand
        END AS baulicherzustand,
        k.bezeichnung,
        k.deckelkote,
        k.sohlenkote,
        k.zustandserhebung_jahr,
        l.funktionhydraulisch AS leitung_funktionhydraulisch,
        eig.organisationstyp AS eigentuemer_organisationstyp,
        eig.bezeichnung AS eigentuemer_bezeichnung,
        betr.organisationstyp AS betreiber_organisationstyp,
        betr.bezeichnung AS betreiber_bezeichnung,
        CASE
            WHEN k.finanzierung = 'oeffentlich' AND k.nutzungsart_ist = 'Reinabwasser' THEN 'P_RA'
            WHEN k.finanzierung != 'oeffentlich' AND eig.organisationstyp = 'Privat' AND k.nutzungsart_ist = 'Reinabwasser' THEN 'P_RA_LE'
            WHEN k.finanzierung != 'oeffentlich' AND eig.organisationstyp != 'Privat' AND k.nutzungsart_ist = 'Reinabwasser' THEN 'P_RA_dr'
        END AS stilid
    FROM 
        alw_drainagen_v1.vsadssmini_knoten k
        LEFT JOIN alw_drainagen_v1.vsadssmini_leitung l ON l.knoten_vonref = k.t_id
        LEFT JOIN alw_drainagen_v1.administration_organisation eig ON k.eigentuemerref = eig.t_id
        LEFT JOIN alw_drainagen_v1.administration_organisation betr ON k.betreiberref = betr.t_id
    WHERE 
        k.lage IS NOT NULL
)

SELECT DISTINCT
    NULL AS t_ili_tid, -- t_ili_tid ist keine UUID im edit-Modell   
    baujahr,
    baulicherzustand,
    betreiber_bezeichnung,
    betreiber_organisationstyp,
    bezeichnung,
    dataset,
    deckelkote,
    eigentuemer_bezeichnung,
    eigentuemer_organisationstyp,
    finanzierung,
    funktion,
    funktionhierarchisch,
    istneuesteversion,
    lage,
    nutzungsart_ist,
    nutzungsart_geplant,
    oid_dss,
    sohlenkote,
    astatus,
    stilid,
    zustandserhebung_jahr
FROM 
    schaechte
WHERE 
    astatus LIKE 'in_Betrieb%'
    AND 
        funktionhierarchisch = 'SAA'
    AND 
        leitung_funktionhydraulisch IN ('Drainagetransportleitung', 'Sickerleitung')
    AND 
    stilid IS NOT NULL
;
