with  basket as (
    select 
        t_id,
        attachmentkey
    from 
        afu_naturgefahren_staging_v1.t_ili2db_basket
)

INSERT INTO afu_naturgefahren_staging_v1.fliessrichtung (
    t_basket,
    jaehrlichkeit, 
    fliessrichtung, 
    prozessquelle_neudaten, 
    geometrie, 
    datenherkunft, 
    auftrag_neudaten
)

SELECT 
    basket.t_id as t_basket, 
    case 
    	when wkp = 'von_0_bis_30_Jahre' then '30' 
    	when wkp = 'von_30_bis_100_Jahre' then '100' 
    	when wkp = 'von_100_bis_300_Jahre' then '300' 
    end as jaehrlichkeit, 
    fliessr as fliessrichtung, 
    null as prozessquelle_neudaten, 
    geometrie, 
    'Altdaten' as datenherkunft,
    basket.attachmentkey as auftrag_neudaten
FROM 
    afu_gefahrenkartierung.gefahrenkartirung_punktsignatur signatur,
    basket 
where 
    art = 'Fliessrichtung'
;
