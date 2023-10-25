WITH av_gewaesser AS (
    SELECT
        ST_Buffer(ST_PointOnSurface(geometrie), 5) AS geometrie_av
    FROM
        agi_dm01avso24.bodenbedeckung_boflaeche   
    WHERE
       art = 'Gewaesser.stehendes'
),
not_av_gewaesser AS (
    SELECT
        t_id
    FROM
        afu_stehende_gewaesser_v1.stehendes_gewaesser
        LEFT JOIN av_gewaesser
          ON ST_Contains(av_gewaesser.geometrie_av, stehendes_gewaesser.geometrie)
    WHERE
        av_gewaesser.geometrie_av IS NULL
    AND
        av_geometrie IS TRUE
)
UPDATE
    afu_stehende_gewaesser_v1.stehendes_gewaesser AS stehendes_gewaesser
SET
    av_link = FALSE
FROM
    not_av_gewaesser
WHERE
    stehendes_gewaesser.t_id = not_av_gewaesser.t_id
AND
    stehendes_gewaesser.av_link IS TRUE
;
