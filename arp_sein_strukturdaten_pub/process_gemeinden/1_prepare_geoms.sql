-- Gemeinde-Flächenattribute aus Parzellen ableiten

DROP TABLE IF EXISTS
    export.gemeinde_geoms CASCADE
;

CREATE TABLE
    export.gemeinde_geoms (
        geometrie					public.geometry(MultiPolygon, 2056),
        gemeindename				TEXT,
        bfs_nr						INTEGER,
        flaeche						NUMERIC,
        flaeche_bebaut				NUMERIC,
        flaeche_unbebaut			NUMERIC,
        flaeche_teilweise_bebaut	NUMERIC
);

INSERT
    INTO export.gemeinde_geoms
    SELECT
        g.geometrie,
        g.gemeindename,
        g.bfs_gemeindenummer AS bfs_nr,
        sum(flaeche) AS flaeche,
        COALESCE(sum(flaeche) FILTER (WHERE bebauungsstand = 'bebaut'), 0) AS flaeche_bebaut,
        COALESCE(sum(flaeche) FILTER (WHERE bebauungsstand = 'unbebaut'), 0) AS flaeche_unbebaut,
        COALESCE(sum(flaeche) FILTER (WHERE bebauungsstand = 'teilweise_bebaut'), 0) AS flaeche_teilweise_bebaut
FROM
    import.hoheitsgrenzen_gemeindegrenze g
JOIN export.parzellen_geoms p
    ON g.bfs_gemeindenummer = p.bfs_nr
GROUP BY
    g.geometrie,
    g.gemeindename,
    g.bfs_gemeindenummer
;

CREATE INDEX
    ON export.gemeinde_geoms
    USING gist (geometrie);

CREATE INDEX
    ON export.gemeinde_geoms (bfs_nr);