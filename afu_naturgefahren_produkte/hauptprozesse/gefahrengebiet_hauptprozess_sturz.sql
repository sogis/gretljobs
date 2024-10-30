DROP TABLE IF EXISTS gk_poly;

CREATE TABLE gk_poly (
    prio int4 NOT NULL,
    gefahrenstufe varchar(255) NOT NULL,
    geometrie geometry(polygon, 2056) NOT NULL,
    charakterisierung varchar(10) NOT NULL,
    hauptprozess varchar(30) NOT NULL
);

DROP INDEX IF EXISTS gk_poly_geometrie;
CREATE INDEX gk_poly_geometrie ON gk_poly USING GIST (geometrie);

DROP TABLE IF EXISTS splited;

CREATE TABLE splited (
    id int4 NOT NULL,
    poly geometry(polygon, 2056) NOT NULL,
    point geometry(point, 2056) NOT NULL,
    gef_max int4 NULL,
    charakterisierung varchar(255) NULL,
    hauptprozess varchar(255) NULL
);

DROP INDEX IF EXISTS splited_point;
CREATE INDEX splited_point ON splited USING GIST (point);
