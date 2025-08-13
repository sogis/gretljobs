-- Join Parzelle x STATPOP

DROP TABLE IF EXISTS
    export.statpop CASCADE
;

CREATE TABLE
    export.statpop (
    t_ili_tid           UUID,
    typ_kt              TEXT,
    bfs_nr              INTEGER,
    geometrie           public.geometry(MultiPolygon, 2056),
    classagefiveyears   INTEGER
);

INSERT
    INTO export.statpop
    SELECT
        p.t_ili_tid,
        p.typ_kt,
        p.bfs_nr,
        p.geometrie,
        pop.classagefiveyears
    FROM
        export.parzellen_geoms p
    JOIN import.statpop_statent_statpop pop
        ON ST_Within(pop.geometrie, p.geometrie)
;

CREATE INDEX
    ON export.statpop(t_ili_tid)
;

CREATE INDEX
    ON export.statpop(typ_kt)
;

CREATE INDEX
    ON export.statpop(bfs_nr)
;