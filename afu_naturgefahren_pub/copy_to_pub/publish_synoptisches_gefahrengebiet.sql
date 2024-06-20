SELECT 
    gefahrenstufe, 
    gef_typ.dispname as gefahrenstufe_txt,
    charakterisierung, 
    geometrie
FROM 
    afu_naturgefahren_staging_v1.synoptisches_gefahrengebiet syn_gef
left join 
    afu_naturgefahren_staging_v1.gefahrenstufe_typ gef_typ 
    on 
    syn_gef.gefahrenstufe = gef_typ.ilicode 
;
