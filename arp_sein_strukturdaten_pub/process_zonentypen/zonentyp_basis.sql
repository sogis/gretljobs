-- Geometrische Grundlage für den Zonentyp

DROP TABLE IF EXISTS
    export.zonentyp_basis CASCADE
;

CREATE TABLE
    export.zonentyp_basis (
        geometrie                   public.geometry(MultiPolygon, 2056),
        bfs_nr                      INTEGER,
        typ_kt                      TEXT,
        typ_bund                    TEXT,
        bebauungsstand              TEXT,
        flaeche                     NUMERIC,
        flaeche_bebaut              NUMERIC,
        flaeche_unbebaut            NUMERIC,
        flaeche_teilweise_bebaut    NUMERIC
);

INSERT
    INTO export.zonentyp_basis
    SELECT
        ST_Union(
            ST_MakeValid(
                ST_ReducePrecision(
                    ST_Buffer(
                        ST_Buffer(
                            geometrie, 0.25, 'join=mitre'
                        ), -0.25, 'join=mitre'
                    ), 0.001
                ), 'method=structure'
            ), 0.001
        ) as geometrie,
        bfs_nr,
        typ_kt,
        typ_bund,
        NULL AS bebauungsstand,
        ST_Area(ST_Union(geometrie)) AS flaeche,
        COALESCE(
            sum(ST_Area(geometrie)) FILTER (WHERE bebauungsstand = 'bebaut'), 0
        ) AS flaeche_bebaut,
        COALESCE(
            sum(ST_Area(geometrie)) FILTER (WHERE bebauungsstand = 'unbebaut'), 0
        ) AS flaeche_unbebaut,
        COALESCE(
            sum(ST_Area(geometrie)) FILTER (WHERE bebauungsstand = 'teilweise_bebaut'), 0
        ) AS flaeche_teilweise_bebaut
FROM
    export.parzellen_basis
GROUP BY
    typ_kt,
    typ_bund,
    bfs_nr
;

CREATE INDEX
    ON export.zonentyp_basis
    USING gist (geometrie);

CREATE INDEX
    ON export.zonentyp_basis (typ_kt);

CREATE INDEX
    ON export.zonentyp_basis (bfs_nr);