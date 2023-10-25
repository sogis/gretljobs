UPDATE
    afu_stehende_gewaesser_v1.stehendes_gewaesser
SET
    gemeindename = gemeindegrenze.gemeindename
        FROM
            agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS gemeindegrenze
        WHERE
            ST_Contains(gemeindegrenze.geometrie, ST_Centroid(stehendes_gewaesser.geometrie))
        AND
            av_geometrie IS TRUE
        AND
            av_link IS TRUE
;
