WITH 

av_grundstuecke AS (
        SELECT 
            g.egris_egrid,
            g.nbident,
            l.geometrie,
            g.nummer,
            g.t_datasetname
   
        FROM 
            agi_dm01avso24.liegenschaften_grundstueck AS g
            LEFT JOIN 
                agi_dm01avso24.liegenschaften_liegenschaft AS l
                    ON l.liegenschaft_von = g.t_id
        WHERE 
            g.art = 'Liegenschaft'
                AND 
                     g.egris_egrid IS NOT NULL
                    
        UNION
        
        SELECT 
            g.egris_egrid,
            g.nbident,
            sdr.geometrie,
            g.nummer,
            g.t_datasetname
   
        FROM 
            agi_dm01avso24.liegenschaften_grundstueck AS g
            LEFT JOIN 
                agi_dm01avso24.liegenschaften_selbstrecht AS sdr
                    ON sdr.selbstrecht_von = g.t_id
        WHERE 
            g.art != 'Liegenschaft'
              AND 
                     g.egris_egrid IS NOT NULL
),

gb_grundstuecke AS (
        SELECT
            gb.egrid,
            gb.grundstueck_nr
        FROM
            agi_av_gb_abgleich_import.gb_daten AS gb
),

-- EGRID in AV und GB vorhanden
identisch AS (
    SELECT
        av.egris_egrid,    
        av.nummer
FROM 
    av_grundstuecke AS av,
    gb_grundstuecke AS gb
WHERE 
    av.egris_egrid = gb.egrid 
        AND
           av.nummer=gb.grundstueck_nr
),

-- EGRID nicht identisch mit GB
nur_gb AS (
    SELECT 
        egris_egrid,
        nummer
    FROM
        av_grundstuecke
    EXCEPT

    SELECT 
        egris_egrid,
        nummer
    FROM
        identisch)


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
        
-- Grundstücke mit falschem Egrid
SELECT 
    ST_CurveToLine(geometrie, 0.002, 1, 1) AS geometrie,
    av.t_datasetname::integer AS av_gem_bfs,
    NULL AS av_nbident,
    NULL AS av_gemeinde,
    NULL AS av_nummer,
    NULL AS av_art,
    NULL AS av_art_txt,
    NULL AS av_flaeche,
    NULL AS av_lieferdatum,
    NULL AS av_mutation_id,
    NULL AS av_mut_beschreibung,
    NULL AS gb_gem_bfs,
    NULL AS gb_kreis_nr,
    NULL AS gb_gemeinde,
    av.nummer as gb_nummer,
    NULL AS gb_art,
    NULL AS gb_flaeche,
    NULL AS gb_fuehrungsart,
    av.nbident as gb_nbident, 
    NULL AS flaechen_differenz, 
    4::integer AS fehlerart --'EGRID stimmen nicht überein'

FROM    
    nur_gb AS gb
    LEFT JOIN 
        av_grundstuecke AS av ON av.egris_egrid = gb.egris_egrid AND  av.nummer=gb.nummer
;
