SELECT
    g."name" AS gemeindename,
    g.bfsnr AS bfs_nr,
    g.lieferdatum AS importdatum,
    to_date(nf.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung,
    grenze.geometrie 
FROM
    av_avdpool_ng.gemeindegrenzen_gemeinde AS g  
    RIGHT JOIN av_avdpool_ng.gemeindegrenzen_projgemeindegrenze AS grenze
    ON grenze.projgemeindegrenze_von = g.tid
    LEFT JOIN av_avdpool_ng.gemeindegrenzen_gemnachfuehrung AS nf
    ON nf.tid = grenze.entstehung;