INSERT INTO waldflaeche_grundstueck (
	egrid,
	geometrie
)
SELECT
    gs.egrid,
    (ST_Dump(
        ST_Intersection(
            ST_Snap(wf.geometrie, gs.geometrie, 0.01), --snap auf Grundstueck-Geometrie
            gs.geometrie
        )
    )).geom AS geometrie
FROM
	waldfunktion AS wf
JOIN grundstueck AS gs
	ON ST_Intersects(wf.geometrie, gs.geometrie)
    AND wf.t_datasetname = gs.t_datasetname
WHERE
	ST_Area(ST_Intersection(
        ST_Snap(wf.geometrie, gs.geometrie, 0.01),
        gs.geometrie
    )) > 0.5;

;

CREATE INDEX 
	ON waldflaeche_grundstueck
	USING gist (geometrie)
;

-- Bereinigung der Geometrien --
INSERT INTO waldflaeche_grundstueck_bereinigt (
	egrid,
	geometrie
)
SELECT
	egrid,
    (ST_Dump(
        ST_ReducePrecision(
            (ST_Dump(
                ST_CollectionExtract(
                    ST_MakeValid(geometrie),
                    3
                )
            )).geom,
            0.001  -- 1 mm Präzision
        )
    )).geom AS geometrie
FROM
	waldflaeche_grundstueck
WHERE
	ST_Area(geometrie) > 0.5;

CREATE INDEX 
	ON waldflaeche_grundstueck_bereinigt
	USING gist (geometrie)
;

-- Zweite Bereinigung --
INSERT INTO waldflaeche_grundstueck_final (
	egrid,
	geometrie
)
SELECT
    egrid,
    ST_Multi(
        ST_Union(geometrie)
    ) AS geometrie
FROM
	waldflaeche_grundstueck_bereinigt
GROUP BY
	egrid;

CREATE INDEX
	ON waldflaeche_grundstueck_final
	USING gist (geometrie)
;

-- Berechnung Waldfläche pro Grundstück --
INSERT INTO waldflaeche_berechnet (
	egrid,
	flaechenmass_grundstueck,
	waldflaeche,
	flaeche_differenz
)
	SELECT
		gs.egrid,
		gs.flaechenmass AS flaechenmass_grundstueck,
		ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, wf.geometrie)))::INTEGER) AS waldflaeche,
		gs.flaechenmass -ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, wf.geometrie)))::NUMERIC) AS flaeche_differenz
	FROM
		grundstueck AS gs
	LEFT JOIN waldfunktion AS wf 
		ON ST_INTERSECTS(gs.geometrie, wf.geometrie)
		AND gs.t_datasetname = wf.t_datasetname
	GROUP BY 
		gs.egrid,
		gs.flaechenmass
;

CREATE INDEX 
	ON waldflaeche_berechnet(egrid)
;

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
			WHEN flaeche_differenz BETWEEN -1 AND 1 
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