INSERT INTO
    afu_stehende_gewaesser_v1.stehendes_gewaesser
    (
        aname,
        geometrie,
        typ,
        gemeindename,
        av_geometrie,
        av_link
    )
 WITH new_av_gewaesser AS (
        SELECT
            gemeindegrenze.gemeindename,
            ST_Buffer(ST_PointOnSurface(bodenflaeche.geometrie), 5) AS geometrie_av
        FROM
            agi_dm01avso24.bodenbedeckung_boflaeche AS bodenflaeche
            LEFT JOIN agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS gemeindegrenze
              ON bodenflaeche.t_datasetname::int = gemeindegrenze.bfs_gemeindenummer
        WHERE
           art = 'Gewaesser.stehendes'
    )
    SELECT
        NULL AS aname,
        ST_MakePolygon(ST_MakeLine(
          ARRAY[
            ST_SetSRID(ST_MakePoint(ST_X(ST_PointOnSurface(geometrie_av)) - 2, ST_Y(ST_PointOnSurface(geometrie_av)) - 2), 2056),
            ST_SetSRID(ST_MakePoint(ST_X(ST_PointOnSurface(geometrie_av)) - 2, ST_Y(ST_PointOnSurface(geometrie_av)) + 2), 2056),
            ST_SetSRID(ST_MakePoint(ST_X(ST_PointOnSurface(geometrie_av)) + 2, ST_Y(ST_PointOnSurface(geometrie_av)) + 2), 2056),
            ST_SetSRID(ST_MakePoint(ST_X(ST_PointOnSurface(geometrie_av)) + 2, ST_Y(ST_PointOnSurface(geometrie_av)) - 2), 2056),
            ST_SetSRID(ST_MakePoint(ST_X(ST_PointOnSurface(geometrie_av)) - 2, ST_Y(ST_PointOnSurface(geometrie_av)) - 2), 2056)
          ])
        ) AS geometrie,
        'andere' AS typ,
        new_av_gewaesser.gemeindename,
        true AS av_geometrie,
        true AS av_link
    FROM
        new_av_gewaesser
        LEFT JOIN afu_stehende_gewaesser_v1.stehendes_gewaesser
          ON ST_Contains(new_av_gewaesser.geometrie_av, stehendes_gewaesser.geometrie)
    WHERE
        stehendes_gewaesser.geometrie IS NULL
;
