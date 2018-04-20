SELECT
    bodenbedeckung.art,
    CASE 
        WHEN split_part(bodenbedeckung.art_txt,'.', array_upper(string_to_array(bodenbedeckung.art_txt, '.'), 1))='fliessendes' 
            THEN 'fliessendes Gewaesser'
        WHEN split_part(bodenbedeckung.art_txt,'.', array_upper(string_to_array(bodenbedeckung.art_txt, '.'), 1))='stehendes' 
            THEN 'stehendes Gewaesser'
        ELSE split_part(bodenbedeckung.art_txt,'.', array_upper(string_to_array(bodenbedeckung.art_txt, '.'), 1))
    END AS art_txt,
    bodenbedeckung.gem_bfs AS bfs_nr,
    gebaeudenummer.gwr_egid AS egid,
    bodenbedeckung.lieferdatum AS importdatum,
    to_date(nachfuehrung.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung,
    bodenbedeckung.geometrie
FROM
    av_avdpool_ng.bodenbedeckung_projboflaeche AS bodenbedeckung
    LEFT JOIN av_avdpool_ng.bodenbedeckung_projgebaeudenummer AS gebaeudenummer
        ON gebaeudenummer.projgebaeudenummer_von = bodenbedeckung.tid
    LEFT JOIN av_avdpool_ng.bodenbedeckung_bbnachfuehrung AS nachfuehrung
        ON bodenbedeckung.entstehung = nachfuehrung.tid
; 