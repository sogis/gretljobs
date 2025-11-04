SELECT
	funktion,
	wfk.dispname AS funktion_txt,
	biodiversitaet_id,
	biodiversitaet_objekt,
	biotyp.dispname AS biodiversitaet_objekt_txt,
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
LEFT JOIN awjf_waldplan_v2.waldfunktionskategorie AS wfk
	ON wf.funktion = wfk.ilicode
LEFT JOIN awjf_waldplan_v2.biodiversitaetstyp AS biotyp
	ON wf.biodiversitaet_objekt = biotyp.ilicode