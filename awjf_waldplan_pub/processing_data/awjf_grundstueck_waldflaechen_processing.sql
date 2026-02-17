-- =========================================================
-- 1) Flächenberechnung
-- =========================================================
INSERT INTO waldflaechen_berechnet
	SELECT
		gs.egrid,
		gs.flaechenmass AS flaechenmass_grundstueck,
		ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, wf.geometrie)))::INTEGER) AS waldflaeche,
		gs.flaechenmass -ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, wf.geometrie)))::NUMERIC) AS flaeche_differenz
	FROM
		grundstuecke AS gs
	LEFT JOIN waldfunktion AS wf 
		ON ST_INTERSECTS(gs.geometrie, wf.geometrie)
		AND gs.t_datasetname = wf.t_datasetname
	GROUP BY 
		gs.egrid,
		gs.flaechenmass
;

CREATE INDEX 
	ON waldflaechen_berechnet(egrid)
;

-- =========================================================
-- 2) Plausibilsierung
-- =========================================================
INSERT INTO	waldflaechen_berechnet_plausibilisiert
	SELECT
		egrid,
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
		waldflaechen_berechnet
;

CREATE INDEX 
	ON waldflaechen_berechnet_plausibilisiert (egrid)
;