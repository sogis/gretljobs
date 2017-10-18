SELECT
    bb.art,
    CASE 
        WHEN split_part(bb.art_txt,'.', array_upper(string_to_array(bb.art_txt, '.'), 1))='fliessendes' THEN 'fliessendes Gewaesser'
        WHEN split_part(bb.art_txt,'.', array_upper(string_to_array(bb.art_txt, '.'), 1))='stehendes' THEN 'stehendes Gewaesser'
        ELSE split_part(bb.art_txt,'.', array_upper(string_to_array(bb.art_txt, '.'), 1))
    END AS art_txt,
    bb.gem_bfs AS bfs_nr,
    gebnr.gwr_egid AS egid,
    bb.lieferdatum AS importdatum,
    to_date(nf.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung,
    bb.geometrie
FROM
    av_avdpool_ng.bodenbedeckung_projboflaeche AS bb
    LEFT JOIN av_avdpool_ng.bodenbedeckung_projgebaeudenummer AS gebnr
    ON gebnr.projgebaeudenummer_von = bb.tid
    LEFT JOIN av_avdpool_ng.bodenbedeckung_bbnachfuehrung AS nf
    ON bb.entstehung = nf.tid; 