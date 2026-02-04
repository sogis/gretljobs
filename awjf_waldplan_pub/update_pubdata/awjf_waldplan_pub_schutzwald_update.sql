-- =========================================================
-- 1) Update Boolean txt-values
-- =========================================================
UPDATE awjf_waldplan_pub_v2.waldplan_schutzwald AS sw
SET
	sturz_txt = 
		CASE
			WHEN sturz = true
				THEN 'ja'
			ELSE 'nein'
		END,
	rutsch_txt =
		CASE
			WHEN rutsch = true
				THEN 'ja'
			ELSE 'nein'
		END,
	gerinnerelevante_prozesse_txt = 
		CASE
			WHEN gerinnerelevante_prozesse_txt = 'true'
				THEN 'ja'
			ELSE 'nein'
		END,
	lawine_txt = 
		CASE
			WHEN lawine = true
				THEN 'ja'
			ELSE 'nein'
		END,
	andere_kt_txt = 
		CASE
			WHEN andere_kt = true
				THEN 'ja'
			ELSE 'nein'
		END
WHERE 
	t_datasetname::int4 = ${bfsnr_param}
;

-- =========================================================
-- 2) Update Dispname-Values
-- =========================================================
UPDATE awjf_waldplan_pub_v2.waldplan_schutzwald AS sw
SET
	objektkategorie_txt = osw.dispname,
	hauptgefahrenpotential_txt = ah.dispname,
	intensitaet_geschaetzt_txt = ins.dispname
FROM
	awjf_waldplan_pub_v2.objekte_schutzwald AS osw 	
LEFT JOIN awjf_waldplan_pub_v2.art_hauptgefahrenpotential AS ah 
	ON TRUE
LEFT JOIN awjf_waldplan_pub_v2.intensitaetsstufe AS ins 
	ON TRUE
WHERE 
	t_datasetname::int4 = ${bfsnr_param}
AND 
	sw.objektkategorie = osw.ilicode
AND
	sw.hauptgefahrenpotential = ah.ilicode
AND
	sw.intensitaet_geschaetzt = ins.ilicode;
;
