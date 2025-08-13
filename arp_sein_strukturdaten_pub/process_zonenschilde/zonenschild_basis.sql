-- Zonenschild-Flächenattribute aus Parzellen ableiten

DROP TABLE IF EXISTS
    export.zonenschild_basis CASCADE;

CREATE TABLE
    export.zonenschild_basis (
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
    INTO export.zonenschild_basis
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
    export.zonenschild_dump z
JOIN export.parzellen_basis p
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
    ON export.zonenschild_basis
    USING gist (geometrie);