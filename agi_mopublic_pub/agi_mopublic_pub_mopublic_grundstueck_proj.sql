WITH pos AS
(
    SELECT
        -- one pos per parcel
        DISTINCT ON (projgrundstueckpos_von)
        projgrundstueckpos_von,
        CASE 
            WHEN ori IS NULL 
                THEN (100 - 100) * 0.9
            ELSE (100 - ori) * 0.9
        END AS orientierung,
        CASE 
            WHEN hali_txt IS NULL 
                THEN 'Center'
            ELSE hali_txt
        END AS hali,
        CASE 
            WHEN vali_txt IS NULL 
                THEN 'Half'
            ELSE vali_txt
        END AS vali,
        pos
    FROM 
        av_avdpool_ng.liegenschaften_projgrundstueckpos
)
SELECT
    grundstueck.nbident,
    grundstueck.nummer,
    grundstueck.art,
    grundstueck.art_txt,
    liegenschaft.flaechenmass,
    grundstueck.egris_egrid AS egrid,
    grundstueck.gem_bfs AS bfs_nr,
    orientierung,
    pos.hali,
    pos.vali,
    grundstueck.lieferdatum AS importdatum,
    to_date(nachfuehrung.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung,
    liegenschaft.geometrie,
    pos.pos
FROM
    av_avdpool_ng.liegenschaften_projgrundstueck AS grundstueck
    LEFT JOIN av_avdpool_ng.liegenschaften_projliegenschaft AS liegenschaft
        ON liegenschaft.projliegenschaft_von = grundstueck.tid
    LEFT JOIN pos
        ON pos.projgrundstueckpos_von = grundstueck.tid
    LEFT JOIN av_avdpool_ng.liegenschaften_lsnachfuehrung AS nachfuehrung
        ON grundstueck.entstehung = nachfuehrung.tid
WHERE 
    liegenschaft.geometrie IS NOT NULL

UNION ALL

SELECT
    grundstueck.nbident,
    grundstueck.nummer,
    grundstueck.art,
    grundstueck.art_txt,
    selbstrecht.flaechenmass,
    grundstueck.egris_egrid AS egrid,
    grundstueck.gem_bfs AS bfs_nr,
    orientierung,
    pos.hali,
    pos.vali,
    grundstueck.lieferdatum AS importdatum,
    to_date(nachfuehrung.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung,
    selbstrecht.geometrie,
    pos.pos
FROM
    av_avdpool_ng.liegenschaften_projgrundstueck AS grundstueck
    LEFT JOIN av_avdpool_ng.liegenschaften_projselbstrecht AS selbstrecht 
        ON selbstrecht.projselbstrecht_von = grundstueck.tid
    LEFT JOIN pos
        ON pos.projgrundstueckpos_von = grundstueck.tid
    LEFT JOIN av_avdpool_ng.liegenschaften_lsnachfuehrung AS nachfuehrung
        ON grundstueck.entstehung = nachfuehrung.tid
WHERE 
    selbstrecht.geometrie IS NOT NULL
;