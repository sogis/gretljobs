-- STATENT: Aggregiert auf Gemeinde-Ebene

DROP TABLE IF EXISTS
    export.gemeinde_statent_agg CASCADE
;

CREATE TABLE
    export.gemeinde_statent_agg AS
    SELECT
        bfs_nr,
        sum(empfte) AS beschaeftigte_fte
    FROM
        export.statent
    GROUP BY
        bfs_nr
;