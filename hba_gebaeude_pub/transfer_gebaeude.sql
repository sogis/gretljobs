
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
    wirtschaftseinheit,
    geometrie,
    vermoegensart,
    CASE 
        WHEN vermoegensart = 'VV' THEN 'Verwaltungsvermögen'
        WHEN vermoegensart = 'ALLM' THEN 'Allmend'
        WHEN vermoegensart = 'SV' THEN 'Stiftungsvermögen'
        WHEN vermoegensart = 'FV' THEN 'Finanzvermögen'
        WHEN vermoegensart = 'AM' THEN 'Anmietobjekt'
    END AS vermoegensart_txt,
    prio AS prioritaet, 
    CASE 
        WHEN prio = 'A' THEN 'betriebsnotwendig'
        WHEN prio = 'B' THEN 'Nicht betriebsnotwendig, halten, periodische Überprüfung'
        WHEN prio = 'C' THEN 'Nicht betriebsnotwendig, verwertbar'
    END AS prioritaet_txt,
    aktuelle_nutzung
FROM 
(
    SELECT DISTINCT ON (gebaeude.t_id)
        gebaeude.t_id,
        gebaeude.egid,
        gebaeude.vermoegensart,
        gebaeude.wirtschaftseinheit,
        gebaeude.aktuelle_nutzung, 
        av_gebaeude.geometrie,
        gebaeude.prio
    FROM 
        hba_gebaeude_v2.gebaeude_gebaeude AS gebaeude
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
        gebaeude.vermoegensart,
        gebaeude.wirtschaftseinheit,
        gebaeude.aktuelle_nutzung, 
        av_gebaeude.geometrie,
        gebaeude.prio
    FROM 
        hba_gebaeude_v2.gebaeude_gebaeude AS gebaeude
        INNER JOIN av_gebaeude 
        ON CAST(av_gebaeude.gwr_egid AS TEXT) = gebaeude.egid 
    WHERE 
        gebaeude.egid IS NOT NULL 
)
AS foo
;