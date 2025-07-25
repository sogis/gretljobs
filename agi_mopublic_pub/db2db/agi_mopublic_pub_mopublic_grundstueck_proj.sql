WITH gemeinde AS
(
    SELECT 
        aname, bfsnr
    FROM
        agi_dm01avso24.gemeindegrenzen_gemeinde 
),
pos AS
(
    SELECT
        -- one pos per parcel
        DISTINCT ON (projgrundstueckpos_von)
        projgrundstueckpos_von,
        CASE 
            WHEN ori IS NULL 
                THEN (100 - 100) * 0.9
            ELSE (100 - ori) * 0.9
        END AS orientierung,
        CASE 
            WHEN hali IS NULL 
                THEN 'Center'
            ELSE hali
        END AS hali,
        CASE 
            WHEN vali IS NULL 
                THEN 'Half'
            ELSE vali
        END AS vali,
        trim(to_char(ST_X(pos), '9999999.000'))::NUMERIC AS posX,
        trim(to_char(ST_Y(pos), '9999999.000'))::NUMERIC AS posY
    FROM 
        agi_dm01avso24.liegenschaften_projgrundstueckpos
),
aimport AS
(
    SELECT
        max(importdate) AS importdate, dataset
    FROM
        agi_dm01avso24.t_ili2db_import
    GROUP BY
        dataset 
),
-- Grundstuecke
grundstueck AS
(
    SELECT
        grundstueck.nbident,
        grundstueck.nummer,
        grundstueck.art AS art_txt,
        liegenschaft.flaechenmass,
        grundstueck.egris_egrid AS egrid,
        CAST(grundstueck.t_datasetname AS INT) AS bfs_nr,    
        orientierung,
        pos.hali,
        pos.vali,
        aimport.importdate AS importdatum,
        nachfuehrung.gueltigereintrag AS nachfuehrung,
        liegenschaft.geometrie AS geometrie,    
        ST_PointOnSurface(ST_MakeValid(liegenschaft.geometrie)) AS point_on_surface,
        pos.posX,
        pos.posY
    FROM
        agi_dm01avso24.liegenschaften_projgrundstueck AS grundstueck
        LEFT JOIN agi_dm01avso24.liegenschaften_projliegenschaft AS liegenschaft
            ON liegenschaft.projliegenschaft_von = grundstueck.t_id
        LEFT JOIN pos
            ON pos.projgrundstueckpos_von = grundstueck.t_id
        LEFT JOIN agi_dm01avso24.liegenschaften_lsnachfuehrung AS nachfuehrung
            ON grundstueck.entstehung = nachfuehrung.t_id
        LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
            ON grundstueck.t_basket = basket.t_id    
        LEFT JOIN aimport
            ON basket.dataset = aimport.dataset    
        
    WHERE 
        liegenschaft.geometrie IS NOT NULL

    UNION ALL

    SELECT
        grundstueck.nbident,
        grundstueck.nummer,
        grundstueck.art,
        selbstrecht.flaechenmass,
        grundstueck.egris_egrid AS egrid,
        CAST(grundstueck.t_datasetname AS INT) AS bfs_nr,    
        orientierung,
        pos.hali,
        pos.vali,
        aimport.importdate AS importdatum,
        nachfuehrung.gueltigereintrag AS nachfuehrung,
        selbstrecht.geometrie AS geometrie,
        ST_PointOnSurface(ST_MakeValid(selbstrecht.geometrie)) AS point_on_surface,
        pos.posX,
        pos.posY
    FROM
        agi_dm01avso24.liegenschaften_projgrundstueck AS grundstueck
        LEFT JOIN agi_dm01avso24.liegenschaften_projselbstrecht AS selbstrecht 
            ON selbstrecht.projselbstrecht_von = grundstueck.t_id
        LEFT JOIN pos
            ON pos.projgrundstueckpos_von = grundstueck.t_id
        LEFT JOIN agi_dm01avso24.liegenschaften_lsnachfuehrung AS nachfuehrung
            ON grundstueck.entstehung = nachfuehrung.t_id
        LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
            ON grundstueck.t_basket = basket.t_id    
        LEFT JOIN 
aimport
            ON basket.dataset = aimport.dataset    
        
    WHERE 
        selbstrecht.geometrie IS NOT NULL
),
-- grundbuchkreise
grundbuchkreis AS 
(
    SELECT
    kreis.aname AS aname,
    nummerierungsbereich.geometrie
    FROM
    agi_av_gb_administrative_einteilungen_v2.grundbuchkreise_grundbuchkreis AS kreis
    LEFT JOIN agi_av_gb_administrative_einteilungen_v2.grundbuchkreise_grundbuchamt AS amt
    ON kreis.r_grundbuchamt = amt.t_id
    LEFT JOIN 
    (
        SELECT
            nbgeometrie.t_datasetname,
            nbbereich.kt || nbbereich.nbnummer AS nbident,
            ST_Multi(ST_Union(nbgeometrie.geometrie)) AS geometrie
        FROM
            agi_dm01avso24.nummerierngsbrche_nbgeometrie AS nbgeometrie
            LEFT JOIN agi_dm01avso24.nummerierngsbrche_nummerierungsbereich AS nbbereich
            ON nbgeometrie.nbgeometrie_von = nbbereich.t_id
        WHERE
            nbbereich.kt =  'SO'
        GROUP BY
            nbgeometrie.t_datasetname,
            nbbereich.kt,
            nbbereich.nbnummer
    ) AS nummerierungsbereich
    ON CAST(nummerierungsbereich.t_datasetname AS integer) = kreis.bfsnr AND nummerierungsbereich.nbident = kreis.nbident
)
-- Main query
SELECT 
    nbident,
    nummer,
    art_txt,
    flaechenmass,
    egrid,
    bfs_nr,    
    orientierung,
    hali,
    vali,
    importdatum,
    nachfuehrung,
    grundstueck.geometrie,  
    posX,
    posY,  
    gemeinde.aname AS gemeinde,
    grundbuchkreis.aname AS grundbuch,
    ${basket_tid} AS t_basket
FROM 
grundstueck
LEFT JOIN gemeinde 
ON gemeinde.bfsnr = grundstueck.bfs_nr
LEFT JOIN grundbuchkreis 
--ON ST_Intersects(ST_PointOnSurface(ST_Buffer(grundstueck.geometrie,0)), grundbuchkreis.geometrie)
--Aenderung vom 04.12.2019, sc: ST_Buffer ersetzt durch ST_MakeValid (ST_Buffer hat nicht auf allen Liegenschaften den Grundbuchkreis abgefüllt)
ON ST_Intersects(grundstueck.point_on_surface, grundbuchkreis.geometrie)
;
