with 
 basket as (
     select 
         t_id,
         attachmentkey
     from 
         afu_naturgefahren_staging_v1.t_ili2db_basket
 )

SELECT 
    basket.t_id as t_basket,
    tiefe.wkp as jaehrlichkeit, 
    tiefe.ueberfl_hb as ueberschwemmung_tiefe, 
    null as prozessquelle_neudaten, 
    st_multi(tiefe.geometrie) as geometrie, 
    'Altdaten' as datenherkunft,
    null as auftrag_neudaten
FROM 
    basket,
    afu_gefahrenkartierung.gefahrenkartirung_ueberflutungskarte tiefe
;

