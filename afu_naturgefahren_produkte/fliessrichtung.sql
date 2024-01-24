with 
orig_dataset as (
    select
        t_id  as dataset  
    from 
        afu_naturgefahren_v1.t_ili2db_dataset
    where 
        datasetname = ${kennung}
),

orig_basket as (
    select 
        basket.t_id 
    from 
        afu_naturgefahren_v1.t_ili2db_basket basket,
        orig_dataset
    where 
        basket.dataset = orig_dataset.dataset
        and 
        topic like '%Befunde'
),

 basket as (
     select 
         t_id,
         attachmentkey
     from 
         afu_naturgefahren_staging_v1.t_ili2db_basket
 )

SELECT 
    basket.t_id as t_basket, 
    richtung.jaehrlichkeit as jaehrlichkeit, 
    richtung.azimuth as fliessrichtung, 
    prozessquelle.kennung as prozessquelle_neudaten, 
    geometrie, 
    'Neudaten' as datenherkunft,
    basket.attachmentkey as auftrag_neudaten
FROM 
    basket,
    afu_naturgefahren_v1.fliessrichtungspfeil richtung
left join 
    afu_naturgefahren_v1.prozessquelle prozessquelle 
    on 
    richtung.prozessquelle_r = prozessquelle.t_id
where 
    richtung.t_basket in (select t_id from orig_basket)
;
    

