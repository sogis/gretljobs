-- Zonenschild-Flächenattribute aus Parzellen ableiten

DROP TABLE IF EXISTS
    export.zonenschild_geoms CASCADE;

CREATE TABLE
    export.zonenschild_geoms (
        schild_uuid					UUID,
        geometrie					public.geometry(Polygon, 2056),
        typ_kt						TEXT,
        typ_bund					TEXT,
        bfs_nr						INTEGER,
        flaeche						NUMERIC,
        flaeche_bebaut				NUMERIC,
        flaeche_unbebaut			NUMERIC,
        flaeche_teilweise_bebaut	NUMERIC
);

INSERT
    INTO export.zonenschild_geoms
    SELECT
        z.schild_uuid,
        z.geometrie,
        z.typ_kt,
        z.typ_bund,
        z.bfs_nr,
        sum(flaeche) AS flaeche,
        COALESCE(sum(flaeche) FILTER (WHERE bebauungsstand = 'bebaut'), 0) AS flaeche_bebaut,
        COALESCE(sum(flaeche) FILTER (WHERE bebauungsstand = 'unbebaut'), 0) AS flaeche_unbebaut,
        COALESCE(sum(flaeche) FILTER (WHERE bebauungsstand = 'teilweise_bebaut'), 0) AS flaeche_teilweise_bebaut
FROM
    export.zonentyp_dump z
JOIN export.parzellen_geoms p
    ON ST_Intersects(p.pip, z.geometrie)
    -- tbd Denkfehler: ein Zonenschild kann kleiner sein als Parzelle, ich darf nicht die ganze Parzelle joinen!
GROUP BY
    z.schild_uuid,
    z.geometrie,
    z.typ_kt,
    z.typ_bund,
    z.bfs_nr
;

CREATE INDEX
    ON export.zonenschild_geoms
    USING gist (geometrie);