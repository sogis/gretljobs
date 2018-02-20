SELECT 
    hoheitsgrenzpunkt.identifikator AS nummer,
    hoheitsgrenzpunkt.punktzeichen AS punktzeichen,
    hoheitsgrenzpunkt.punktzeichen_txt AS punktzeichen_txt,
    CASE
        WHEN hoheitsgrenzpunkt.hoheitsgrenzstein_txt = 'ja' 
            THEN TRUE
        ELSE false
    END AS schoener_stein,
    hoheitsgrenzpunkt.lagegen AS lagegenauigkeit,
    CASE
        WHEN hoheitsgrenzpunkt.lagezuv_txt = 'ja' 
            THEN TRUE
        ELSE false
    END AS lagezuverlaessigkeit,
    CASE
        WHEN symbol.ori IS NULL 
            THEN (100 - 0) * 0.9
        ELSE (100 - symbol.ori) * 0.9
    END AS symbolorientierung,
    CASE
        WHEN pos.hali_txt IS NULL 
            THEN 'Left'
        ELSE pos.hali_txt
    END AS hali,
    CASE
        WHEN pos.vali_txt IS NULL 
            THEN 'Bottom'
        ELSE pos.vali_txt
    END AS vali,
    hoheitsgrenzpunkt.gem_bfs AS bfs_nr,
    hoheitsgrenzpunkt.lieferdatum AS importdatum,
    to_date(nachfuehrung.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung,
    hoheitsgrenzpunkt.geometrie,
    pos.pos
FROM
    av_avdpool_ng.gemeindegrenzen_hoheitsgrenzpunkt AS hoheitsgrenzpunkt
    LEFT JOIN av_avdpool_ng.gemeindegrenzen_hoheitsgrenzpunktpos AS pos 
        ON pos.hoheitsgrenzpunktpos_von = hoheitsgrenzpunkt.tid
    LEFT JOIN av_avdpool_ng.gemeindegrenzen_hoheitsgrenzpunktsymbol AS symbol 
        ON symbol.hoheitsgrenzpunktsymbol_von = pos.tid
    LEFT JOIN av_avdpool_ng.gemeindegrenzen_gemnachfuehrung AS nachfuehrung
        ON hoheitsgrenzpunkt.entstehung = nachfuehrung.tid
;