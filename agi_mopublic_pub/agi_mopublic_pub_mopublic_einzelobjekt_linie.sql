SELECT
    einzelobjekt.art,
    split_part(einzelobjekt.art_txt,'.',array_upper(string_to_array(einzelobjekt.art_txt,'.'), 1)) AS art_txt,
    einzelobjekt.gem_bfs AS bfs_nr,
    einzelobjekt.lieferdatum AS importdatum,
    to_date(nachfuehrung.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung,
    linie.geometrie
FROM
    av_avdpool_ng.einzelobjekte_linienelement AS linie 
    LEFT JOIN av_avdpool_ng.einzelobjekte_einzelobjekt AS einzelobjekt
        ON einzelobjekt.tid  = linie.linienelement_von
    LEFT JOIN av_avdpool_ng.einzelobjekte_eonachfuehrung AS nachfuehrung
        ON nachfuehrung.tid = einzelobjekt.entstehung
;