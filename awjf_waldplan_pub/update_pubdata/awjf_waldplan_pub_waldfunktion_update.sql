-- =========================================================
-- 1) Update Boolean txt-values
-- =========================================================
UPDATE awjf_waldplan_pub_v2.waldplan_waldfunktion AS wf
SET
	wytweide_txt =
		CASE 
			WHEN wytweide = TRUE
				THEN 'Ja'
			ELSE 'Nein'
		END
WHERE 
	t_datasetname::int4 = ${bfsnr_param}
;

-- =========================================================
-- 2) Update Dispname-Values
-- =========================================================
UPDATE awjf_waldplan_pub_v2.waldplan_waldfunktion AS wf
SET
	 funktion_txt = wfk.dispname,
	 biodiversitaet_objekt_txt = biotyp.dispname
FROM 
	awjf_waldplan_pub_v2.waldfunktionskategorie AS wfk
LEFT JOIN awjf_waldplan_pub_v2.biodiversitaetstyp AS biotyp
	ON TRUE 
WHERE 
	t_datasetname::int4 = ${bfsnr_param}
AND 
	wf.funktion = wfk.ilicode
AND 
	wf.biodiversitaet_objekt = biotyp.ilicode
;

