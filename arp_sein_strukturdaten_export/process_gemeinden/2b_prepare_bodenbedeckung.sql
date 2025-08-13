-- Gemeinde x Bodenbedeckung

DROP TABLE IF EXISTS
    export.gemeinde_bodenbedeckung CASCADE
;

CREATE TABLE
    export.gemeinde_bodenbedeckung (
        bfs_nr          INTEGER,
        kategorie_text  TEXT,
        flaeche_agg     NUMERIC
);

INSERT
    INTO export.gemeinde_bodenbedeckung
    SELECT
        bfs_nr,
        kategorie_text,
        sum(flaeche_agg) AS flaeche_agg
    FROM
        export.parzellen_bodenbedeckung
    GROUP BY
        bfs_nr,
        kategorie_text
;

CREATE INDEX
    ON export.gemeinde_bodenbedeckung (bfs_nr);