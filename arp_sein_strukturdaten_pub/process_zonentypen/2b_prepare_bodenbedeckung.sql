-- Zonentyp x Bodenbedeckung

DROP TABLE IF EXISTS
    export.zonentyp_bodenbedeckung CASCADE
;

CREATE TABLE
    export.zonentyp_bodenbedeckung (
        bfs_nr          INTEGER,
        typ_kt          TEXT,
        kategorie_text  TEXT,
        flaeche_agg     NUMERIC
);

INSERT
    INTO export.zonentyp_bodenbedeckung
    SELECT
        bfs_nr,
        typ_kt,
        kategorie_text,
        sum(flaeche_agg) AS flaeche_agg
    FROM
        export.parzellen_bodenbedeckung
    GROUP BY
        typ_kt,
        bfs_nr,
        kategorie_text
;

CREATE INDEX
    ON export.zonentyp_bodenbedeckung (typ_kt);

CREATE INDEX
    ON export.zonentyp_bodenbedeckung (bfs_nr);

CREATE INDEX
    ON export.zonentyp_bodenbedeckung (kategorie_text);