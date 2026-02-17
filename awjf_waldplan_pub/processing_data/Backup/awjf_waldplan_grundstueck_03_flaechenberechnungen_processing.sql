-- =========================================================
-- 1) Flächenberechnungstabellen für Waldfunktion und Waldnutzung befüllen
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

INSERT INTO waldfunktion_flaechen_berechnet
	SELECT 
		gs.egrid,
		wf.funktion,
		wf.funktion_txt,
		wf.biodiversitaet_id,
		wf.biodiversitaet_objekt,
		wf.biodiversitaet_objekt_txt,
		wf.wytweide,
		wf.wytweide_txt,
		ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, wf.geometrie)))::NUMERIC) AS flaeche
	FROM
		grundstuecke AS gs
	INNER JOIN waldfunktion AS wf 
		ON ST_INTERSECTS(gs.geometrie, wf.geometrie)
		AND gs.t_datasetname = wf.t_datasetname
	GROUP BY 
		gs.egrid,
		wf.funktion,
		wf.funktion_txt,
		biodiversitaet_id,
		biodiversitaet_objekt,
		biodiversitaet_objekt_txt,
		wytweide,
		wytweide_txt
	HAVING 
		ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, wf.geometrie)))::NUMERIC) > 0
;

CREATE INDEX 
	ON waldfunktion_flaechen_berechnet(egrid)
;

INSERT INTO waldnutzung_flaechen_berechnet
	SELECT 
		gs.egrid,
		wnz.nutzungskategorie,
		wnz.nutzungskategorie_txt,
		ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, wnz.geometrie)))::NUMERIC) AS flaeche
	FROM
		grundstuecke AS gs
	INNER JOIN waldnutzung AS wnz 
		ON ST_INTERSECTS(gs.geometrie, wnz.geometrie)
		AND gs.t_datasetname = wnz.t_datasetname
	GROUP BY 
		gs.egrid,
		wnz.nutzungskategorie,
		wnz.nutzungskategorie_txt
	HAVING 
		ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, wnz.geometrie)))::NUMERIC) > 0
;

CREATE INDEX 
	ON waldnutzung_flaechen_berechnet(egrid)
;

-- =========================================================
-- 2) Plausibilsierung berechnete Waldfunktions- und Waldnutzungsflächen
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

INSERT INTO waldfunktion_flaechen_summen
	SELECT
		wfbp.egrid,
		wfbp.flaeche AS waldflaeche,
		SUM(wfb.flaeche) AS flaeche_summe_waldfunktion,
		wfbp.flaeche - SUM(wfb.flaeche) AS flaeche_differenz
	FROM
		waldflaechen_berechnet_plausibilisiert AS wfbp
	LEFT JOIN waldfunktion_flaechen_berechnet AS wfb 
		ON wfbp.egrid = wfb.egrid
	GROUP BY
		wfbp.egrid,
		wfbp.flaeche
;

CREATE INDEX 
	ON waldfunktion_flaechen_summen (egrid)
;

WITH

groesste_waldfunktion AS (
    SELECT DISTINCT ON (egrid)
        egrid,
        flaeche,
        funktion,
        funktion_txt
    FROM
        waldfunktion_flaechen_berechnet
    ORDER BY
        egrid,
        flaeche DESC
)

INSERT INTO waldfunktion_flaechen_berechnet_plausibilisiert 
	SELECT
		wfb.egrid,
		wfb.funktion,
		wfb.funktion_txt,
		biodiversitaet_id,
		biodiversitaet_objekt,
		biodiversitaet_objekt_txt,
		wytweide,
		wytweide_txt,
		CASE
			WHEN wfb.funktion = gw.funktion
				THEN wfb.flaeche + wfs.flaeche_differenz
			ELSE wfb.flaeche
		END AS flaeche,
		CASE
			WHEN wfb.funktion = gw.funktion AND wfs.flaeche_differenz <> 0
				THEN TRUE
			ELSE FALSE
		END AS angepasst
	FROM
		waldfunktion_flaechen_berechnet AS wfb
	LEFT JOIN groesste_waldfunktion AS gw
		ON wfb.egrid = gw.egrid
	LEFT JOIN waldfunktion_flaechen_summen AS wfs 
		ON wfb.egrid = wfs.egrid
