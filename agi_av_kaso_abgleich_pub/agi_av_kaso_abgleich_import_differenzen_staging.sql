DELETE FROM agi_av_kaso_abgleich_import.differenzen_staging
;

WITH 
grundbuchkreise AS (
    SELECT
      kreis.aname AS grundbuch,
      kreis.art AS art,
      kreis.nbident AS nbident,
      kreis.grundbuchkreisnummer AS kreis_nr,
      kreis.grundbuchkreis_bfsnr AS gb_gemnr,
      kreis.bfsnr AS gem_bfs
    FROM
      agi_av_gb_admin_einteilung.grundbuchkreise_grundbuchkreis AS kreis  
),
av_projektierte_grundstuecke AS (
        SELECT
            liegenschaften_lsnachfuehrung.identifikator,
            liegenschaften_lsnachfuehrung.beschreibung,
            liegenschaften_projgrundstueck.nummer,
            liegenschaften_projgrundstueck.nbident
        FROM
            agi_dm01avso24.liegenschaften_projliegenschaft
            LEFT JOIN agi_dm01avso24.liegenschaften_projgrundstueck
                ON liegenschaften_projgrundstueck.t_id = liegenschaften_projliegenschaft.projliegenschaft_von
            LEFT JOIN agi_dm01avso24.liegenschaften_lsnachfuehrung
                ON liegenschaften_lsnachfuehrung.t_id = liegenschaften_projgrundstueck.entstehung
    ),
    av_projektiertes_selbstrecht AS (
        SELECT
            liegenschaften_lsnachfuehrung.identifikator,
            liegenschaften_lsnachfuehrung.beschreibung,
            liegenschaften_projgrundstueck.nummer,
            liegenschaften_projgrundstueck.nbident
        FROM
            agi_dm01avso24.liegenschaften_projselbstrecht
            LEFT JOIN agi_dm01avso24.liegenschaften_projgrundstueck
                ON liegenschaften_projgrundstueck.t_id = liegenschaften_projselbstrecht.projselbstrecht_von
            LEFT JOIN agi_dm01avso24.liegenschaften_lsnachfuehrung
                ON liegenschaften_lsnachfuehrung.t_id = liegenschaften_projgrundstueck.entstehung
    ),
    av_grundstuecke AS (
        SELECT 
            liegenschaften_liegenschaft.t_id, 
            liegenschaften_liegenschaft.geometrie, 
            aimport.importdate AS av_lieferdatum, 
            CAST(SUBSTRING(liegenschaften_grundstueck.t_datasetname,1,4) AS integer) AS av_gem_bfs, 
            liegenschaften_grundstueck.nbident AS av_nbident, 
            REPLACE(REPLACE(liegenschaften_grundstueck.nummer::text, ' LRO'::text, ''::text), ' alt'::text, ''::text)  AS av_nummer, 
            grundstuecksart.itfcode AS av_art, 
            liegenschaften_grundstueck.art AS av_art_txt, 
            liegenschaften_liegenschaft.flaechenmass AS av_flaeche, 
            av_projektierte_grundstuecke.identifikator AS av_mutation_id, 
            av_projektierte_grundstuecke.beschreibung AS av_mut_beschreibung
        FROM 
            agi_dm01avso24.liegenschaften_grundstueck
            LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
                ON liegenschaften_grundstueck.t_basket = basket.t_id
            LEFT JOIN agi_dm01avso24.liegenschaften_grundstuecksart AS grundstuecksart
                ON liegenschaften_grundstueck.art = grundstuecksart.ilicode
            LEFT JOIN 
            (
                SELECT
                    max(importdate) AS importdate,
                    dataset
                FROM
                    agi_dm01avso24.t_ili2db_import
                GROUP BY
                    dataset 
            ) AS  aimport
                 ON basket.dataset = aimport.dataset
            JOIN agi_dm01avso24.liegenschaften_liegenschaft
                ON liegenschaften_liegenschaft.liegenschaft_von::text = liegenschaften_grundstueck.t_id::text
            LEFT JOIN av_projektierte_grundstuecke
                ON 
                    av_projektierte_grundstuecke.nummer::text = REPLACE(REPLACE(liegenschaften_grundstueck.nummer::text, ' LRO'::text, ''::text), ' alt'::text, ''::text) 
                    AND 
                    liegenschaften_grundstueck.nbident::text = av_projektierte_grundstuecke.nbident::text
    
        UNION ALL
    
        SELECT 
            liegenschaften_selbstrecht.t_id, 
            liegenschaften_selbstrecht.geometrie, 
            aimport.importdate AS av_lieferdatum,  
            CAST(SUBSTRING(liegenschaften_grundstueck.t_datasetname,1,4) AS integer) AS av_gem_bfs, 
            liegenschaften_grundstueck.nbident AS av_nbident, 
            REPLACE(REPLACE(liegenschaften_grundstueck.nummer::text, ' LRO'::text, ''::text), ' alt'::text, ''::text)  AS av_nummer, 
            grundstuecksart.itfcode AS av_art, 
            liegenschaften_grundstueck.art AS av_art_txt, 
            liegenschaften_selbstrecht.flaechenmass AS av_flaeche,
            av_projektiertes_selbstrecht.identifikator AS av_mutation_id, 
            av_projektiertes_selbstrecht.beschreibung AS av_mut_beschreibung
        FROM 
            agi_dm01avso24.liegenschaften_grundstueck
            LEFT JOIN agi_dm01avso24.liegenschaften_grundstuecksart AS grundstuecksart
                ON liegenschaften_grundstueck.art = grundstuecksart.ilicode
            LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
                ON liegenschaften_grundstueck.t_basket = basket.t_id
            LEFT JOIN 
            (
                SELECT
                    max(importdate) AS importdate,
                    dataset
                FROM
                    agi_dm01avso24.t_ili2db_import
                GROUP BY
                    dataset 
            ) AS  aimport
                 ON basket.dataset = aimport.dataset
           JOIN agi_dm01avso24.liegenschaften_selbstrecht 
                ON liegenschaften_selbstrecht.selbstrecht_von::text = liegenschaften_grundstueck.t_id::text 
            LEFT JOIN av_projektiertes_selbstrecht
                ON 
                    av_projektiertes_selbstrecht.nummer::text = REPLACE(REPLACE(liegenschaften_grundstueck.nummer::text, ' LRO'::text, ''::text), ' alt'::text, ''::text) 
                    AND 
                    liegenschaften_grundstueck.nbident::text = av_projektiertes_selbstrecht.nbident::text
    ),
    
    kaso AS (
        SELECT
            grundbuchamt.grundbuch AS kaso_gemeinde,
            kaso.geb_bfsnr AS kaso_bfs_nr,
            grundbuchamt.nbident AS kaso_nbident,
            kaso.gb_nr AS kaso_gb_nr,
            kaso.gb_art AS kaso_art,
            kaso.gb_flaeche AS kaso_flaeche,
            kaso.gb_gueltigbis AS kaso_historisiert
        FROM
            agi_av_kaso_abgleich_import.kaso_daten AS kaso
            JOIN grundbuchkreise AS grundbuchamt
                ON grundbuchamt.gb_gemnr = kaso.geb_bfsnr::integer
      )

