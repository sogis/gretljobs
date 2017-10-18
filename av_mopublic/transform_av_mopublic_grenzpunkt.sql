SELECT
    g.geometrie,
    g.lagegen AS lagegenauigkeit,
    CASE
        WHEN lagezuv_txt = 'ja' THEN TRUE
        ELSE FALSE
    END AS lagezuverlaessigkeit,
    g.punktzeichen,
    g.punktzeichen_txt,
    CASE 
        WHEN s.ori IS NULL THEN (100 - 0) * 0.9
        ELSE (100 - s.ori) * 0.9
    END AS symbolorientierung,
    g.gem_bfs AS bfs_nr,
    g.lieferdatum AS importdatum,
    to_date(nf.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung
FROM
    av_avdpool_ng.liegenschaften_grenzpunkt AS g 
    LEFT JOIN av_avdpool_ng.liegenschaften_grenzpunktpos AS p 
    ON p.grenzpunktpos_von = g.tid
    LEFT JOIN av_avdpool_ng.liegenschaften_grenzpunktsymbol AS s 
    ON s.grenzpunktsymbol_von = g.tid 
    LEFT JOIN av_avdpool_ng.liegenschaften_lsnachfuehrung AS nf  
    ON g.entstehung = nf.tid;