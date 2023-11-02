WITH intersectsgemeinden AS (
    SELECT
        ST_Intersection(gemeindegrenze.geometrie, stehendes_gewaesser.geometrie) AS geom,
        stehendes_gewaesser.t_id AS id,
        gemeindegrenze.gemeindename
    FROM
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS gemeindegrenze 
        INNER JOIN afu_stehende_gewaesser_v1.stehendes_gewaesser AS stehendes_gewaesser
       ON ST_Intersects (gemeindegrenze.geometrie,stehendes_gewaesser.geometrie)
    WHERE
        av_geometrie IS FALSE AND av_link IS FALSE
   AND
       ST_Area(ST_intersection(gemeindegrenze.geometrie, stehendes_gewaesser.geometrie)) > 5   -- Mindestgrösse?
)

SELECT
    stehendes_gewaesser.aname,
    stehendes_gewaesser.geometrie,
    stehendes_gewaesser.typ,
    string_agg(intersectsgemeinden.gemeindename, ', ') AS gemeindename,
    stehendes_gewaesser.erhebung_abgeschlossen,
    stehendes_gewaesser.av_geometrie
FROM
    afu_stehende_gewaesser_v1.stehendes_gewaesser AS stehendes_gewaesser
    INNER JOIN intersectsgemeinden
      ON stehendes_gewaesser.t_id = intersectsgemeinden.id
GROUP BY
    stehendes_gewaesser.t_id,
    stehendes_gewaesser.geometrie 
     
UNION ALL
    
SELECT 
    aname,
    geometrie,
    typ,
    gemeindename,
    erhebung_abgeschlossen,
    av_geometrie
FROM 
    afu_stehende_gewaesser_v1.stehendes_gewaesser_av
;
