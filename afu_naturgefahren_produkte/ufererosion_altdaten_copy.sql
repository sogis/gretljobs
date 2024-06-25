with basket as (
    select 
        t_id,
        attachmentkey
    from 
        afu_naturgefahren_staging_v1.t_ili2db_basket
)

INSERT INTO afu_naturgefahren_staging_v1.ufererosion (
    t_basket,
    teilprozess, 
    geometrie, 
    datenherkunft, 
    auftrag_neudaten
)

SELECT 
    basket.t_id as t_basket, 
    'ufererosion' as teilprozess, 
    st_multi(geometrie) as geometrie, 
    'Altdaten' as datenherkunft, 
    NULL as auftrag_neudaten
FROM 
    afu_gefahrenkartierung.gefahrenkartirung_gk_wasser ufererosion
    ,basket 
WHERE 
    ufererosion.prozessa = 'Ufererosion'
;