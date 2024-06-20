delete from afu_naturgefahren_staging_v1.kennwert_uebermurung_hoehe 
;

with 
basket as (
    select 
        t_id 
    from 
        afu_naturgefahren_staging_v1.t_ili2db_basket
)

INSERT INTO 
    afu_naturgefahren_staging_v1.kennwert_uebermurung_hoehe (
        t_basket, 
        jaehrlichkeit, 
        uebermurungshoehe, 
        prozessquelle, 
        bemerkung, 
        geometrie, 
        datenherkunft, 
        auftrag_neudaten
    )

SELECT 
    basket.t_id as t_basket, 
    case 
    	when hoehe.jaehrlichkeit = 'J_30' then 30
    	when hoehe.jaehrlichkeit = 'J_100' then 100
    	when hoehe.jaehrlichkeit = 'J_300' then 300
    	when hoehe.jaehrlichkeit = 'Restgefaehrdung' then -1 
    end as jaehrlichkeit,
    hoehe.h as fliesshoehe, 
    quelle.kennung as prozessquelle, 
    hoehe.bemerkung, 
    hoehe.geometrie, 
    'Neudaten' as datenherkunft, 
    basket_orig.attachmentkey as auftrag_neudaten
FROM 
    basket,
    afu_naturgefahren_v1.kennwertuebermurungfliesstiefe hoehe
left join 
    afu_naturgefahren_v1.prozessquelle quelle
    on 
    hoehe.prozessquelle_r = quelle.t_id 
left join
    afu_naturgefahren_v1.t_ili2db_basket basket_orig
    on 
    hoehe.t_basket = basket_orig.t_id 
