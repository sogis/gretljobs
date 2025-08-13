-- STATENT: Aggregiert auf Zonenschild-Ebene

DROP TABLE IF EXISTS
    export.zonenschild_statent_statistik CASCADE
;

CREATE TABLE
    export.zonenschild_statent_statistik AS
    SELECT
        schild_uuid,
        sum(empfte) AS beschaeftigte_fte
    FROM
        export.statent
    GROUP BY
        schild_uuid
;