/* Gültige Grenzpunkte in Mutation */
SELECT
    CAST(gp.t_datasetname AS INTEGER) AS bfs_nr,
    gp.geometrie AS geometrie,
    gp.punktzeichen AS punktzeichen,
    gp.gueltigkeit AS gueltigkeit,
    CAST('true' AS BOOLEAN) AS mutation    
FROM
    (
        SELECT
            CAST(grenzpunkt.t_datasetname AS INTEGER) AS bfs_nr,
            grenzpunkt.geometrie AS geometrie,
            grenzpunkt.punktzeichen AS punktzeichen,
            nachfuehrung.gueltigkeit AS gueltigkeit,
            grenzpunkt.t_datasetname AS t_datasetname
        FROM
            agi_dm01avso24.liegenschaften_grenzpunkt AS grenzpunkt
            LEFT JOIN agi_dm01avso24.liegenschaften_lsnachfuehrung AS nachfuehrung
            ON  grenzpunkt.entstehung = nachfuehrung.t_id
        WHERE nachfuehrung.gueltigkeit = 'gueltig'
    ) AS gp    
    INNER JOIN agi_dm01avso24.liegenschaften_projliegenschaft AS projliegen
    ON ST_ContainsProperly(projliegen.geometrie, gp.geometrie)

UNION ALL

/* Alle Grenzpunkte minus gültige Grenzpunkte in Mutation */
SELECT
    CAST(grenzpunkt.t_datasetname AS INTEGER) AS bfs_nr,
    grenzpunkt.geometrie AS geometrie,
    grenzpunkt.punktzeichen AS punktzeichen,
    nachfuehrung.gueltigkeit AS gueltigkeit,
    CAST('false' AS BOOLEAN) AS mutation
FROM
    agi_dm01avso24.liegenschaften_grenzpunkt AS grenzpunkt
    LEFT JOIN agi_dm01avso24.liegenschaften_lsnachfuehrung AS nachfuehrung
    ON  grenzpunkt.entstehung = nachfuehrung.t_id

EXCEPT

SELECT
    CAST(gp.t_datasetname AS INTEGER) AS bfs_nr,
    gp.geometrie AS geometrie,
    gp.punktzeichen AS punktzeichen,
    gp.gueltigkeit AS gueltigkeit,
    CAST('false' AS BOOLEAN) AS mutation    
FROM
    (
        SELECT
            CAST(grenzpunkt.t_datasetname AS INTEGER) AS bfs_nr,
            grenzpunkt.geometrie AS geometrie,
            grenzpunkt.punktzeichen AS punktzeichen,
            nachfuehrung.gueltigkeit AS gueltigkeit,
            grenzpunkt.t_datasetname AS t_datasetname
        FROM
            agi_dm01avso24.liegenschaften_grenzpunkt AS grenzpunkt
            LEFT JOIN agi_dm01avso24.liegenschaften_lsnachfuehrung AS nachfuehrung
            ON  grenzpunkt.entstehung = nachfuehrung.t_id
        WHERE nachfuehrung.gueltigkeit = 'gueltig'
    ) AS gp    
    INNER JOIN agi_dm01avso24.liegenschaften_projliegenschaft AS projliegen
    ON ST_ContainsProperly(projliegen.geometrie, gp.geometrie)
;