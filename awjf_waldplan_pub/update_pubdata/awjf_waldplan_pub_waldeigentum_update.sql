-- =========================================================
-- 1) Update Boolean txt-values
-- =========================================================
UPDATE awjf_waldplan_pub_v2.waldplan_waldplan_grundstueck
SET
	ausserkantonal_txt =
		CASE 
			WHEN ausserkantonal = TRUE
				THEN 'Ja'
			ELSE 'Nein'
		END
WHERE 
	t_datasetname::int4 = ${bfsnr_param}
;