WITH pos AS
(
    SELECT
        -- one pos per parcel
        DISTINCT ON (grundstueckpos_von)
        grundstueckpos_von,
        CASE 
            WHEN ori IS NULL THEN (100 - 100) * 0.9
            ELSE (100 - ori) * 0.9
        END AS orientierung,
        CASE 
            WHEN hali_txt IS NULL THEN 'Center'
            ELSE hali_txt
        END AS hali,
        CASE 
            WHEN vali_txt IS NULL THEN 'Half'
            ELSE vali_txt
        END AS vali,
        pos
    FROM 
        av_avdpool_ng.liegenschaften_grundstueckpos
)
SELECT
    g.nbident,
    g.nummer,
    g.art,
    g.art_txt,
    l.flaechenmass,
    g.egris_egrid AS egrid,
    g.gem_bfs AS bfs_nr,
    orientierung,
    p.hali,
    p.vali,
    g.lieferdatum AS importdatum,
    to_date(nf.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung,
    l.geometrie,
    p.pos
FROM
    av_avdpool_ng.liegenschaften_grundstueck AS g
    LEFT JOIN av_avdpool_ng.liegenschaften_liegenschaft AS l 
    ON l.liegenschaft_von = g.tid
    LEFT JOIN pos AS p
    ON p.grundstueckpos_von = g.tid
    LEFT JOIN av_avdpool_ng.liegenschaften_lsnachfuehrung AS nf
    ON g.entstehung = nf.tid
WHERE 
    l.geometrie IS NOT NULL

UNION ALL

SELECT
    g.nbident,
    g.nummer,
    g.art,
    g.art_txt,
    s.flaechenmass,
    g.egris_egrid AS egrid,
    g.gem_bfs AS bfs_nr,
    orientierung,
    p.hali,
    p.vali,
    g.lieferdatum AS importdatum,
    to_date(nf.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung,
    s.geometrie,
    p.pos
FROM
    av_avdpool_ng.liegenschaften_grundstueck AS g
    LEFT JOIN av_avdpool_ng.liegenschaften_selbstrecht AS s 
    ON s.selbstrecht_von = g.tid
    LEFT JOIN pos AS p
    ON p.grundstueckpos_von = g.tid
    LEFT JOIN av_avdpool_ng.liegenschaften_lsnachfuehrung AS nf
    ON g.entstehung = nf.tid
WHERE 
    s.geometrie IS NOT NULL;