DELETE FROM agi_av_gb_abgleich_import.gb_daten
;

WITH 
    projektierte_liegenschaften_selbstrecht AS (
        SELECT
            liegenschaften_lsnachfuehrung.identifikator,
            liegenschaften_lsnachfuehrung.beschreibung,
            liegenschaften_projgrundstueck.nummer,
            liegenschaften_projgrundstueck.nbident
        FROM
            av_avdpool_ng.liegenschaften_projgrundstueck
            LEFT JOIN av_avdpool_ng.liegenschaften_lsnachfuehrung
                ON liegenschaften_lsnachfuehrung.tid = liegenschaften_projgrundstueck.entstehung
    ),
    av_grundstuecke AS (
        SELECT 
            liegenschaften_liegenschaft.geometrie, 
            liegenschaften_grundstueck.gem_bfs AS av_gem_bfs, 
            liegenschaften_grundstueck.nbident AS av_nbident, 
            grundbuchkreise.gemeinde AS av_gemeinde, 
            liegenschaften_grundstueck.nummer::text AS av_nummer, 
            liegenschaften_grundstueck.art AS av_art, 
            liegenschaften_grundstueck.art_txt AS av_art_txt, 
            liegenschaften_liegenschaft.flaechenmass AS av_flaeche, 
            liegenschaften_grundstueck.lieferdatum AS av_lieferdatum,
            projektierte_liegenschaften_selbstrecht.identifikator AS av_mutation_id, 
            projektierte_liegenschaften_selbstrecht.beschreibung AS av_mut_beschreibung       
        FROM 
            av_avdpool_ng.liegenschaften_grundstueck
            JOIN av_avdpool_ng.liegenschaften_liegenschaft
                ON liegenschaften_liegenschaft.liegenschaft_von::text = liegenschaften_grundstueck.tid::text
            LEFT JOIN projektierte_liegenschaften_selbstrecht
                ON 
                    projektierte_liegenschaften_selbstrecht.nummer::text = liegenschaften_grundstueck.nummer::text
                    AND 
                    liegenschaften_grundstueck.nbident::text = projektierte_liegenschaften_selbstrecht.nbident::text
            LEFT JOIN av_grundbuch.grundbuchkreise
                ON liegenschaften_grundstueck.nbident = grundbuchkreise.nbident
          
        UNION ALL 
    
        SELECT 
            liegenschaften_selbstrecht.geometrie, 
            liegenschaften_grundstueck.gem_bfs AS av_gem_bfs, 
            liegenschaften_grundstueck.nbident AS av_nbident, 
            grundbuchkreise.gemeinde AS av_gemeinde, 
            liegenschaften_grundstueck.nummer::text AS av_nummer, 
            liegenschaften_grundstueck.art AS av_art, 
            liegenschaften_grundstueck.art_txt AS av_art_txt, 
            liegenschaften_selbstrecht.flaechenmass AS av_flaeche,
            liegenschaften_grundstueck.lieferdatum AS av_lieferdatum,  
            projektierte_liegenschaften_selbstrecht.identifikator AS av_mutation_id, 
            projektierte_liegenschaften_selbstrecht.beschreibung AS av_mut_beschreibung 
        FROM 
            av_avdpool_ng.liegenschaften_grundstueck
            JOIN av_avdpool_ng.liegenschaften_selbstrecht
                ON liegenschaften_selbstrecht.selbstrecht_von::text = liegenschaften_grundstueck.tid::text 
            LEFT JOIN projektierte_liegenschaften_selbstrecht
                ON 
                    projektierte_liegenschaften_selbstrecht.nummer::text = liegenschaften_grundstueck.nummer::text
                    AND 
                    liegenschaften_grundstueck.nbident::text = projektierte_liegenschaften_selbstrecht.nbident::text
            LEFT JOIN av_grundbuch.grundbuchkreise
                ON liegenschaften_grundstueck.nbident = grundbuchkreise.nbident
                 
    ),
    gb_grundstuecke AS (
        SELECT
            gb_daten.bfs_nr AS gb_gem_bfs,
            gb_daten.kreis_nr AS gb_kreis_nr,
            grundbuchkreise.grundbuch AS gb_gemeinde,
            gb_daten.grundstueck_nr AS gb_nummer,
            gb_daten.grundstueckart AS gb_art,
            gb_daten.flaeche AS gb_flaeche,
            gb_daten.fuehrungsart AS gb_fuehrungsart,
            grundbuchkreise.nbident AS gb_nbident
        FROM
            agi_av_gb_abgleich_import.gb_daten 
            JOIN av_grundbuch.grundbuchkreise
                ON 
                    grundbuchkreise.gem_bfs = gb_daten.bfs_nr 
                    AND 
                    (
                        CASE 
                            WHEN grundbuchkreise.kreis_nr IS NULL
                                THEN gb_daten.kreis_nr IS NULL
                            ELSE grundbuchkreise.kreis_nr = gb_daten.kreis_nr
                        END
                    )    
    )

