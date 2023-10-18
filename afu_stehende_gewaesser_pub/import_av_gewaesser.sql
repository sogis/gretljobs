INSERT INTO
    afu_stehende_gewaesser_v1.av_gewaesser
    (
        aname,
        geometrie,
        typ,
        gemeindename,
        erhebung_abgeschlossen
    )
WITH new_av_gewaesser AS (
    SELECT
        geometrie
    FROM
        agi_dm01avso24.bodenbedeckung_boflaeche   
    WHERE
       art = 'Gewaesser.stehendes'  
--    AND
--        ST_Area(geometrie) > 20
) 
SELECT
    NULL AS aname,
    ST_Buffer(ST_PointOnSurface(new_av_gewaesser.geometrie), 10) AS geometrie,
    'andere' AS typ,
    'Gemeindename' AS gemeindename,
    false AS erhebung_abgeschlossen
FROM
    new_av_gewaesser
    LEFT JOIN afu_stehende_gewaesser_v1.av_gewaesser
      ON ST_Contains(new_av_gewaesser.geometrie, av_gewaesser.geometrie)
WHERE
    av_gewaesser.geometrie IS NULL
;
