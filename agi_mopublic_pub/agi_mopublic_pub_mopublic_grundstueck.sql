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
        DISTINCT ON (grundstueckpos_von)
        grundstueckpos_von,
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
        pos
    FROM 
        agi_dm01avso24.liegenschaften_grundstueckpos
)
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
    foo.geometrie,  
    pos,  
    gemeinde.aname AS gemeinde,
    grundbuchkreis.aname AS grundbuch
FROM 
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
        ST_CurveToLine(liegenschaft.geometrie, 0.002, 1, 1) AS geometrie,    
        pos.pos
    FROM
        agi_dm01avso24.liegenschaften_grundstueck AS grundstueck
        LEFT JOIN agi_dm01avso24.liegenschaften_liegenschaft AS liegenschaft
            ON liegenschaft.liegenschaft_von = grundstueck.t_id
        LEFT JOIN pos
            ON pos.grundstueckpos_von = grundstueck.t_id
        LEFT JOIN agi_dm01avso24.liegenschaften_lsnachfuehrung AS nachfuehrung
            ON grundstueck.entstehung = nachfuehrung.t_id
        LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
            ON grundstueck.t_basket = basket.t_id    
        LEFT JOIN 
        (
            SELECT
                max(importdate) AS importdate, dataset
            FROM
                agi_dm01avso24.t_ili2db_import
            GROUP BY
                dataset 
        ) AS aimport
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
        ST_CurveToLine(selbstrecht.geometrie, 0.002, 1, 1) AS geometrie,    
        pos.pos
    FROM
        agi_dm01avso24.liegenschaften_grundstueck AS grundstueck
        LEFT JOIN agi_dm01avso24.liegenschaften_selbstrecht AS selbstrecht 
            ON selbstrecht.selbstrecht_von = grundstueck.t_id
        LEFT JOIN pos
            ON pos.grundstueckpos_von = grundstueck.t_id
        LEFT JOIN agi_dm01avso24.liegenschaften_lsnachfuehrung AS nachfuehrung
            ON grundstueck.entstehung = nachfuehrung.t_id
        LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
            ON grundstueck.t_basket = basket.t_id    
        LEFT JOIN 
        (
            SELECT
                max(importdate) AS importdate, dataset
            FROM
                agi_dm01avso24.t_ili2db_import
            GROUP BY
                dataset 
        ) AS aimport
            ON basket.dataset = aimport.dataset    
        
    WHERE 
        selbstrecht.geometrie IS NOT NULL
) AS foo
LEFT JOIN gemeinde 
ON gemeinde.bfsnr = foo.bfs_nr
LEFT JOIN 
(
    SELECT
      kreis.aname AS aname,
      nummerierungsbereich.geometrie
    FROM
      agi_av_gb_admin_einteilung.grundbuchkreise_grundbuchkreis AS kreis
      LEFT JOIN agi_av_gb_admin_einteilung.grundbuchkreise_grundbuchamt AS amt
      ON kreis.r_grundbuchamt = amt.t_id
      LEFT JOIN 
      (
          SELECT
            nbgeometrie.t_datasetname,
            nbbereich.kt || nbbereich.nbnummer AS nbident,
            ST_Multi(ST_Union(ST_CurveToLine(nbgeometrie.geometrie, 0.002, 1, 1))) AS geometrie
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
) AS grundbuchkreis 
--ON ST_Intersects(ST_PointOnSurface(ST_Buffer(foo.geometrie,0)), grundbuchkreis.geometrie)
ON ST_Intersects(ST_PointOnSurface(st_makevalid(foo.geometrie)), grundbuchkreis.geometrie)
;