INSERT INTO agi_av_gb_abgleich_import.differenzen_staging (
    geometrie,
    av_gem_bfs,
    av_nbident,
    av_gemeinde,
    av_nummer,
    av_art,
    av_art_txt,
    av_flaeche,
    av_lieferdatum,
    av_mutation_id,
    av_mut_beschreibung,
    gb_gem_bfs,
    gb_kreis_nr,
    gb_gemeinde,
    gb_nummer,
    gb_art,
    gb_flaeche,
    gb_fuehrungsart,
    gb_nbident,
    flaechen_differenz,
    fehlerart
)
    
SELECT
    geometrie,
    av_gem_bfs,
    av_nbident,
    av_gemeinde,
    av_nummer,
    av_art,
    av_art_txt,
    av_flaeche,
    av_lieferdatum,
    av_mutation_id,
    av_mut_beschreibung,
    gb_gem_bfs,
    gb_kreis_nr,
    gb_gemeinde,
    gb_nummer,
    gb_art,
    gb_flaeche,
    gb_fuehrungsart,
    gb_nbident, 
    av_grundstuecke.av_flaeche - gb_grundstuecke.gb_flaeche AS flaechen_differenz, 
    1::integer AS fehlerart -- 'Liegenschaft mit falscher Art' 
FROM 
    av_grundstuecke
    JOIN gb_grundstuecke
        ON
            gb_grundstuecke.gb_nummer =  av_grundstuecke.av_nummer 
            AND 
            gb_grundstuecke.gb_nbident =  av_grundstuecke.av_nbident
WHERE 
    av_grundstuecke.av_art = 0 -- Liegenschaft
    AND 
    gb_grundstuecke.gb_art != 'Liegenschaft'
  
UNION ALL 

SELECT 
    geometrie,
    av_gem_bfs,
    av_nbident,
    av_gemeinde,
    av_nummer,
    av_art,
    av_art_txt,
    av_flaeche,
    av_lieferdatum,
    av_mutation_id,
    av_mut_beschreibung,
    gb_gem_bfs,
    gb_kreis_nr,
    gb_gemeinde,
    gb_nummer,
    gb_art,
    gb_flaeche,
    gb_fuehrungsart,
    gb_nbident,  
    av_grundstuecke.av_flaeche - gb_grundstuecke.gb_flaeche AS flaechen_differenz, 
    2::integer AS fehlerart --'Grundstücke mit Flächendifferenzen'
FROM 
    av_grundstuecke
    JOIN gb_grundstuecke
        ON 
            gb_grundstuecke.gb_nummer = av_grundstuecke.av_nummer 
            AND 
            gb_grundstuecke.gb_nbident = av_grundstuecke.av_nbident
WHERE 
    av_grundstuecke.av_flaeche - gb_grundstuecke.gb_flaeche != 0  
  
UNION ALL 

SELECT
    geometrie,
    av_gem_bfs,
    av_nbident,
    av_gemeinde,
    av_nummer,
    av_art,
    av_art_txt,
    av_flaeche,
    av_lieferdatum,
    av_mutation_id,
    av_mut_beschreibung,
    gb_gem_bfs,
    gb_kreis_nr,
    gb_gemeinde,
    gb_nummer,
    gb_art,
    gb_flaeche,
    gb_fuehrungsart,
    gb_nbident, 
    av_grundstuecke.av_flaeche - gb_grundstuecke.gb_flaeche AS flaechen_differenz, 
    3::integer AS fehlerart --'Grundstück kommt nur in den AV-Daten vor'
FROM 
    av_grundstuecke
    LEFT JOIN gb_grundstuecke
        ON
            gb_grundstuecke.gb_nummer = av_grundstuecke.av_nummer 
            AND 
            gb_grundstuecke.gb_nbident = av_grundstuecke.av_nbident
WHERE 
    gb_grundstuecke.gb_nummer IS NULL
  
UNION ALL 

SELECT 
    geometrie,
    av_gem_bfs,
    av_nbident,
    av_gemeinde,
    av_nummer,
    av_art,
    av_art_txt,
    av_flaeche,
    av_lieferdatum,
    av_mutation_id,
    av_mut_beschreibung,
    gb_gem_bfs,
    gb_kreis_nr,
    gb_gemeinde,
    gb_nummer,
    gb_art,
    gb_flaeche,
    gb_fuehrungsart,
    gb_nbident, 
    av_grundstuecke.av_flaeche - gb_grundstuecke.gb_flaeche AS flaechen_differenz, 
    4::integer AS fehlerart --'Grundstück kommt nur in den Grundbuch-Daten vor'
FROM 
    av_grundstuecke
    RIGHT JOIN gb_grundstuecke
        ON
            gb_grundstuecke.gb_nummer = av_grundstuecke.av_nummer
            AND
            gb_grundstuecke.gb_nbident = av_grundstuecke.av_nbident
WHERE 
    av_grundstuecke.av_nummer IS NULL
;