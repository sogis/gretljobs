SELECT
    t_id,
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
    fehlerart,
    CASE
        WHEN fehlerart = 1
            THEN 'Liegenschaft mit falscher Art' 
        WHEN fehlerart = 2
            THEN 'Grundstücke mit Flächendifferenzen'
        WHEN fehlerart = 3
            THEN 'Grundstück kommt nur in der AV vor'
        WHEN fehlerart = 4
            THEN 'Grundstück kommt nur im Grundbuch vor'
    END AS fehlerart_text
FROM 
    agi_av_gb_abgleich_import.differenzen_staging
;