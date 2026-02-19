DELETE FROM waldfunktion;
INSERT INTO waldfunktion
	SELECT
		wf.t_datasetname,
		wf.funktion,
		wf.funktion_txt,
		wf.biodiversitaet_id,
		wf.biodiversitaet_objekt,
		wf.biodiversitaet_objekt_txt,
		wf.wytweide,
		wytweide_txt,
		wf.geometrie,
		wf.bemerkung
	FROM 
		awjf_waldplan_pub_v2.waldplan_waldfunktion AS wf
	WHERE
		wf.t_datasetname::int4 = ${bfsnr_param}
;

CREATE INDEX 
	ON waldfunktion
	USING gist (geometrie)
;

DELETE FROM waldnutzung;
INSERT INTO waldnutzung
	SELECT
		wnz.t_datasetname,
		wnz.t_id,
		wnz.nutzungskategorie,
		wnz.nutzungskategorie_txt,
		wnz.geometrie
	FROM 
		awjf_waldplan_pub_v2.waldplan_waldnutzung AS wnz
	WHERE
		wnz.t_datasetname::int4 = ${bfsnr_param}
;

CREATE INDEX 
	ON waldnutzung
	USING gist (geometrie)
;

CREATE INDEX 
	ON waldflaeche_grundstueck
	USING gist (geometrie)
;

DELETE FROM waldfunktion_waldnutzung;
INSERT INTO waldfunktion_waldnutzung
SELECT
	wnz.t_datasetname,
	wf.funktion,
	wf.funktion_txt,
	wf.biodiversitaet_objekt,
	wf.biodiversitaet_objekt_txt,
	wf.wytweide,
	wnz.nutzungskategorie,
	wnz.nutzungskategorie_txt,
	ST_Intersection(wnz.geometrie, wf.geometrie) AS geometrie
FROM 
	waldnutzung AS wnz
LEFT JOIN waldfunktion AS wf 
	ON St_Intersects(wnz.geometrie, wf.geometrie)
AND 
	ST_Area(ST_Intersection(wnz.geometrie, wf.geometrie)) > 0.5
;

CREATE INDEX
	ON waldfunktion_waldnutzung
	USING gist (geometrie)
;

DELETE FROM waldfunktion_waldnutzung_grundstueck_berechnet;
INSERT INTO waldfunktion_waldnutzung_grundstueck_berechnet
	SELECT
		*
	FROM (
		SELECT
			gs.egrid,
			wfn.t_datasetname,
			wfn.funktion,
			wfn.funktion_txt,
			wfn.biodiversitaet_objekt,
			wfn.biodiversitaet_objekt_txt,
			wfn.wytweide,
			wfn.nutzungskategorie,
			wfn.nutzungskategorie_txt,
			ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, wfn.geometrie)))::NUMERIC) AS flaeche
		FROM
			grundstueck AS gs 
		INNER JOIN waldfunktion_waldnutzung AS wfn
			ON ST_Intersects(gs.geometrie, wfn.geometrie)
			AND gs.t_datasetname = wfn.t_datasetname
		GROUP BY 
			gs.egrid,
			wfn.t_datasetname,
			wfn.funktion,
			wfn.funktion_txt,
			wfn.biodiversitaet_objekt,
			wfn.biodiversitaet_objekt_txt,
			wfn.wytweide,
			wfn.nutzungskategorie,
			wfn.nutzungskategorie_txt
		ORDER BY
			egrid
	) s
	WHERE
		ROUND(flaeche)::numeric > 0;
;

CREATE INDEX
	ON waldfunktion_waldnutzung_grundstueck_berechnet(egrid)
;