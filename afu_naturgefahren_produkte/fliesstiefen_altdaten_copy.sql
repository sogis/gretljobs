with 
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
    	when tiefe.wkp = 'von_0_bis_30_Jahre' then '30'
    	when tiefe.wkp = 'von_30_bis_100_Jahre' then '100'
    	when tiefe.wkp = 'von_100_bis_300_Jahre' then '300'
    end as jaehrlichkeit,  
    tiefe.ueberfl_hb as ueberschwemmung_tiefe, 
    null as prozessquelle_neudaten, 
    st_multi(tiefe.geometrie) as geometrie, 
    'Altdaten' as datenherkunft,
    null as auftrag_neudaten
FROM 
    basket,
    afu_gefahrenkartierung.gefahrenkartirung_ueberflutungskarte tiefe
;



select distinct wkp from afu_gefahrenkartierung.gefahrenkartirung_ueberflutungskarte