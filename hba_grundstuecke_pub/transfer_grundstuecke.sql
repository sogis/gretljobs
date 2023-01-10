
WITH liegenschaft AS 
(
    SELECT 
        hba_grundstueck.egrid,
        CASE 
            WHEN hba_grundstueck.recht = 'Stiftung' THEN 'Stiftung'
            WHEN hba_grundstueck.recht = 'Miete' THEN 'Miete'
            WHEN hba_grundstueck.recht = 'Eigentum' THEN 'Eigentum'
            WHEN hba_grundstueck.recht = 'Allmend' THEN 'Allmend'
        END AS recht,
        hba_grundstueck.recht AS recht_txt,
        hba_grundstueck.fachverantwortung,     
        hba_grundstueck.vermoegensart, 
        CASE 
            WHEN hba_grundstueck.vermoegensart = 'VV' THEN 'Verwaltungsvermögen'
            WHEN hba_grundstueck.vermoegensart = 'ALLM' THEN 'Allmend'
            WHEN hba_grundstueck.vermoegensart = 'SV' THEN 'Stiftungsvermögen'
            WHEN hba_grundstueck.vermoegensart = 'FV' THEN 'Finanzvermögen'
            WHEN hba_grundstueck.vermoegensart = 'AM' THEN 'Anmietobjekt'
        END AS vermoegensart_txt,
        hba_grundstueck.wirtschaftseinheit,
        liegenschaft.geometrie,
        ST_PointOnSurface(liegenschaft.geometrie) AS point
    FROM 
        agi_dm01avso24.liegenschaften_liegenschaft AS liegenschaft
        LEFT JOIN agi_dm01avso24.liegenschaften_grundstueck AS grundstueck 
        ON liegenschaft.liegenschaft_von = grundstueck.t_id  
        INNER JOIN hba_grundstuecke_v1.grundstuecke_grundstueck AS hba_grundstueck 
        ON hba_grundstueck.egrid = grundstueck.egris_egrid
    WHERE 
        hba_grundstueck.recht != 'Miete'
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
    liegenschaft.recht,
    liegenschaft.recht_txt,
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