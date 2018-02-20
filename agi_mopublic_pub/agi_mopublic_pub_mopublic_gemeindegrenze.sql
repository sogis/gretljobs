SELECT
    gemeinde."name" AS gemeindename,
    gemeinde.bfsnr AS bfs_nr,
    gemeinde.lieferdatum AS importdatum,
    to_date(nachfuehrung.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung,
    grenze.geometrie 
FROM
    av_avdpool_ng.gemeindegrenzen_gemeinde AS gemeinde  
    RIGHT JOIN av_avdpool_ng.gemeindegrenzen_gemeindegrenze AS grenze
        ON grenze.gemeindegrenze_von = gemeinde.tid
    LEFT JOIN av_avdpool_ng.gemeindegrenzen_gemnachfuehrung AS nachfuehrung
        ON nachfuehrung.tid = grenze.entstehung
;