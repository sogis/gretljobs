SELECT
    einzelobjekt.art,
    split_part(einzelobjekt.art_txt,'.',array_upper(string_to_array(einzelobjekt.art_txt,'.'), 1)) AS art_txt,
    CASE 
        WHEN ori IS NULL 
            THEN 0
        ELSE (100 - punkt.ori) * 0.9
    END AS symbolorientierung,
    einzelobjekt.gem_bfs AS bfs_nr,
    einzelobjekt.lieferdatum AS importdatum,
    to_date(nachfuehrung.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung,
    punkt.geometrie
FROM
    av_avdpool_ng.einzelobjekte_punktelement AS punkt
    LEFT JOIN av_avdpool_ng.einzelobjekte_einzelobjekt AS einzelobjekt
        ON einzelobjekt.tid  = punkt.punktelement_von
    LEFT JOIN av_avdpool_ng.einzelobjekte_eonachfuehrung AS nachfuehrung
        ON nachfuehrung.tid = einzelobjekt.entstehung
;