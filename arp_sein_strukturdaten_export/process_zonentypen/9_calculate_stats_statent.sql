-- STATENT: Aggregiert auf Zonentyp-Ebene

DROP TABLE IF EXISTS
    export.zonentyp_statent_statistik CASCADE
;

CREATE TABLE
    export.zonentyp_statent_statistik AS
    SELECT
        typ_kt,
        bfs_nr,
        sum(empfte) AS beschaeftigte_fte
    FROM
        export.statent
    GROUP BY
        typ_kt,
        bfs_nr
;