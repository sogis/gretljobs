-- Join Parzelle x GWR Wohnung

DROP TABLE IF EXISTS 
    export.wohnung CASCADE
;

CREATE TABLE
    export.wohnung (
    t_ili_tid   UUID,
    typ_kt      TEXT,
    bfs_nr      INTEGER,
    egid        INTEGER,
    geometrie   public.geometry(Point, 2056),
    ewid        INTEGER,
    warea       NUMERIC,
    wazim       INTEGER
);

INSERT
    INTO export.wohnung
    SELECT
        g.t_ili_tid,
        g.typ_kt,
        g.bfs_nr,
        g.egid,
        g.geometrie,
        w.ewid,
        w.warea,
        -- Wohnungsfläche
        w.wazim
        -- Anzahl Zimmer
    FROM
        export.gebaeude g
    LEFT JOIN
        import.gwr_wohnung w
        USING (egid)
;

CREATE INDEX
    ON export.wohnung
    USING gist (geometrie)
;

CREATE INDEX
    ON export.wohnung(t_ili_tid)
;

CREATE INDEX
    ON export.wohnung(typ_kt)
;

CREATE INDEX
    ON export.wohnung(bfs_nr)
;