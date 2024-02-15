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
    wkp as jaehrlichkeit, 
    fliessr as fliessrichtung, 
    null as prozessquelle_neudaten, 
    geometrie, 
    'Altdaten' as datenherkunft,
    basket.attachmentkey as auftrag_neudaten
FROM 
    afu_gefahrenkartierung.gefahrenkartirung_punktsignatur signatur,
    basket 
;