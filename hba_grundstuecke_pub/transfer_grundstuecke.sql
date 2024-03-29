WITH liegenschaft AS 
(
    SELECT 
        hba_grundstueck.egrid,
        hba_grundstueck.fachverantwortung,     
        hba_grundstueck.vermoegensart, 
        CASE 
            WHEN hba_grundstueck.vermoegensart = 'VV' THEN 'Verwaltungsvermögen'
            WHEN hba_grundstueck.vermoegensart = 'ALLM' THEN 'Allmend'
            WHEN hba_grundstueck.vermoegensart = 'SV' THEN 'Stiftungsvermögen'
            WHEN hba_grundstueck.vermoegensart = 'FV' THEN 'Finanzvermögen'
            WHEN hba_grundstueck.vermoegensart = 'AM' THEN 'Anmietobjekt'
        END AS vermoegensart_txt,
        hba_grundstueck.prio AS prioritaet, 
        CASE 
            WHEN hba_grundstueck.prio = 'A' THEN 'betriebsnotwendig'
            WHEN hba_grundstueck.prio = 'B' THEN 'Nicht betriebsnotwendig, halten, periodische Überprüfung'
            WHEN hba_grundstueck.prio = 'C' THEN 'Nicht betriebsnotwendig, verwertbar'
        END AS prioritaet_txt,
        hba_grundstueck.wirtschaftseinheit,
        liegenschaft.geometrie,
        ST_PointOnSurface(liegenschaft.geometrie) AS point
    FROM 
        agi_dm01avso24.liegenschaften_liegenschaft AS liegenschaft
        LEFT JOIN agi_dm01avso24.liegenschaften_grundstueck AS grundstueck 
        ON liegenschaft.liegenschaft_von = grundstueck.t_id  
        INNER JOIN hba_grundstuecke_v2.grundstuecke_grundstueck AS hba_grundstueck 
        ON hba_grundstueck.egrid = grundstueck.egris_egrid
)
,
baurecht AS 
(
    SELECT
        grundstueck.egris_egrid,
        selbstrecht.geometrie
    FROM 
        agi_dm01avso24.liegenschaften_selbstrecht AS selbstrecht
        LEFT JOIN agi_dm01avso24.liegenschaften_grundstueck AS grundstueck 
        ON selbstrecht.selbstrecht_von = grundstueck.t_id 
    WHERE 
        grundstueck.art = 'SelbstRecht.Baurecht'
)
-- Kann zu doppelten liegenschaften führen, falls mehrere Baurechte auf Grundstück liegen.
-- DISTINCT ON
SELECT DISTINCT ON (liegenschaft.egrid)
    liegenschaft.egrid,
    liegenschaft.prioritaet,
    liegenschaft.prioritaet_txt,
    liegenschaft.fachverantwortung,
    liegenschaft.vermoegensart,
    liegenschaft.vermoegensart_txt,
    liegenschaft.wirtschaftseinheit,
    liegenschaft.geometrie,
    CASE
        WHEN baurecht.egris_egrid IS NOT NULL THEN TRUE
        ELSE FALSE
    END AS baurecht_dritter,
    CASE
        WHEN baurecht.egris_egrid IS NOT NULL THEN 'true'
        ELSE 'false'
    END AS baurecht_dritter_txt
FROM 
    liegenschaft 
    LEFT JOIN baurecht 
    ON ST_Intersects(liegenschaft.point, baurecht.geometrie)
;