SELECT
    eo.art,
    split_part(eo.art_txt,'.',array_upper(string_to_array(eo.art_txt,'.'), 1)) AS art_txt,
    eo.gem_bfs AS bfs_nr,
    eo.lieferdatum AS importdatum,
    to_date(nf.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung,
    l.geometrie
FROM
    av_avdpool_ng.einzelobjekte_linienelement AS l 
    LEFT JOIN av_avdpool_ng.einzelobjekte_einzelobjekt AS eo
    ON eo.tid  = l.linienelement_von
    LEFT JOIN av_avdpool_ng.einzelobjekte_eonachfuehrung AS nf
    ON nf.tid = eo.entstehung;