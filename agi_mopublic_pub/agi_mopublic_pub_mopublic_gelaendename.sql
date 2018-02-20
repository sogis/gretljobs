SELECT
    gelaendename."name" AS gelaendename,
    gelaendename.gem_bfs AS bfs_nr,
    gelaendename.lieferdatum AS importdatum,
    to_date(nachfuehrung.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung,
    CASE
        WHEN pos.ori IS NULL 
            THEN (100 - 100) * 0.9
        ELSE (100 - pos.ori) * 0.9 
    END AS orientierung,
    CASE 
        WHEN pos.hali_txt IS NULL 
            THEN 'Center'
        ELSE pos.hali_txt
    END AS hali,
    CASE 
        WHEN pos.vali_txt IS NULL 
            THEN 'Half'
        ELSE pos.vali_txt
    END AS vali,
    pos.pos
FROM
    av_avdpool_ng.nomenklatur_gelaendename AS gelaendename  
    LEFT JOIN av_avdpool_ng.nomenklatur_gelaendenamepos AS pos  
        ON pos.gelaendenamepos_von = gelaendename.tid
    LEFT JOIN av_avdpool_ng.nomenklatur_nknachfuehrung AS nachfuehrung 
        ON gelaendename.entstehung = nachfuehrung.tid
;