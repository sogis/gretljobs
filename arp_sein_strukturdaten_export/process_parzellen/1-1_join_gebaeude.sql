-- Join Parzelle x GWR Gebäude

DROP TABLE IF EXISTS
    export.gebaeude CASCADE
;

CREATE TABLE
    export.gebaeude (
    t_ili_tid       UUID,
    typ_kt          TEXT,
    bfs_nr          INTEGER,
    egid            INTEGER,
    gkat            INTEGER,
    gkat_txt        TEXT,
    gklas_10        INTEGER,
    gklas_10_txt    TEXT,
    gbaup           INTEGER,
    gbaup_txt       TEXT,
    garea           NUMERIC,
    gastw           INTEGER,
    geometrie       public.geometry(Point, 2056)
);

INSERT
    INTO export.gebaeude
    SELECT
        p.t_ili_tid,
        p.typ_kt,
        p.bfs_nr,
        geb.egid,
        geb.gkat,       -- Gebäudekategorie
        geb.gkat_txt,
        g.gklas_10,     -- Gebäudeklasse dreistellig
        g.gklas_10_txt,
        geb.gbaup,      -- Gebäudebauperiode
        geb.gbaup_txt,
        geb.garea,      -- Gebäudefläche
        geb.gastw,      -- Anzahl Geschosse
        geb.lage AS geometrie
    FROM
        export.parzellen_geoms p
    JOIN import.gwr_gebaeude geb
        ON ST_Within(geb.lage,p.geometrie)
    LEFT JOIN
        export.gebklasse10_mapping g
        ON LEFT(geb.gklas::TEXT,3)::INT = g.gklas_10
    WHERE
        geb.gstat = 1004  -- nur existierende
;

CREATE INDEX
    ON export.gebaeude
    USING gist (geometrie)
;

CREATE INDEX
    ON export.gebaeude(t_ili_tid)
;

CREATE INDEX
    ON export.gebaeude(typ_kt)
;

CREATE INDEX
    ON export.gebaeude(bfs_nr)
;