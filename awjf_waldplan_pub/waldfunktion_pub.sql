SELECT
	funktion,
	typ_wf.dispname AS funktion_txt,
	biodiversitaet_id,
	biodiversitaet_objekt,
	typ_bio.dispname AS biodiversitaet_objekt_txt,
	--schutzwald_nr, --Zuteilung Schutzwald-Nr. vorher notwendig
	wytweide,
	CASE 
		WHEN wytweide IS TRUE
			THEN 'Wytweidefläche vorhanden'
		ELSE 'keine Wytweidefläche vorhanden'
	END AS wytweide_txt,
	geometrie,
	bemerkung
FROM 
	awjf_waldplan_v2.waldplan_waldfunktion AS wf
LEFT JOIN awjf_waldplan_v2.typ_waldfunktion AS typ_wf 
	ON wf.funktion = typ_wf.ilicode
LEFT JOIN awjf_waldplan_v2.typ_biodiversitaet typ_bio 
	ON wf.biodiversitaet_objekt = typ_bio.ilicode