SELECT
    o."name" AS ortsname,
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
    o.gem_bfs AS bfs_nr,
    o.lieferdatum AS importdatum,
    to_date(nf.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung,
    o.geometrie,
    p.pos
FROM
    av_avdpool_ng.nomenklatur_ortsname AS o 
    LEFT JOIN av_avdpool_ng.nomenklatur_ortsnamepos AS p
    ON p.ortsnamepos_von = o.tid
    LEFT JOIN av_avdpool_ng.nomenklatur_nknachfuehrung AS nf
    ON o.entstehung = nf.tid;