INSERT INTO agi_av_kaso_abgleich_import.differenzen_staging (
    geometrie,
    av_lieferdatum,
    av_gem_bfs,
    av_nbident,
    av_nummer,
    av_art,
    av_art_txt,
    av_flaeche,
    av_mutation_id,
    av_mut_beschreibung,
    kaso_gemeinde,
    kaso_bfs_nr,
    kaso_nbident,
    kaso_gb_nr,
    kaso_art,
    kaso_flaeche, 
    flaechen_differenz, 
    fehlerart,
    fehlerart_text
)

      
SELECT 
    ST_CurveToLine(geometrie, 0.002, 1, 1) AS geometrie,
    av_lieferdatum,
    av_gem_bfs,
    av_nbident,
    av_nummer,
    av_art,
    av_art_txt,
    av_flaeche,
    av_mutation_id,
    av_mut_beschreibung,
    kaso_gemeinde,
    kaso_bfs_nr,
    kaso_nbident,
    kaso_gb_nr,
    kaso_art,
    kaso_flaeche, 
    av_grundstuecke.av_flaeche - kaso.kaso_flaeche AS flaechen_differenz, 
    1::integer AS fehlerart,
    'Liegenschaft mit falscher Art in KASO' AS fehlerart_text
    
FROM 
    av_grundstuecke
    JOIN kaso
        ON
            kaso.kaso_gb_nr::text =  av_grundstuecke.av_nummer 
            AND 
            kaso.kaso_nbident =  av_grundstuecke.av_nbident
