with
basket as (
     select 
         t_id 
     from 
         afu_naturgefahren_staging_v1.t_ili2db_basket
)    

INSERT INTO afu_naturgefahren_staging_v1.gefahrengebiet_hauptprozess_sturz (
    t_basket, 
    hauptprozess, 
    gefahrenstufe, 
    charakterisierung, 
    geometrie, 
    datenherkunft, 
    auftrag_neudaten
)

SELECT 
    basket.t_id as t_basket,
    'sturz' as hauptprozess,
     case 
    	when gef_stufe = 'vorhanden' then 'restgefaehrdung'
    	when gef_stufe = 'gering' then 'gering'
    	when gef_stufe = 'mittel' then 'mittel' 
    	when gef_stufe = 'erheblich' then 'erheblich'
    end as gefahrenstufe, 
    replace(aindex, '_', '') as charakterisierung, 
    st_multi(geometrie) as geometrie, --Im neuen Modell sind Multi-Polygone
    'Altdaten' as datenherkunft, 
    null as auftrag_neudaten
FROM 
    afu_gefahrenkartierung.gefahrenkartirung_gk_sturz,
    basket
where 
    publiziert is true
    and 
    gef_stufe != 'keine'

