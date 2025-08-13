-- STATENT: Aggregiert auf Zonenschild-Ebene

DROP TABLE IF EXISTS
    export.zonenschild_statent_agg CASCADE
;

CREATE TABLE
    export.zonenschild_statent_agg AS
    SELECT
        schild_uuid,
        sum(empfte) AS beschaeftigte_fte
    FROM
        export.zonenschild_basis_statent
    GROUP BY
        schild_uuid
;