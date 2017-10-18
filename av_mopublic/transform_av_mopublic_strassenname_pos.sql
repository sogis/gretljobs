SELECT 
    n."text" AS strassenname,
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
    n.gem_bfs AS bfs_nr,
    n.lieferdatum AS importdatum,
    to_date(nf.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung,
    p.pos
FROM
    av_avdpool_ng.gebaeudeadressen_lokalisationsname AS n 
    LEFT JOIN av_avdpool_ng.gebaeudeadressen_lokalisationsnamepos AS p 
    ON p.lokalisationsnamepos_von = n.tid
    LEFT JOIN av_avdpool_ng.gebaeudeadressen_lokalisation AS l 
    ON n.benannte = l.tid
    LEFT JOIN av_avdpool_ng.gebaeudeadressen_gebnachfuehrung AS nf
    ON l.entstehung = nf.tid;