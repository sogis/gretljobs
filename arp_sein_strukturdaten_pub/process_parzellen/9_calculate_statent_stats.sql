-- STATENT: Aggregiert auf Parzellen-Ebene

DROP TABLE IF EXISTS
    export.parzellen_statent_statistik CASCADE
;

CREATE TABLE
    export.parzellen_statent_statistik AS
    SELECT
        t_ili_tid,
        sum(empfte) AS beschaeftigte_fte
    FROM
        export.statent
    GROUP BY
        t_ili_tid
;