;

INSERT INTO waldnutzung_flaechen_summen
	SELECT
		wfbp.egrid,
		wfbp.flaeche AS flaechenmass_grundstueck,
		SUM(wfb.flaeche) AS flaeche_summe_waldnutzung,
		wfbp.flaeche - SUM(wfb.flaeche) AS flaeche_differenz
	FROM
		waldflaechen_berechnet_plausibilisiert AS wfbp
	LEFT JOIN waldnutzung_flaechen_berechnet AS wfb 
		ON wfbp.egrid = wfb.egrid
	GROUP BY
		wfbp.egrid,
		wfbp.flaeche
;

WITH
groesste_waldnutzung AS (
    SELECT DISTINCT ON (egrid)
        egrid,
        flaeche,
        nutzungskategorie,
        nutzungskategorie_txt
    FROM
        waldnutzung_flaechen_berechnet
    ORDER BY
        egrid,
        flaeche DESC
)

INSERT INTO waldnutzung_flaechen_berechnet_plausibilisiert 
	SELECT
		wfb.egrid,
		wfb.nutzungskategorie,
		wfb.nutzungskategorie_txt,
		CASE
			WHEN wfb.nutzungskategorie_txt = gw.nutzungskategorie_txt
				THEN wfb.flaeche + wfs.flaeche_differenz
			ELSE wfb.flaeche
		END AS flaeche,
		CASE
			WHEN wfb.nutzungskategorie_txt = gw.nutzungskategorie_txt AND wfs.flaeche_differenz <> 0
				THEN TRUE
			ELSE FALSE
		END AS angepasst
	FROM
		waldnutzung_flaechen_berechnet AS wfb
	LEFT JOIN groesste_waldnutzung AS gw
		ON wfb.egrid = gw.egrid
	LEFT JOIN waldnutzung_flaechen_summen AS wfs 
		ON wfb.egrid = wfs.egrid
;

-- =========================================================
-- 3) Flächenberechnungstabellen für Waldfunktion, Wytweide und Biodiversität befüllen
-- =========================================================
INSERT INTO waldfunktion_funktion_flaechen_berechnet
	SELECT 
		egrid,
		funktion,
		funktion_txt,
		SUM(flaeche) AS flaeche
	FROM 
		waldfunktion_flaechen_berechnet_plausibilisiert
	GROUP BY
		egrid,
		funktion,
		funktion_txt
;

INSERT INTO wytweideflaechen_berechnet
	SELECT
		egrid,
		SUM(flaeche) AS flaeche
	FROM
		waldfunktion_flaechen_berechnet_plausibilisiert
	WHERE
		wytweide IS TRUE
	GROUP BY 
		egrid
;

INSERT INTO biodiversitaet_objekt_flaechen_berechnet
	SELECT 
		egrid,
		biodiversitaet_objekt_txt,
		SUM(flaeche) AS flaeche
	FROM
		waldfunktion_flaechen_berechnet_plausibilisiert
	WHERE
		funktion IN ('Biodiversitaet', 'Schutzwald_Biodiversitaet')
	GROUP BY 
		egrid,
		biodiversitaet_objekt_txt
;

-- =========================================================
-- 4) Flächenberechnungstabellen für die Waldfunktions- Waldnutzungsverschnitte pro Grundstück
-- =========================================================
INSERT INTO waldfunktion_waldnutzung_flaechen_berechnet
	SELECT
		gs.egrid,
		wfn.t_datasetname,
		wfn.funktion,
		wfn.biodiversitaet_objekt,
		wfn.nutzungskategorie,
		wfn.nutzungskategorie_txt,
		ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, wfn.geometrie)))::NUMERIC) AS flaeche
	FROM 
		grundstuecke AS gs 
	INNER JOIN waldfunktion_waldnutzung_flaechen AS wfn
		ON ST_INTERSECTS(gs.geometrie, wfn.geometrie)
		AND gs.t_datasetname = wfn.t_datasetname
	GROUP BY 
		gs.egrid,
		wfn.t_datasetname,
		wfn.funktion,
		wfn.biodiversitaet_objekt,
		wfn.nutzungskategorie,
		wfn.nutzungskategorie_txt
	HAVING 
		ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, wfn.geometrie)))::NUMERIC) > 0
;
