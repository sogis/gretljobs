DELETE FROM awjf_waldplan_pub_v2.waldplan_waldfunktion;

WITH

waldfunktion_edit AS (
	SELECT
		basket.t_id AS t_basket,
		wf.t_datasetname,
		funktion,
		wfk.dispname AS funktion_txt,
		biodiversitaet_id,
		biodiversitaet_objekt,
		biotyp.dispname AS biodiversitaet_objekt_txt,
		sw.schutzwald_nr,
		wytweide,
		CASE 
			WHEN wytweide IS TRUE
				THEN 'Ja'
			ELSE 'Nein'
		END AS wytweide_txt,
		geometrie,
		bemerkung
	FROM 
		awjf_waldplan_v2.waldplan_waldfunktion AS wf
	LEFT JOIN awjf_waldplan_v2.waldfunktionskategorie AS wfk
		ON wf.funktion = wfk.ilicode
	LEFT JOIN awjf_waldplan_v2.biodiversitaetstyp AS biotyp
		ON wf.biodiversitaet_objekt = biotyp.ilicode
	LEFT JOIN awjf_waldplan_v2.waldplan_schutzwald AS sw 
		ON wf.schutzwald_r = sw.t_id
	LEFT JOIN awjf_waldplan_pub_v2.t_ili2db_dataset AS dataset
		ON wf.t_datasetname = dataset.datasetname
	LEFT JOIN awjf_waldplan_pub_v2.t_ili2db_basket AS basket
		ON dataset.t_id = basket.dataset
	WHERE
		wf.t_datasetname::int4 = ${bfsnr_param}
),

waldfunktion_edit_clean AS (
	SELECT 
		t_basket,
		t_datasetname,
		funktion,
		funktion_txt,
		biodiversitaet_id,
		biodiversitaet_objekt,
		biodiversitaet_objekt_txt,
		schutzwald_nr,
		wytweide,
		wytweide_txt,
		ST_RemoveRepeatedPoints(geometrie, 0.001) AS geometrie,
		bemerkung
	FROM 
		waldfunktion_edit
	WHERE 
		ST_IsValid(geometrie)
)

INSERT INTO awjf_waldplan_pub_v2.waldplan_waldfunktion(
	t_basket,
	t_datasetname,
	funktion,
	funktion_txt,
	biodiversitaet_id,
	biodiversitaet_objekt,
	biodiversitaet_objekt_txt,
	schutzwald_nr,
	wytweide,
	wytweide_txt,
	geometrie,
	bemerkung
)
SELECT
	t_basket,
	t_datasetname,
	funktion,
	funktion_txt,
	biodiversitaet_id,
	biodiversitaet_objekt,
	biodiversitaet_objekt_txt,
	schutzwald_nr,
	wytweide,
	wytweide_txt,
	geometrie,
	bemerkung
FROM 
	waldfunktion_edit_clean