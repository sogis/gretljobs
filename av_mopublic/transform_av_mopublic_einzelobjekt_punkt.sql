SELECT
    eo.art,
    split_part(eo.art_txt,'.',array_upper(string_to_array(eo.art_txt,'.'), 1)) AS art_txt,
    CASE 
        WHEN ori IS NULL THEN 0
        ELSE (100 - p.ori) * 0.9
    END AS symbolorientierung,
    eo.gem_bfs AS bfs_nr,
    eo.lieferdatum AS importdatum,
    to_date(nf.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung,
    p.geometrie
FROM
    av_avdpool_ng.einzelobjekte_punktelement AS p 
    LEFT JOIN av_avdpool_ng.einzelobjekte_einzelobjekt AS eo
    ON eo.tid  = p.punktelement_von
    LEFT JOIN av_avdpool_ng.einzelobjekte_eonachfuehrung AS nf
    ON nf.tid = eo.entstehung;