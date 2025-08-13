-- Zonenschild aus Zonentyp ableiten

DROP TABLE IF EXISTS
    export.zonentyp_dump CASCADE
;

CREATE TABLE
    export.zonentyp_dump (
        schild_uuid		UUID,
        typ_kt			TEXT,
        typ_bund		TEXT,
        bfs_nr			INTEGER,
        geometrie		public.geometry(Polygon, 2056)
);

INSERT
    INTO export.zonentyp_dump
    SELECT
        uuid_generate_v4() AS schild_uuid,
        typ_kt,
        typ_bund,
        bfs_nr,
        (ST_Dump(geometrie)).geom AS geometrie
    FROM
        export.zonentyp_geoms
;

CREATE INDEX
    ON export.zonentyp_dump
    USING gist (geometrie);