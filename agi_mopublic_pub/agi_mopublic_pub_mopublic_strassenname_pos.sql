SELECT 
    name."text" AS strassenname,
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
    name.gem_bfs AS bfs_nr,
    name.lieferdatum AS importdatum,
    to_date(nachfuehrung.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung,
    pos.pos
FROM
    av_avdpool_ng.gebaeudeadressen_lokalisationsname AS name 
    LEFT JOIN av_avdpool_ng.gebaeudeadressen_lokalisationsnamepos AS pos 
        ON pos.lokalisationsnamepos_von = name.tid
    LEFT JOIN av_avdpool_ng.gebaeudeadressen_lokalisation AS lokalisation
        ON name.benannte = lokalisation.tid
    LEFT JOIN av_avdpool_ng.gebaeudeadressen_gebnachfuehrung AS nachfuehrung
        ON lokalisation.entstehung = nachfuehrung.tid
;