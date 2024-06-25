delete from afu_naturgefahren_staging_v1.fliesstiefen 
;

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

INSERT INTO afu_naturgefahren_staging_v1.fliesstiefen (
    t_basket, 
    jaehrlichkeit, 
    ueberschwemmung_tiefe, 
    prozessquelle_neudaten, 
    geometrie, 
    datenherkunft, 
    auftrag_neudaten
)

SELECT 
    basket.t_id as t_basket,
    case 
    	when tiefe.jaehrlichkeit = 'j_30' then '30'
    	when tiefe.jaehrlichkeit = 'j_100' then '100'
    	when tiefe.jaehrlichkeit = 'j_300' then '300'
    	when tiefe.jaehrlichkeit = 'restgefaehrdung' then '-1' 
    end as jaehrlichkeit,  
    case 
    	when h = 'von_0_bis_25_cm' then 'von_0_bis_25cm'
    	when h = 'von_25_bis_50_cm' then 'von_25_bis_50cm' 
    	when h = 'von_50_bis_75_cm' then 'von_50_bis_75cm' 
    	when h = 'von_75_bis_100_cm' then 'von_75_bis_100cm'
    	when h = 'von_100_bis_125_cm' then 'von_100_bis_200cm'
    	when h = 'von_125_bis_150_cm' then 'von_100_bis_200cm'
    	when h = 'von_150_bis_175_cm' then 'von_100_bis_200cm'
    	when h = 'von_175_bis_200_cm' then 'von_100_bis_200cm'
    	when h = 'von_200_bis_300_cm' then 'groesser_200cm'
    	when h = 'von_300_bis_400_cm' then 'groesser_200cm'
    	else 'BERECHNUNGSFEHLER' 
    end as ueberschwemmung_tiefe, 
    prozessquelle.kennung as prozessquelle_neudaten, 
    st_multi(geometrie) as geometrie, 
    'Neudaten' as datenherkunft,
    basket.attachmentkey as auftrag_neudaten
FROM 
    basket,
    afu_naturgefahren_v1.kennwertueberschwemmungfliesstiefe tiefe
left join 
    afu_naturgefahren_v1.prozessquelle prozessquelle 
    on 
    tiefe.prozessquelle_r = prozessquelle.t_id
where 
    tiefe.t_basket in (select t_id from orig_basket)
;
