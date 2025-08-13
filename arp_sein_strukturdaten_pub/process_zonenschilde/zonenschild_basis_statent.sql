-- STATENT Daten mit Zonenschild-ID anreichern

DROP TABLE IF EXISTS
    export.zonenschild_basis_statent CASCADE
;

CREATE TABLE
    export.zonenschild_basis_statent AS
    SELECT
        ent.*,
        z.schild_uuid
    FROM
        export.statent ent
    JOIN export.zonenschild_basis z
        ON ST_Within(ent.geometrie, z.geometrie)
;

CREATE INDEX
    ON export.zonenschild_basis_statent
    USING gist (geometrie);

CREATE INDEX
    ON export.zonenschild_basis_statent(schild_uuid);