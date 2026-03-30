-- =========================================================
-- 1) Waldgeometrie pro Grundstück
-- =========================================================
INSERT INTO waldgeometrie_grundstueck (
	egrid,
	flaechenmass,
	geometrie
)
SELECT
    gs.egrid,
    gs.flaechenmass,
    (ST_Dump(
        ST_Intersection(
            ST_Snap(wf.geometrie, gs.geometrie, 0.01), --snap auf Grundstuecksgeometrie
            gs.geometrie
        )
    )).geom AS geometrie
FROM
	grundstueck AS gs
LEFT JOIN waldfunktion AS wf
	ON ST_Intersects(gs.geometrie, wf.geometrie)
    AND gs.t_datasetname = wf.t_datasetname
WHERE
	ST_Area(
		ST_Intersection(
			ST_Snap(wf.geometrie, gs.geometrie, 0.01),
			gs.geometrie
        )
    ) >= 1
GROUP BY 
	gs.egrid,
	gs.flaechenmass,
	gs.geometrie,
	wf.geometrie
;

CREATE INDEX 
	ON waldgeometrie_grundstueck
	USING gist (geometrie)
;

-- Bereinigung der Geometrien --
INSERT INTO waldgeometrie_grundstueck_bereinigt (
	egrid,
	flaechenmass,
	geometrie
)
SELECT
	egrid,
	flaechenmass,
    (ST_Dump( -- da St_ReducePrecision teilweise Multipolygone erzeugen kann, müssen diese nochmals zerlegt werden
        ST_ReducePrecision( -- Reduziert Koordinatengenauigkeit
            (ST_Dump( -- Zerlegung Multipolygone in Einzelpolygone
                ST_CollectionExtract( -- filtert Polygone heraus (3)
                    ST_MakeValid(geometrie),
                    3
                )
            )).geom,
            0.001  -- 1 mm Präzision
        )
    )).geom AS geometrie
FROM
	waldgeometrie_grundstueck
WHERE
	ST_Area(geometrie) > 0.5 -- nur Geometrien mit sinnvoller Grösse soll 
GROUP BY
	egrid,
	flaechenmass,
	geometrie
;

CREATE INDEX 
	ON waldgeometrie_grundstueck_bereinigt
	USING gist (geometrie)
;

-- Vereinigung der Geometrie zu einem Multipolygon pro Grundstueck --
INSERT INTO waldgeometrie_grundstueck_final (
	egrid,
	flaechenmass,
	geometrie
)
SELECT
    egrid,
    flaechenmass,
    ST_Multi(
        ST_Union(geometrie)
    ) AS geometrie
FROM
	waldgeometrie_grundstueck_bereinigt
GROUP BY
	egrid,
	flaechenmass
;

CREATE INDEX
	ON waldgeometrie_grundstueck_final
	USING gist (geometrie)
;

-- =========================================================
-- 2) Berechnung Waldfläche pro Grundstück
-- =========================================================
INSERT INTO waldflaeche_berechnet (
	egrid,
	flaechenmass_grundstueck,
	waldflaeche,
	flaeche_differenz
)
	SELECT
		egrid,
		flaechenmass AS flaechenmass_grundstueck,
		ROUND(ST_Area(geometrie)) AS waldflaeche,
		flaechenmass - ROUND(St_Area(geometrie)) AS flaeche_differenz
	FROM
		waldgeometrie_grundstueck_final
	GROUP BY 
		egrid,
		flaechenmass,
		geometrie
;

CREATE INDEX 
	ON waldflaeche_berechnet(egrid)
;

-- =========================================================
-- 3) Plausibilisierung der berechneten Waldflächen
-- =========================================================
INSERT INTO	waldflaeche_berechnet_plausibilisiert (
	egrid,
	flaechenmass_grundstueck,
	flaeche,
	angepasst
)
	SELECT
		egrid,
		flaechenmass_grundstueck,
		CASE
			WHEN flaeche_differenz BETWEEN -1 AND 1 -- Wenn die berechnete Waldfläche 1 m2 grösser oder kleiner ist als die Grundstücksfläche, wird diese angeglichen
				THEN flaechenmass_grundstueck 
			ELSE waldflaeche
		END AS flaeche,
		CASE
			WHEN flaeche_differenz BETWEEN -1 AND 1 
				THEN TRUE
			ELSE FALSE
		END AS angepasst
	FROM 
		waldflaeche_berechnet
;

CREATE INDEX 
	ON waldflaeche_berechnet_plausibilisiert (egrid)
;