-- Setze das Attribut av_link auf FALSE für alle Objekte, welche
-- 1. innerhalb einer Bodenbedeckungsfläche mit der Art 'Gewaesser.stehendes' liegen
-- und
-- 2. das Attribut av_geometrie TRUE haben.
--
-- Dies betrifft alle Objekte welche ursprünglich aus der AV übernommen worden
-- sind, aber nicht mehr länger in der AV vorliegen.
--
-- Siehe auch Roter Faden:
-- "Flächen mit "av_geometrie" = 'true' und "av_link" = 'false' werden nicht publiziert."
UPDATE 
    afu_stehende_gewaesser_v1.stehendes_gewaesser
SET
    av_link = FALSE
WHERE
    stehendes_gewaesser.t_id NOT IN (
        SELECT
            stehendes_gewaesser.t_id
        FROM
            afu_stehende_gewaesser_v1.stehendes_gewaesser AS stehendes_gewaesser,
            agi_dm01avso24.bodenbedeckung_boflaeche AS bodenflaeche
        WHERE
            ST_Within(ST_PointOnSurface(stehendes_gewaesser.geometrie), bodenflaeche.geometrie)
        AND
            bodenflaeche.art = 'Gewaesser.stehendes'
    )
AND
    av_geometrie IS TRUE
;
