INSERT INTO
    afu_stehende_gewaesser_v1.stehendes_gewaesser
    (
        aname,
        geometrie,
        typ,
        gemeindename,
        erhebung_abgeschlossen,
        av_geometrie,
        av_link
    )
    WITH new_av_gewaesser AS (
        SELECT
            ST_Buffer(ST_PointOnSurface(geometrie), 5) AS geometrie_av
        FROM
            agi_dm01avso24.bodenbedeckung_boflaeche   
        WHERE
           art = 'Gewaesser.stehendes'
    )

    SELECT
        NULL AS aname,
        --ST_MakePolygon(
            --ST_MakeLine(
              --ARRAY[
                --ST_SetSRID(ST_MakePoint(ST_X(ST_PointOnSurface(geometrie_av)), ST_Y(ST_PointOnSurface(geometrie_av)) + 0.3), 2056),
                --ST_SetSRID(ST_MakePoint(ST_X(ST_PointOnSurface(geometrie_av)) - 0.3, ST_Y(ST_PointOnSurface(geometrie_av)) -0.2), 2056),
                --ST_SetSRID(ST_MakePoint(ST_X(ST_PointOnSurface(geometrie_av)) + 0.3, ST_Y(ST_PointOnSurface(geometrie_av)) -0.2), 2056),
                --ST_SetSRID(ST_MakePoint(ST_X(ST_PointOnSurface(geometrie_av)), ST_Y(ST_PointOnSurface(geometrie_av)) + 0.3), 2056)
              --]
            --)
        --) AS geometrie,
        --ST_Buffer(ST_PointOnSurface(geometrie_av), 2) AS geometrie,
        geometrie_av AS geometrie,
        'andere' AS typ,
        'Gemeindename' AS gemeindename,
        false AS erhebung_abgeschlossen,
        true AS av_geometrie,
        true AS av_link
    FROM
        new_av_gewaesser
        LEFT JOIN afu_stehende_gewaesser_v1.stehendes_gewaesser
          ON ST_Contains(new_av_gewaesser.geometrie_av, stehendes_gewaesser.geometrie)
    WHERE
        stehendes_gewaesser.geometrie IS NULL
;
