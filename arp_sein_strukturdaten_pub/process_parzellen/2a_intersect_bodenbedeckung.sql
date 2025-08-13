-- Verschnitt Parzelle x Bodenbedeckung

DROP TABLE IF EXISTS
    export.parzellen_bodenbedeckung CASCADE
;

CREATE TABLE
    export.parzellen_bodenbedeckung (
    t_ili_tid       UUID,
    bfs_nr          INTEGER,
    typ_kt          TEXT,
    kategorie_text  TEXT,
    flaeche_agg     NUMERIC
);

INSERT
    INTO export.parzellen_bodenbedeckung
    SELECT
        p.t_ili_tid,
        p.bfs_nr,
        p.typ_kt,
        mo.art_txt AS kategorie_text,
        sum(
            ST_Area(
                ST_Intersection(p.geometrie, mo.geometrie, 0.001)
            )
        ) AS flaeche_agg
    FROM
        export.parzellen_geoms p
    JOIN import.mopublic_bodenbedeckung mo
        ON ST_Intersects(p.geometrie, mo.geometrie)
    GROUP BY
        p.t_ili_tid,
        p.bfs_nr,
        p.typ_kt,
        mo.art_txt
;

CREATE INDEX
    ON export.parzellen_bodenbedeckung (t_ili_tid)
;

CREATE INDEX
    ON export.parzellen_bodenbedeckung (bfs_nr)
;

CREATE INDEX
    ON export.parzellen_bodenbedeckung (typ_kt)
;

CREATE INDEX
    ON export.parzellen_bodenbedeckung (kategorie_text)
;