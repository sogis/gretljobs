SELECT
    eo.art,
    split_part(eo.art_txt,'.',array_upper(string_to_array(eo.art_txt,'.'), 1)) AS art_txt,
    eo.gem_bfs AS bfs_nr,
    o.gwr_egid AS egid,
    eo.lieferdatum AS importdatum,
    to_date(nf.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung,
    f.geometrie
FROM
    av_avdpool_ng.einzelobjekte_flaechenelement AS f 
    LEFT JOIN av_avdpool_ng.einzelobjekte_einzelobjekt AS eo
    ON eo.tid  = f.flaechenelement_von
    LEFT JOIN av_avdpool_ng.einzelobjekte_objektnummer AS o
    ON eo.tid = o.objektnummer_von
    LEFT JOIN av_avdpool_ng.einzelobjekte_eonachfuehrung AS nf
    ON nf.tid = eo.entstehung;