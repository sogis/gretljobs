-- =========================================================
-- 1) Update Dispname-Values
-- =========================================================
UPDATE awjf_waldplan_pub_v2.waldplan_waldnutzung AS wn
SET
	 nutzungskategorie_txt = wnk.dispname
FROM 
	awjf_waldplan_pub_v2.waldnutzungskategorie AS wnk
WHERE 
	t_datasetname::int4 = ${bfsnr_param}
AND 
	wn.nutzungskategorie = wnk.ilicode
;