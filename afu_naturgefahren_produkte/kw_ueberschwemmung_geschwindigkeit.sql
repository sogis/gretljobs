delete from afu_naturgefahren_staging_v1.kennwert_ueberschwemmung_geschwindigkeit
;

with 
basket as (
    select 
        t_id 
    from 
        afu_naturgefahren_staging_v1.t_ili2db_basket
)

INSERT INTO 
    afu_naturgefahren_staging_v1.kennwert_ueberschwemmung_geschwindigkeit (
        t_basket, 
        jaehrlichkeit, 
        fliessgeschwindigkeit, 
        prozessquelle, 
        bemerkung, 
        geometrie, 
        datenherkunft, 
        auftrag_neudaten
    )

SELECT 
    basket.t_id as t_basket, 
    case 
    	when geschwindigkeit.jaehrlichkeit = 'j_30' then 30
    	when geschwindigkeit.jaehrlichkeit = 'j_100' then 100
    	when geschwindigkeit.jaehrlichkeit = 'j_300' then 300
    	when geschwindigkeit.jaehrlichkeit = 'restgefaehrdung' then -1 
    end as jaehrlichkeit,
    geschwindigkeit.v as fliessgeschwindigkeit, 
    quelle.kennung as prozessquelle, 
    geschwindigkeit.bemerkung, 
    geschwindigkeit.geometrie, 
    'Neudaten' as datenherkunft, 
    basket_orig.attachmentkey as auftrag_neudaten
FROM 
    basket,
    afu_naturgefahren_v1.kennwertueberschwemmungfliessgeschwindigkeit geschwindigkeit
left join 
    afu_naturgefahren_v1.prozessquelle quelle
    on 
    geschwindigkeit.prozessquelle_r = quelle.t_id 
left join
    afu_naturgefahren_v1.t_ili2db_basket basket_orig
    on 
    geschwindigkeit.t_basket = basket_orig.t_id 

