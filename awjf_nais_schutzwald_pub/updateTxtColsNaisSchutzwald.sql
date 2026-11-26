UPDATE 
   awjf_nais_schutzwald_pub_v1.nais_dokument AS dok
SET 
    nais_code_txt = code.dispname
FROM 
	awjf_nais_schutzwald_pub_v1.nais_nais_code AS code
WHERE 
	dok.nais_code = code.ilicode 
;