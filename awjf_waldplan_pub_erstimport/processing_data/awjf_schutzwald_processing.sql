DELETE FROM awjf_waldplan_pub_v2.waldplan_schutzwald;

WITH

grundstuecke AS (
SELECT
	ww.egrid,
	ww.forstkreis,
	fk.dispname AS forstkreis_txt,
	wfr.aname AS forstrevier,
	mop.geometrie
FROM
	awjf_waldplan_v2.waldplan_waldeigentum AS ww
LEFT JOIN agi_mopublic_pub.mopublic_grundstueck AS mop
	ON ww.egrid = mop.egrid
LEFT JOIN awjf_waldplan_v2.waldplankatalog_forstrevier AS wfr
	ON ww.forstrevier = wfr.t_id
LEFT JOIN awjf_waldplan_v2.forstkreise AS fk 
	ON ww.forstkreis = fk.ilicode
),

schutzwald AS (
SELECT
	basket.t_id AS t_basket,
	sw.t_datasetname,
	sw.schutzwald_nr,
	--forstkreis,
	--forstkreis_txt,
	--forstrevier,
	CASE 
		WHEN sw.sturz IS TRUE 
			THEN TRUE 
		ELSE FALSE
	END AS sturz,
	CASE 
		WHEN sw.sturz IS TRUE
			THEN 'Sturz modelliert'
		ELSE 'Sturz nicht modelliert'
	END AS sturz_txt,
	CASE 
		WHEN sw.rutsch IS TRUE 
			THEN TRUE 
		ELSE FALSE
	END AS rutsch,
	CASE 
		WHEN sw.rutsch IS TRUE
			THEN 'Rutsch modelliert'
		ELSE 'Rutsch nicht modelliert'
	END AS rutsch_txt,
	CASE 
		WHEN sw.gerinnerelevante_prozesse IS TRUE 
			THEN TRUE 
		ELSE FALSE
	END AS gerinnerelevante_prozesse,
	CASE 
		WHEN sw.gerinnerelevante_prozesse IS TRUE
			THEN 'Gerinnerelevante Prozesse modelliert'
		ELSE 'Gerinnerelevante Prozesse nicht modelliert'
	END AS gerinnerelevante_prozesse_txt,
	CASE 
		WHEN sw.lawine IS TRUE 
			THEN TRUE 
		ELSE FALSE
	END AS lawine,
	CASE 
		WHEN sw.lawine IS TRUE
			THEN 'Lawine modelliert'
		ELSE 'Lawine nicht modelliert'
	END AS lawine_txt,
	CASE 
		WHEN sw.andere_kt IS TRUE 
			THEN TRUE 
		ELSE FALSE
	END AS andere_kt,
	CASE 
		WHEN sw.andere_kt IS TRUE
			THEN 'Schadenspotential in anderen Kantonen'
		ELSE 'Kein Schadenspotential in anderen Kantonen'
	END AS andere_kt_txt,
	sw.objektkategorie,
	osw.dispname AS objektkategorie_txt,
	sw.schadenpotential,
	sw.hauptgefahrenpotential,
	ah.dispname AS hauptgefahrenpotential_txt,
	sw.intensitaet_geschaetzt,
	ins.dispname AS intensitaet_geschaetzt_txt,
	hgg.gemeindename AS gemeinde,
	ROUND((ST_Area(wf.geometrie)/10000)::numeric,3) AS flaeche,
	sw.bemerkungen,
	wf.geometrie
FROM 
	awjf_waldplan_v2.waldplan_waldfunktion AS wf
INNER JOIN awjf_waldplan_v2.waldplan_schutzwald AS sw 
	ON wf.schutzwald_r = sw.t_id
LEFT JOIN awjf_waldplan_v2.objekte_schutzwald AS osw 
	ON sw.objektkategorie = osw.ilicode
LEFT JOIN awjf_waldplan_v2.art_hauptgefahrenpotential AS ah 
	ON sw.hauptgefahrenpotential = ah.ilicode
LEFT JOIN awjf_waldplan_v2.intensitaetsstufe AS ins 
	ON sw.intensitaet_geschaetzt = ins.ilicode
LEFT JOIN agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS hgg 
	ON wf.t_datasetname = hgg.bfs_gemeindenummer::text
LEFT JOIN awjf_waldplan_pub_v2.t_ili2db_dataset AS dataset
	ON sw.t_datasetname = dataset.datasetname
LEFT JOIN awjf_waldplan_pub_v2.t_ili2db_basket AS basket
	ON dataset.t_id = basket.dataset
WHERE 
	wf.funktion IN ('Schutzwald','Schutzwald_Biodiversitaet')
),


