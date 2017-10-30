WITH pos AS 
(
    SELECT
        DISTINCT ON (flurnamepos_von)
        flurnamepos_von,
        hali_txt,
        vali_txt,
        ori,
        pos 
    FROM
       av_avdpool_ng.nomenklatur_flurnamepos 
)
SELECT
    f."name" AS flurname,
    f.gem_bfs AS bfs_nr,
    CASE
        WHEN pos.ori IS NULL THEN (100 - 100) * 0.9
        ELSE (100 - pos.ori) * 0.9 
    END AS orientierung,
    CASE 
        WHEN pos.hali_txt IS NULL THEN 'Center'
        ELSE pos.hali_txt
    END AS hali,
    CASE 
        WHEN pos.vali_txt IS NULL THEN 'Half'
        ELSE pos.vali_txt
    END AS vali,
    nf.lieferdatum AS importdatum,
    f.geometrie,
    pos.pos
FROM
    pos 
    LEFT JOIN av_avdpool_ng.nomenklatur_flurname AS f
    ON pos.flurnamepos_von = f.tid
    LEFT JOIN av_avdpool_ng.nomenklatur_nknachfuehrung AS nf
    ON f.entstehung = nf.tid;