-- Join Parzelle x STATENT

DROP TABLE IF EXISTS
    export.statent CASCADE
;

CREATE TABLE
    export.statent (
    t_ili_tid   UUID,
    typ_kt      TEXT,
    bfs_nr      INTEGER,
    geometrie   public.geometry(MultiPolygon, 2056),
    empfte      NUMERIC
);

INSERT
    INTO export.statent
    SELECT
        p.t_ili_tid,
        p.typ_kt,
        p.bfs_nr,
        p.geometrie,
        ent.empfte
    FROM
        export.parzellen_geoms p
    JOIN import.statpop_statent_statent ent
        ON ST_Within(ent.geometrie, p.geometrie)
;

CREATE INDEX
    ON export.statent(t_ili_tid)
;

CREATE INDEX
    ON export.statent(typ_kt)
;

CREATE INDEX
    ON export.statent(bfs_nr)
;