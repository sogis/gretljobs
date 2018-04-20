SELECT
    objekt.art,
    objekt.art_txt,
    objekt.betreiber,
    objekt.gem_bfs AS bfs_nr,
    objekt.lieferdatum AS importdatum,
    to_date(nachfuehrung.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung,
    linie.geometrie 
FROM
    av_avdpool_ng.rohrleitungen_linienelement AS linie  
    LEFT JOIN av_avdpool_ng.rohrleitungen_leitungsobjekt AS objekt 
        ON linie.linienelement_von = objekt.tid
    LEFT JOIN av_avdpool_ng.rohrleitungen_rlnachfuehrung AS nachfuehrung
        ON objekt.entstehung = nachfuehrung.tid
;