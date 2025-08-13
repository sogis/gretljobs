-- Alle Ausgangspolygone aus der Bauzonenstatistik (= Grundstück x Zone abzüglich Strassen etc.) plus Reservezonen

DROP TABLE IF EXISTS 
    export.parzellen_geoms CASCADE
;

CREATE TABLE 
    export.parzellen_geoms (
    t_ili_tid                   UUID,
    geometrie                   public.geometry(MultiPolygon, 2056),
    bfs_nr                      INTEGER,
    typ_kt                      TEXT,
    typ_bund                    TEXT,
    bebauungsstand              TEXT,
    flaeche                     NUMERIC,
    flaeche_bebaut              NUMERIC,
    flaeche_unbebaut            NUMERIC,
    flaeche_teilweise_bebaut    NUMERIC,
    pip                         public.geometry(MultiPoint, 2056)
);

INSERT
    INTO export.parzellen_geoms
    WITH bauzonenstatistik_dump AS (
        SELECT
            t_ili_tid,
            bfs_nr,
            grundnutzung_typ_kt,
            bebauungsstand,
            -- MultiPolygon dumpen
            ST_ReducePrecision(
                (ST_Dump(geometrie)).geom,
                0.001
            ) AS part,
            -- Punkte aus den Teilpolygonen ableiten (wird für Join verwendet in der Zonenschild-Berechnung)
            ST_PointOnSurface(
                (ST_Dump(geometrie)).geom
            ) AS pip
        FROM
            import.bauzonenstatistik_liegenschaft_nach_bebauungsstand
    ),
    bauzonenstatistik_geoms AS (
        SELECT
            t_ili_tid,
            bfs_nr,
            grundnutzung_typ_kt,
            bebauungsstand,
            ST_Area(ST_Collect(part)) AS flaeche,
            -- MultiPolygon wieder zusammensetzen
            ST_Collect(part) AS geometrie,
            -- MultiPoint zusammensetzen (benötigt in der Zonenschild-Berechnung)
            ST_Collect(pip) AS pip
        FROM
            bauzonenstatistik_dump
            -- Kleinst-Teilpolygone eliminieren (unscharfe Verschnitte)
        WHERE
            (ST_MaximumInscribedCircle(part)).radius > 0.2
            AND
            ST_Area(part) > 0.5
        GROUP BY
            t_ili_tid,
            bfs_nr,
            grundnutzung_typ_kt,
            bebauungsstand
    ),
    vereinigte_geoms AS (
        SELECT
            t_ili_tid,
            bfs_nr,
            geometrie,
            grundnutzung_typ_kt AS typ_kt,
            bebauungsstand,
            flaeche,
            pip
        FROM
            bauzonenstatistik_geoms
        UNION ALL
        SELECT
            t_ili_tid,
            bfs_nr,
            ST_ReducePrecision(geometrie, 0.001) AS geometrie,
            typ_kt,
            NULL::text AS bebauungsstand,
            ST_Area(geometrie) AS flaeche,
            ST_PointOnSurface(geometrie) AS pip
        FROM
            import.nutzungsplanung_grundnutzung
        WHERE
            (ST_MaximumInscribedCircle(geometrie)).radius > 0.2
            AND
            ST_Area(geometrie) > 0.5
    )
    SELECT
        t_ili_tid,
        geometrie,
        bfs_nr,
        typ_kt,
        substring(typ_kt, 2, 2) AS typ_bund,
        bebauungsstand,
        flaeche,
        CASE
            WHEN bebauungsstand = 'bebaut' THEN flaeche
            ELSE 0
        END AS flaeche_bebaut,
        CASE
            WHEN bebauungsstand = 'unbebaut' THEN flaeche
            ELSE 0
        END AS flaeche_unbebaut,
        CASE
            WHEN bebauungsstand = 'teilweise_bebaut' THEN flaeche
            ELSE 0
        END AS flaeche_teilweise_bebaut,
        pip
    FROM
        vereinigte_geoms
;

CREATE INDEX
    ON export.parzellen_geoms
    USING gist (geometrie)
;

CREATE INDEX
    ON export.parzellen_geoms
    USING gist (pip)
;

CREATE INDEX
    ON export.parzellen_geoms (t_ili_tid)
;

CREATE INDEX
    ON export.parzellen_geoms (bfs_nr)
;

CREATE INDEX
    ON export.parzellen_geoms (typ_kt)
;