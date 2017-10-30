SELECT 
    hgp.identifikator AS nummer,
    hgp.punktzeichen AS punktzeichen,
    hgp.punktzeichen_txt AS punktzeichen_txt,
    CASE
        WHEN hgp.hoheitsgrenzstein_txt = 'ja' THEN TRUE
        ELSE false
    END AS schoener_stein,
    hgp.lagegen AS lagegenauigkeit,
    CASE
        WHEN hgp.lagezuv_txt = 'ja' THEN TRUE
        ELSE false
    END AS lagezuverlaessigkeit,
    CASE
        WHEN sym.ori IS NULL THEN (100 - 0) * 0.9
        ELSE (100 - sym.ori) * 0.9
    END AS symbolorientierung,
    CASE
        WHEN pos.hali_txt IS NULL THEN 'Left'
        ELSE pos.hali_txt
    END AS hali,
    CASE
        WHEN pos.vali_txt IS NULL THEN 'Bottom'
        ELSE pos.vali_txt
    END AS vali,
    hgp.gem_bfs AS bfs_nr,
    hgp.lieferdatum AS importdatum,
    to_date(nf.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung,
    hgp.geometrie,
    pos.pos
FROM
    av_avdpool_ng.gemeindegrenzen_hoheitsgrenzpunkt AS hgp
    LEFT JOIN av_avdpool_ng.gemeindegrenzen_hoheitsgrenzpunktpos AS pos 
    ON pos.hoheitsgrenzpunktpos_von = hgp.tid
    LEFT JOIN av_avdpool_ng.gemeindegrenzen_hoheitsgrenzpunktsymbol AS sym 
    ON sym.hoheitsgrenzpunktsymbol_von = pos.tid
    LEFT JOIN av_avdpool_ng.gemeindegrenzen_gemnachfuehrung AS nf
    ON hgp.entstehung = nf.tid;