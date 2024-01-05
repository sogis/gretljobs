-- ACHTUNG: NEUES DATASET UND BASKET MÜSSEN ANGELEGT WORDEN SEIN!!! 
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

teilprozess_permanentrutschung as ( 
    select 
       'r_permanente_rutschung' as teilprozess,
        case when 
             (string_to_array(iwcode, '_'))[1] = 'restgefaehrdung' then 'restgefaehrdung' 
             when
             (string_to_array(iwcode, '_'))[1] = 'gelb' then 'gering' 
             when
             (string_to_array(iwcode, '_'))[1] = 'blau' then 'mittel' 
             when
             (string_to_array(iwcode, '_'))[1] = 'rot' then 'erheblich'
        end as gefahrenstufe,
        case when 
             (string_to_array(iwcode, '_'))[2] = 'schwach' and (string_to_array(iwcode, '_'))[3] = '30' then 3
             when
             (string_to_array(iwcode, '_'))[2] = 'schwach' and (string_to_array(iwcode, '_'))[3] = '100' then 2
             when
             (string_to_array(iwcode, '_'))[2] = 'schwach' and (string_to_array(iwcode, '_'))[3] = '300' then 1
             when 
             (string_to_array(iwcode, '_'))[2] = 'mittel' and (string_to_array(iwcode, '_'))[3] = '30' then 6
             when 
             (string_to_array(iwcode, '_'))[2] = 'mittel' and (string_to_array(iwcode, '_'))[3] = '100' then 5
             when 
             (string_to_array(iwcode, '_'))[2] = 'mittel' and (string_to_array(iwcode, '_'))[3] = '300' then 4
             when 
             (string_to_array(iwcode, '_'))[2] = 'stark' and (string_to_array(iwcode, '_'))[3] = '30' then 9
             when 
             (string_to_array(iwcode, '_'))[2] = 'stark' and (string_to_array(iwcode, '_'))[3] = '100' then 8
             when 
             (string_to_array(iwcode, '_'))[2] = 'stark' and (string_to_array(iwcode, '_'))[3] = '300' then 7    
        end as charakterisierung,
        geometrie, 
        'Neudaten' as datenherkunft,
        basket.attachmentkey as auftrag_neudaten
    from 
        afu_naturgefahren_v1.befundpermanenterutschung befund 
    left join
        afu_naturgefahren_v1.t_ili2db_basket basket
        on 
        befund.t_basket = basket.t_id 
    where 
        befund.t_basket in (select t_id from orig_basket)
),

teilprozess_permanentrutschung_prio as (
    SELECT 
        a.teilprozess,
        a.jaehrlichkeit,
        a.intensitaet,
        ST_Multi(COALESCE(
            ST_Difference(a.geometrie, blade.geometrie),
            a.geometrie
        )) AS geometrie, 
        a.datenherkunft,
        a.auftrag_neudaten
    FROM  
        teilprozess_permanentrutschung AS a
    CROSS JOIN LATERAL (
        SELECT 
            ST_Union(geometrie) AS geometrie
        FROM   
            teilprozess_permanentrutschung AS b
        WHERE 
            a.geometrie && b.geometrie 
            and 
            a.prio > b.prio             
            and 
            a.jaehrlichkeit = b.jaehrlichkeit 
    ) AS blade
),

teilprozess_spontanrutschung as ( 
    select 
       'r_plo_spontane_rutschung' as teilprozess,
        case when 
            (string_to_array(iwcode, '_'))[3] ~ '^[0-9\.]+$'
            then 
                (string_to_array(iwcode, '_'))[3]
            else 
                null 
        end as jaehrlichkeit,
        (string_to_array(iwcode, '_'))[2] as intensitaet,
        geometrie, 
        'Neudaten' as datenherkunft,
        basket.attachmentkey as auftrag_neudaten,
        case when 
             (string_to_array(iwcode, '_'))[1] = 'restgefaehrdung' then 4 
             when
             (string_to_array(iwcode, '_'))[1] = 'gelb' then 3 
             when
             (string_to_array(iwcode, '_'))[1] = 'blau' then 2 
             when
             (string_to_array(iwcode, '_'))[1] = 'rot' then 1 
        end as prio
    from 
        afu_naturgefahren_v1.befundspontanerutschung befund 
    left join
        afu_naturgefahren_v1.t_ili2db_basket basket
        on 
        befund.t_basket = basket.t_id 
    where 
        befund.t_basket in (select t_id from orig_basket)
),

teilprozess_spontanrutschung_prio as (
    SELECT 
        a.teilprozess,
        a.jaehrlichkeit,
        a.intensitaet,
        ST_Multi(COALESCE(
            ST_Difference(a.geometrie, blade.geometrie),
            a.geometrie
        )) AS geometrie, 
        a.datenherkunft,
        a.auftrag_neudaten
    FROM  
        teilprozess_spontanrutschung AS a
    CROSS JOIN LATERAL (
        SELECT 
            ST_Union(geometrie) AS geometrie
        FROM   
            teilprozess_spontanrutschung AS b
        WHERE 
            a.geometrie && b.geometrie 
            and 
            a.prio > b.prio             
            and 
            a.jaehrlichkeit = b.jaehrlichkeit 
    ) AS blade
)

alle_teilprozesse as (

    select * from teilprozess_permanentrutschung_prio
    union all 
    SELECT * from teilprozess_spontanrutschung_prio
),

 basket as (
     select 
         t_id 
     from 
         afu_naturgefahren_staging_v1.t_ili2db_basket
 )

select
    basket.t_id as t_basket, 
    teilprozess,
    jaehrlichkeit::integer,
    intensitaet,
    geometrie, 
    datenherkunft,
    auftrag_neudaten
from 
    alle_teilprozesse, 
    basket
;
   



