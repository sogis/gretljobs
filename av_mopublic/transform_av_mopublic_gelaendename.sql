SELECT
    g."name" AS gelaendename,
    g.gem_bfs AS bfs_nr,
    g.lieferdatum AS importdatum,
    to_date(nf.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung,
    CASE
        WHEN p.ori IS NULL THEN (100 - 100) * 0.9
        ELSE (100 - p.ori) * 0.9 
    END AS orientierung,
    CASE 
        WHEN p.hali_txt IS NULL THEN 'Center'
        ELSE p.hali_txt
    END AS hali,
    CASE 
        WHEN p.vali_txt IS NULL THEN 'Half'
        ELSE p.vali_txt
    END AS vali,
    p.pos
FROM
    av_avdpool_ng.nomenklatur_gelaendename AS g  
    LEFT JOIN av_avdpool_ng.nomenklatur_gelaendenamepos AS p  
    ON p.gelaendenamepos_von = g.tid
    LEFT JOIN av_avdpool_ng.nomenklatur_nknachfuehrung AS nf 
    ON g.entstehung = nf.tid;