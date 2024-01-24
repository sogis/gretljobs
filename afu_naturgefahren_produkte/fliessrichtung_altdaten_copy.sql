with  basket as (
     select 
         t_id,
         attachmentkey
     from 
         afu_naturgefahren_staging_v1.t_ili2db_basket
 )

SELECT 
    basket.t_id as t_basket, 
    wkp as jaehrlichkeit, 
    fliessr as fliessrichtung, 
    null as prozessquelle_neudaten, 
    geometrie, 
    'Altdaten' as datenherkunft,
    basket.attachmentkey as auftrag_neudaten
FROM 
    afu_gefahrenkartierung.gefahrenkartirung_punktsignatur signatur,
    basket 
