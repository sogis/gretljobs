-- STATPOP Daten mit Zonenschild-ID anreichern

DROP TABLE IF EXISTS
    export.zonenschild_basis_statpop CASCADE
;

CREATE TABLE
    export.zonenschild_basis_statpop AS
    SELECT
        pop.*,
        z.schild_uuid
    FROM
        export.statpop pop
    JOIN export.zonenschild_basis z
        ON ST_Within(pop.geometrie, z.geometrie)
;

CREATE INDEX
    ON export.zonenschild_basis_statpop
    USING gist (geometrie);

CREATE INDEX
    ON export.zonenschild_basis_statpop(schild_uuid);