SELECT
    grenzpunkt.geometrie,
    grenzpunkt.lagegen AS lagegenauigkeit,
    CASE
        WHEN lagezuv_txt = 'ja' 
            THEN TRUE
        ELSE FALSE
    END AS lagezuverlaessigkeit,
    grenzpunkt.punktzeichen,
    grenzpunkt.punktzeichen_txt,
    CASE 
        WHEN symbol.ori IS NULL 
            THEN (100 - 0) * 0.9
        ELSE (100 - symbol.ori) * 0.9
    END AS symbolorientierung,
    grenzpunkt.gem_bfs AS bfs_nr,
    grenzpunkt.lieferdatum AS importdatum,
    to_date(nachfuehrung.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung,
    nachfuehrung.gueltigkeit_txt AS gueltigkeit
FROM
    av_avdpool_ng.liegenschaften_grenzpunkt AS grenzpunkt 
    LEFT JOIN av_avdpool_ng.liegenschaften_grenzpunktpos AS pos 
        ON pos.grenzpunktpos_von = grenzpunkt.tid
    LEFT JOIN av_avdpool_ng.liegenschaften_grenzpunktsymbol AS symbol 
        ON symbol.grenzpunktsymbol_von = grenzpunkt.tid 
    LEFT JOIN av_avdpool_ng.liegenschaften_lsnachfuehrung AS nachfuehrung  
        ON grenzpunkt.entstehung = nachfuehrung.tid
;