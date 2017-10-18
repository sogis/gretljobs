SELECT
    o.art,
    o.art_txt,
    o.betreiber,
    o.gem_bfs AS bfs_nr,
    o.lieferdatum AS importdatum,
    to_date(nf.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung,
    l.geometrie 
FROM
    av_avdpool_ng.rohrleitungen_linienelement AS l  
    LEFT JOIN av_avdpool_ng.rohrleitungen_leitungsobjekt AS o  
    ON l.linienelement_von = o.tid
    LEFT JOIN av_avdpool_ng.rohrleitungen_rlnachfuehrung AS nf
    ON o.entstehung = nf.tid;