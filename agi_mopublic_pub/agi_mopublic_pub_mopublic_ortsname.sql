SELECT
    ortsname."name" AS ortsname,
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
    ortsname.gem_bfs AS bfs_nr,
    ortsname.lieferdatum AS importdatum,
    to_date(nachfuehrung.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung,
    ortsname.geometrie,
    pos.pos
FROM
    av_avdpool_ng.nomenklatur_ortsname AS ortsname 
    LEFT JOIN av_avdpool_ng.nomenklatur_ortsnamepos AS pos
        ON pos.ortsnamepos_von = ortsname.tid
    LEFT JOIN av_avdpool_ng.nomenklatur_nknachfuehrung AS nachfuehrung
        ON ortsname.entstehung = nachfuehrung.tid
;