/*
-- Sofern nur die grösste Fläche von forstrevier berücksichtigt werden soll--
administrative_forstdaten AS (
SELECT DISTINCT ON (sw.schutzwald_nr)
	sw.schutzwald_nr,
	gs.forstkreis,
	gs.forstkreis_txt,
	gs.forstrevier,
	sw.geometrie
FROM 
	schutzwald AS sw
LEFT JOIN grundstuecke AS gs 
	ON ST_INTERSECTS(sw.geometrie, gs.geometrie)
ORDER BY 
	sw.schutzwald_nr,
	ST_Area(ST_INTERSECTION(sw.geometrie, gs.geometrie)) DESC --Es soll nur die grösste Grundstücksfläche verglichen werden
)
*/

administrative_forstdaten AS (
SELECT
	sw.schutzwald_nr,
	gs.forstkreis,
	gs.forstkreis_txt,
	STRING_AGG(DISTINCT gs.forstrevier, ', ') AS forstrevier,
	sw.geometrie
FROM 
	schutzwald AS sw
LEFT JOIN grundstuecke AS gs 
	ON ST_INTERSECTS(sw.geometrie, gs.geometrie)
WHERE
	ST_Area(ST_Intersection(sw.geometrie, gs.geometrie)) > 1
GROUP BY 
	sw.schutzwald_nr,
	gs.forstkreis,
	gs.forstkreis_txt,
	sw.geometrie
)

INSERT INTO awjf_waldplan_pub_v2.waldplan_schutzwald (
	t_basket,
	t_datasetname,
	schutzwald_nr,
	forstkreis,
	forstrevier,
	sturz,
	sturz_txt,
	rutsch,
	rutsch_txt,
	gerinnerelevante_prozesse,
	gerinnerelevante_prozesse_txt,
	lawine,
	lawine_txt,
	andere_kt,
	andere_kt_txt,
	objektkategorie,
	objektkategorie_txt,
	schadenpotential,
	hauptgefahrenpotential,
	hauptgefahrenpotential_txt,
	intensitaet_geschaetzt,
	intensitaet_geschaetzt_txt,
	gemeinde,
	flaeche,
	bemerkungen,
	geometrie
)

SELECT
	sw.t_basket,
	sw.t_datasetname,
	sw.schutzwald_nr,
	fa.forstkreis_txt AS forstkreis,
	fa.forstrevier,
	sw.sturz,
	sw.sturz_txt,
	sw.rutsch,
	sw.rutsch_txt,
	sw.gerinnerelevante_prozesse,
	sw.gerinnerelevante_prozesse_txt,
	sw.lawine,
	sw.lawine_txt,
	sw.andere_kt,
	sw.andere_kt_txt,
	sw.objektkategorie,
	sw.objektkategorie_txt,
	sw.schadenpotential,
	sw.hauptgefahrenpotential,
	sw.hauptgefahrenpotential_txt,
	sw.intensitaet_geschaetzt,
	sw.intensitaet_geschaetzt_txt,
	sw.gemeinde,
	sw.flaeche,
	sw.bemerkungen,
	sw.geometrie
FROM 
	schutzwald AS sw 
LEFT JOIN administrative_forstdaten AS fa 
	ON sw.schutzwald_nr = fa.schutzwald_nr
;