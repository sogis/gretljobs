-- Zonenschild aus Zonentyp ableiten
DROP TABLE IF EXISTS export.zonenschild_dump CASCADE;

CREATE TABLE
    export.zonenschild_dump (
        schild_uuid		UUID,
        typ_kt			TEXT,
        typ_bund		TEXT,
        bfs_nr			INTEGER,
        geometrie		public.geometry(Polygon, 2056)
);

INSERT
    INTO export.zonenschild_dump
    SELECT
        uuid_generate_v4() AS schild_uuid,
        typ_kt,
        typ_bund,
        bfs_nr,
        (ST_Dump(geometrie)).geom AS geometrie
FROM
    export.zonentyp_basis
;

CREATE INDEX
    ON export.zonenschild_dump
    USING gist (geometrie);