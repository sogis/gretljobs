
WITH av_gebaeude AS 
(
    SELECT
        foo.t_id,
        bar.gwr_egid,                
        foo.geometrie 
    FROM 
        agi_dm01avso24.bodenbedeckung_boflaeche AS foo 
        LEFT JOIN agi_dm01avso24.bodenbedeckung_gebaeudenummer AS bar 
        ON foo.t_id = bar.gebaeudenummer_von
    WHERE 
        art = 'Gebaeude'
    UNION ALL 
    SELECT 
        eo.t_id,
        nummer.gwr_egid,
        geometrie 
    FROM 
        agi_dm01avso24.einzelobjekte_einzelobjekt AS eo
        LEFT JOIN agi_dm01avso24.einzelobjekte_flaechenelement AS flaele 
        ON eo.t_id = flaele.flaechenelement_von
        LEFT JOIN agi_dm01avso24.einzelobjekte_objektnummer AS nummer 
        ON eo.t_id = nummer.objektnummer_von
    WHERE 
        eo.art IN ('Unterstand', 'uebriger_Gebaeudeteil', 'unterirdisches_Gebaeude')            
)
SELECT 
    egid, 
    CASE 
        WHEN energietraeger = 'Pellet' THEN 'Pellet'
        WHEN energietraeger = 'Grundwasser' THEN 'Grundwasser'
        WHEN energietraeger = 'Erdgas' THEN 'Erdgas'
        WHEN energietraeger = 'Holzschnitzel' THEN 'Holzschnitzel'
        WHEN energietraeger = 'Heizöl' THEN 'Heizoel'
        WHEN energietraeger = 'Luft' THEN 'Luft'
        WHEN energietraeger = 'Fernwärme' THEN 'Fernwaerme'
        WHEN energietraeger = 'Erdwärme' THEN 'Erdwaerme'
        WHEN energietraeger = 'Elektro' THEN 'Elektro'
        WHEN energietraeger = '-' THEN 'nicht_beheizt'
        WHEN energietraeger IS NULL THEN 'unbekannt'
    END AS energietraeger,
    CASE 
        WHEN energietraeger = 'Pellet' THEN 'Pellet'
        WHEN energietraeger = 'Grundwasser' THEN 'Grundwasser'
        WHEN energietraeger = 'Erdgas' THEN 'Erdgas'
        WHEN energietraeger = 'Holzschnitzel' THEN 'Holzschnitzel'
        WHEN energietraeger = 'Heizöl' THEN 'Heizöl'
        WHEN energietraeger = 'Luft' THEN 'Luft'
        WHEN energietraeger = 'Fernwärme' THEN 'Fernwärme'
        WHEN energietraeger = 'Erdwärme' THEN 'Erdwärme'
        WHEN energietraeger = 'Elektro' THEN 'Elektro'
        WHEN energietraeger = '-' THEN 'nicht beheizt'
        WHEN energietraeger IS NULL THEN 'unbekannt'
    END AS energietraeger_txt,
    CASE 
        WHEN nutzungsart = 'Finanzvermögen' THEN 'Finanzvermoegen'
        WHEN nutzungsart = 'Anmietobjekte' THEN 'Anmietobjekte'
        WHEN nutzungsart = 'Verwaltungsvermögen' THEN 'Verwaltungsvermoegen'
        WHEN nutzungsart = 'Stiftungsvermögen' THEN 'Stiftungsvermoegen'
    END AS nutzungsart,
    CASE 
        WHEN nutzungsart = 'Finanzvermögen' THEN 'Finanzvermögen'
        WHEN nutzungsart = 'Anmietobjekte' THEN 'Anmietobjekte'
        WHEN nutzungsart = 'Verwaltungsvermögen' THEN 'Verwaltungsvermögen'
        WHEN nutzungsart = 'Stiftungsvermögen' THEN 'Stiftungsvermögen'
    END AS nutzungsart_txt,
    wirtschaftseinheit,
    geometrie
FROM 
(
    SELECT DISTINCT ON (gebaeude.t_id)
        gebaeude.t_id,
        gebaeude.egid,
        gebaeude.energietraeger,
        gebaeude.nutzungsart,
        gebaeude.wirtschaftseinheit, 
        av_gebaeude.geometrie
    FROM 
        hba_gebaeude_v1.gebaeude_gebaeude AS gebaeude
        INNER JOIN av_gebaeude
        ON ST_Intersects(ST_SetSRID(ST_MakePoint(xkoordinaten, ykoordinaten),2056), av_gebaeude.geometrie)
    WHERE 
        xkoordinaten IS NOT NULL 
        AND 
        ykoordinaten IS NOT NULL
        AND 
        egid IS NULL 
    
    UNION ALL 
        
    SELECT DISTINCT ON (gebaeude.t_id)
        gebaeude.t_id,
        gebaeude.egid,
        gebaeude.energietraeger,
        gebaeude.nutzungsart,
        gebaeude.wirtschaftseinheit, 
        av_gebaeude.geometrie
    FROM 
        hba_gebaeude_v1.gebaeude_gebaeude AS gebaeude
        INNER JOIN av_gebaeude 
        ON CAST(av_gebaeude.gwr_egid AS TEXT) = gebaeude.egid 
    WHERE 
        gebaeude.egid IS NOT NULL 
)
AS foo
    
    