WHERE 
    av_grundstuecke.av_art = 0 -- Liegenschaft
    AND 
    REPLACE( av_grundstuecke.av_nummer::text, '/'::text, '.'::text)::numeric < 90000::numeric -- öffentliche Grundstuecke ausgeschlossen
    AND 
    kaso.kaso_art != '5'
    AND
    kaso.kaso_historisiert IS NULL

UNION ALL  

SELECT 
    ST_CurveToLine(geometrie, 0.002, 1, 1) AS geometrie,
    av_lieferdatum,
    av_gem_bfs,
    av_nbident,
    av_nummer,
    av_art,
    av_art_txt,
    av_flaeche,
    av_mutation_id,
    av_mut_beschreibung,
    kaso_gemeinde,
    kaso_bfs_nr,
    kaso_nbident,
    kaso_gb_nr,
    kaso_art,
    kaso_flaeche,
    av_grundstuecke.av_flaeche - kaso.kaso_flaeche AS flaechen_differenz,
    2::integer AS fehlerart,
    'Gründstücke mit Flächendifferenzen' AS fehlerart_text
FROM 
    av_grundstuecke
    JOIN kaso
        ON 
            kaso.kaso_gb_nr::text = av_grundstuecke.av_nummer 
            AND 
            kaso.kaso_nbident = av_grundstuecke.av_nbident
WHERE 
    av_grundstuecke.av_flaeche - kaso.kaso_flaeche != 0  
    AND
    kaso.kaso_historisiert IS NULL
  
UNION ALL 

SELECT 
    ST_CurveToLine(geometrie, 0.002, 1, 1) AS geometrie,
    av_lieferdatum,
    av_gem_bfs,
    av_nbident,
    av_nummer,
    av_art,
    av_art_txt,
    av_flaeche,
    av_mutation_id,
    av_mut_beschreibung,
    kaso_gemeinde,
    kaso_bfs_nr,
    kaso_nbident,
    kaso_gb_nr,
    kaso_art,
    kaso_flaeche, 
    av_grundstuecke.av_flaeche - kaso.kaso_flaeche AS flaechen_differenz, 
     3::integer AS fehlerart,
     'Gründstück kommt nur in den AV-Daten vor' AS fehlerart_text
FROM 
    av_grundstuecke
    LEFT JOIN kaso
        ON
            kaso.kaso_gb_nr::text = av_grundstuecke.av_nummer 
            AND 
            kaso.kaso_nbident = av_grundstuecke.av_nbident
WHERE 
    kaso.kaso_gb_nr IS NULL
    AND 
    REPLACE(av_grundstuecke.av_nummer::text, '/'::text, '.'::text)::numeric < 90000::numeric
    AND 
    av_grundstuecke.av_nummer NOT LIKE '%.%'
    
UNION ALL

SELECT 
    ST_CurveToLine(geometrie, 0.002, 1, 1) AS geometrie,
    av_lieferdatum,
    av_gem_bfs,
    av_nbident,
    av_nummer,
    av_art,
    av_art_txt,
    av_flaeche,
    av_mutation_id,
    av_mut_beschreibung,
    kaso_gemeinde,
    kaso_bfs_nr,
    kaso_nbident,
    kaso_gb_nr,
    kaso_art,
    kaso_flaeche, 
    av_grundstuecke.av_flaeche - kaso.kaso_flaeche AS flaechen_differenz, 
    4::integer AS fehlerart,
    'Gründstück kommt nur in den KASO-Daten vor' AS fehlerart_text
FROM 
    av_grundstuecke
    RIGHT JOIN kaso
        ON
            kaso.kaso_gb_nr::text = av_grundstuecke.av_nummer
            AND
            kaso.kaso_nbident = av_grundstuecke.av_nbident
WHERE 
    av_grundstuecke.t_id IS NULL
    AND
    kaso.kaso_art = '5'
    AND
    kaso.kaso_historisiert IS NULL
    AND 
    kaso.kaso_flaeche IS NOT NULL
;
