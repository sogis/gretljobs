DELETE FROM
    afu_stehende_gewaesser_v1.stehendes_gewaesser
WHERE
    stehendes_gewaesser.t_id NOT IN (
        SELECT
            stehendes_gewaesser.t_id
        FROM
            afu_stehende_gewaesser_v1.stehendes_gewaesser AS stehendes_gewaesser,
            agi_dm01avso24.bodenbedeckung_boflaeche AS bodenflaeche
        WHERE
            ST_Within(ST_PointOnSurface(stehendes_gewaesser.geometrie), bodenflaeche.geometrie)
    )
AND
    av_geometrie IS TRUE
;
