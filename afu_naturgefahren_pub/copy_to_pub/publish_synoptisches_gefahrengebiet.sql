SELECT 
    gefahrenstufe, 
    gef_typ.dispname as gefahrenstufe_txt,
    charakterisierung, 
    geometrie,
    hauptprozess
FROM 
    afu_naturgefahren_staging_v2.synoptisches_gefahrengebiet syn_gef
LEFT JOIN
    afu_naturgefahren_staging_v2.gefahrenstufe_typ gef_typ 
    ON 
    syn_gef.gefahrenstufe = gef_typ.ilicode 
;