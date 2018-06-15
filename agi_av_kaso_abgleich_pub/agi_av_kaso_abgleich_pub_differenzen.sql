WITH 
    av_projektierte_grundstuecke AS (
        SELECT
            liegenschaften_lsnachfuehrung.identifikator,
            liegenschaften_lsnachfuehrung.beschreibung,
            liegenschaften_projgrundstueck.nummer,
            liegenschaften_projgrundstueck.nbident
        FROM
            av_avdpool_ng.liegenschaften_projliegenschaft
            LEFT JOIN av_avdpool_ng.liegenschaften_projgrundstueck
                ON liegenschaften_projgrundstueck.tid = liegenschaften_projliegenschaft.projliegenschaft_von
            LEFT JOIN av_avdpool_ng.liegenschaften_lsnachfuehrung
                ON liegenschaften_lsnachfuehrung.tid = liegenschaften_projgrundstueck.entstehung
    ),
    av_projektiertes_selbstrecht AS (
        SELECT
            liegenschaften_lsnachfuehrung.identifikator,
            liegenschaften_lsnachfuehrung.beschreibung,
            liegenschaften_projgrundstueck.nummer,
            liegenschaften_projgrundstueck.nbident
        FROM
            av_avdpool_ng.liegenschaften_projselbstrecht
            LEFT JOIN av_avdpool_ng.liegenschaften_projgrundstueck
                ON liegenschaften_projgrundstueck.tid = liegenschaften_projselbstrecht.projselbstrecht_von
            LEFT JOIN av_avdpool_ng.liegenschaften_lsnachfuehrung
                ON liegenschaften_lsnachfuehrung.tid = liegenschaften_projgrundstueck.entstehung
    ),
    av_grundstuecke AS (
        SELECT 
            liegenschaften_liegenschaft.ogc_fid, 
            liegenschaften_liegenschaft.geometrie, 
            liegenschaften_grundstueck.lieferdatum AS av_lieferdatum, 
            liegenschaften_grundstueck.gem_bfs AS av_gem_bfs, 
            liegenschaften_grundstueck.nbident AS av_nbident, 
            REPLACE(REPLACE(liegenschaften_grundstueck.nummer::text, ' LRO'::text, ''::text), ' alt'::text, ''::text)  AS av_nummer, 
            liegenschaften_grundstueck.art AS av_art, 
            liegenschaften_grundstueck.art_txt AS av_art_txt, 
            liegenschaften_liegenschaft.flaechenmass AS av_flaeche, 
            av_projektierte_grundstuecke.identifikator AS av_mutation_id, 
            av_projektierte_grundstuecke.beschreibung AS av_mut_beschreibung
        FROM 
            av_avdpool_ng.liegenschaften_grundstueck
            JOIN av_avdpool_ng.liegenschaften_liegenschaft
                ON liegenschaften_liegenschaft.liegenschaft_von::text = liegenschaften_grundstueck.tid::text
            LEFT JOIN av_projektierte_grundstuecke
                ON 
                    av_projektierte_grundstuecke.nummer::text = REPLACE(REPLACE(liegenschaften_grundstueck.nummer::text, ' LRO'::text, ''::text), ' alt'::text, ''::text) 
                    AND 
                    liegenschaften_grundstueck.nbident::text = av_projektierte_grundstuecke.nbident::text
    
        UNION ALL
    
        SELECT 
            liegenschaften_selbstrecht.ogc_fid, 
            liegenschaften_selbstrecht.geometrie, 
            liegenschaften_grundstueck.lieferdatum AS av_lieferdatum,  
            liegenschaften_grundstueck.gem_bfs AS av_gem_bfs, 
            liegenschaften_grundstueck.nbident AS av_nbident, 
            REPLACE(REPLACE(liegenschaften_grundstueck.nummer::text, ' LRO'::text, ''::text), ' alt'::text, ''::text)  AS av_nummer, 
            liegenschaften_grundstueck.art AS av_art, 
            liegenschaften_grundstueck.art_txt AS av_art_txt, 
            liegenschaften_selbstrecht.flaechenmass AS av_flaeche,
            av_projektiertes_selbstrecht.identifikator AS av_mutation_id, 
            av_projektiertes_selbstrecht.beschreibung AS av_mut_beschreibung
        FROM 
            av_avdpool_ng.liegenschaften_grundstueck
            JOIN av_avdpool_ng.liegenschaften_selbstrecht 
                ON liegenschaften_selbstrecht.selbstrecht_von::text = liegenschaften_grundstueck.tid::text 
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
            agi_av_kaso_abgleich.kaso_daten kaso
            JOIN av_grundbuch.grundbuchkreise grundbuchamt
                ON grundbuchamt.gb_gemnr = kaso.geb_bfsnr::integer
      )
      
SELECT 
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
    av_grundstuecke.ogc_fid IS NULL
    AND
    kaso.kaso_art = '5'
    AND
    kaso.kaso_historisiert IS NULL
;

