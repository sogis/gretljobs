with 
basket as (
    select 
        t_id 
    from 
        afu_naturgefahren_staging_v1.t_ili2db_basket
),

teilprozess_absenkung as ( 
    select 
       'ea_absenkung' as teilprozess,
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
             (string_to_array(iwcode, '_'))[1] = 'gelb' then 3 
             when
             (string_to_array(iwcode, '_'))[1] = 'blau' then 2 
             when
             (string_to_array(iwcode, '_'))[1] = 'rot' then 1 
        end as prio
    from 
        afu_naturgefahren_v1.befundabsenkung befund 
    left join
        afu_naturgefahren_v1.t_ili2db_basket basket
        on 
        befund.t_basket = basket.t_id    
),

teilprozess_absenkung_prio as (
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
        teilprozess_absenkung AS a
    CROSS JOIN LATERAL (
        SELECT 
            ST_Union(geometrie) AS geometrie
        FROM   
            teilprozess_absenkung AS b
        WHERE 
            a.geometrie && b.geometrie 
            and 
            a.prio > b.prio
            and 
            a.jaehrlichkeit = b.jaehrlichkeit 
    ) AS blade
),

teilprozess_bergundfelssturz as ( 
    select 
       's_fels_berg_sturz' as teilprozess,
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
             (string_to_array(iwcode, '_'))[1] = 'gelb' then 3 
             when
             (string_to_array(iwcode, '_'))[1] = 'blau' then 2 
             when
             (string_to_array(iwcode, '_'))[1] = 'rot' then 1 
        end as prio
    from 
        afu_naturgefahren_v1.befundbergfelssturz befund 
    left join
        afu_naturgefahren_v1.t_ili2db_basket basket
        on 
        befund.t_basket = basket.t_id 
),

teilprozess_bergundfelssturz_prio as (
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
        teilprozess_bergundfelssturz AS a
    CROSS JOIN LATERAL (
        SELECT 
            ST_Union(geometrie) AS geometrie
        FROM   
            teilprozess_bergundfelssturz AS b
        WHERE 
            a.geometrie && b.geometrie 
            and 
            a.prio > b.prio             
            and 
            a.jaehrlichkeit = b.jaehrlichkeit 
    ) AS blade
),

teilprozess_einsturz as ( 
    select 
       'ea_einsturz' as teilprozess,
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
             (string_to_array(iwcode, '_'))[1] = 'gelb' then 3 
             when
             (string_to_array(iwcode, '_'))[1] = 'blau' then 2 
             when
             (string_to_array(iwcode, '_'))[1] = 'rot' then 1 
        end as prio
    from 
        afu_naturgefahren_v1.befundeinsturz befund 
    left join
        afu_naturgefahren_v1.t_ili2db_basket basket
        on 
        befund.t_basket = basket.t_id 
),

teilprozess_einsturz_prio as (
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
        teilprozess_einsturz AS a
    CROSS JOIN LATERAL (
        SELECT 
            ST_Union(geometrie) AS geometrie
        FROM   
            teilprozess_einsturz AS b
        WHERE 
            a.geometrie && b.geometrie 
            and 
            a.prio > b.prio             
            and 
            a.jaehrlichkeit = b.jaehrlichkeit 
    ) AS blade
),

teilprozess_eisschlag as ( 
    select 
       's_eisschlag' as teilprozess,
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
             (string_to_array(iwcode, '_'))[1] = 'gelb' then 3 
             when
             (string_to_array(iwcode, '_'))[1] = 'blau' then 2 
             when
             (string_to_array(iwcode, '_'))[1] = 'rot' then 1 
        end as prio
    from 
        afu_naturgefahren_v1.befundeisschlag befund 
    left join
        afu_naturgefahren_v1.t_ili2db_basket basket
        on 
        befund.t_basket = basket.t_id 
),

teilprozess_eisschlag_prio as (
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
        teilprozess_eisschlag AS a
    CROSS JOIN LATERAL (
        SELECT 
            ST_Union(geometrie) AS geometrie
        FROM   
            teilprozess_eisschlag AS b
        WHERE 
            a.geometrie && b.geometrie 
            and 
            a.prio > b.prio             
            and 
            a.jaehrlichkeit = b.jaehrlichkeit 
    ) AS blade
),

teilprozess_hangmure as ( 
    select 
       'r_plo_hangmure' as teilprozess,
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
             (string_to_array(iwcode, '_'))[1] = 'gelb' then 3 
             when
             (string_to_array(iwcode, '_'))[1] = 'blau' then 2 
             when
             (string_to_array(iwcode, '_'))[1] = 'rot' then 1 
        end as prio
    from 
        afu_naturgefahren_v1.befundhangmure befund 
    left join
        afu_naturgefahren_v1.t_ili2db_basket basket
        on 
        befund.t_basket = basket.t_id 
),

teilprozess_hangmure_prio as (
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
        teilprozess_hangmure AS a
    CROSS JOIN LATERAL (
        SELECT 
            ST_Union(geometrie) AS geometrie
        FROM   
            teilprozess_hangmure AS b
        WHERE 
            a.geometrie && b.geometrie 
            and 
            a.prio > b.prio             
            and 
            a.jaehrlichkeit = b.jaehrlichkeit 
    ) AS blade
),

teilprozess_permanentrutschung as ( 
    select 
       'r_permanente_rutschung' as teilprozess,
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
             (string_to_array(iwcode, '_'))[1] = 'gelb' then 3 
             when
             (string_to_array(iwcode, '_'))[1] = 'blau' then 2 
             when
             (string_to_array(iwcode, '_'))[1] = 'rot' then 1 
        end as prio
    from 
        afu_naturgefahren_v1.befundpermanenterutschung befund 
    left join
        afu_naturgefahren_v1.t_ili2db_basket basket
        on 
        befund.t_basket = basket.t_id 
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
),

teilprozess_steinblockschlag as ( 
    select 
       's_stein_block_schlag' as teilprozess,
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
             (string_to_array(iwcode, '_'))[1] = 'gelb' then 3 
             when
             (string_to_array(iwcode, '_'))[1] = 'blau' then 2 
             when
             (string_to_array(iwcode, '_'))[1] = 'rot' then 1 
        end as prio
    from 
        afu_naturgefahren_v1.befundsteinblockschlag befund 
    left join
        afu_naturgefahren_v1.t_ili2db_basket basket
        on 
        befund.t_basket = basket.t_id 
),

teilprozess_steinblockschlag_prio as (
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
        teilprozess_steinblockschlag AS a
    CROSS JOIN LATERAL (
        SELECT 
            ST_Union(geometrie) AS geometrie
        FROM   
            teilprozess_steinblockschlag AS b
        WHERE 
            a.geometrie && b.geometrie 
            and 
            a.prio > b.prio             
            and 
            a.jaehrlichkeit = b.jaehrlichkeit 
    ) AS blade
),

teilprozess_uebermurung as ( 
    select 
       'w_uebermurung' as teilprozess,
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
             (string_to_array(iwcode, '_'))[1] = 'gelb' then 3 
             when
             (string_to_array(iwcode, '_'))[1] = 'blau' then 2 
             when
             (string_to_array(iwcode, '_'))[1] = 'rot' then 1 
        end as prio
    from 
        afu_naturgefahren_v1.befunduebermurung befund 
    left join
        afu_naturgefahren_v1.t_ili2db_basket basket
        on 
        befund.t_basket = basket.t_id 
),

teilprozess_uebermurung_prio as (
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
        teilprozess_uebermurung AS a
    CROSS JOIN LATERAL (
        SELECT 
            ST_Union(geometrie) AS geometrie
        FROM   
            teilprozess_uebermurung AS b
        WHERE 
            a.geometrie && b.geometrie 
            and 
            a.prio > b.prio             
            and 
            a.jaehrlichkeit = b.jaehrlichkeit 
    ) AS blade
),

teilprozess_ueberschwemmungdynamisch as ( 
    select 
       'w_ueberschwemmung' as teilprozess,
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
             (string_to_array(iwcode, '_'))[1] = 'gelb' then 3 
             when
             (string_to_array(iwcode, '_'))[1] = 'blau' then 2 
             when
             (string_to_array(iwcode, '_'))[1] = 'rot' then 1 
        end as prio
    from 
        afu_naturgefahren_v1.befundueberschwemmungdynamisch befund 
    left join
        afu_naturgefahren_v1.t_ili2db_basket basket
        on 
        befund.t_basket = basket.t_id 
),

teilprozess_ueberschwemmungdynamisch_prio as (
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
        teilprozess_ueberschwemmungdynamisch AS a
    CROSS JOIN LATERAL (
        SELECT 
            ST_Union(geometrie) AS geometrie
        FROM   
            teilprozess_ueberschwemmungdynamisch AS b
        WHERE 
            a.geometrie && b.geometrie 
            and 
            a.prio > b.prio             
            and 
            a.jaehrlichkeit = b.jaehrlichkeit 
    ) AS blade
),

teilprozess_ueberschwemmungstatisch as ( 
    select 
       'w_ueberschwemmung' as teilprozess,
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
             (string_to_array(iwcode, '_'))[1] = 'gelb' then 3 
             when
             (string_to_array(iwcode, '_'))[1] = 'blau' then 2 
             when
             (string_to_array(iwcode, '_'))[1] = 'rot' then 1 
        end as prio
    from 
        afu_naturgefahren_v1.befundueberschwemmungstatisch befund 
    left join
        afu_naturgefahren_v1.t_ili2db_basket basket
        on 
        befund.t_basket = basket.t_id 
), 

teilprozess_ueberschwemmungstatisch_prio as (
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
        teilprozess_ueberschwemmungstatisch AS a
    CROSS JOIN LATERAL (
        SELECT 
            ST_Union(geometrie) AS geometrie
        FROM   
            teilprozess_ueberschwemmungstatisch AS b
        WHERE 
            a.geometrie && b.geometrie 
            and 
            a.prio > b.prio             
            and 
            a.jaehrlichkeit = b.jaehrlichkeit 
    ) AS blade
),

alle_teilprozesse as (
    select * from teilprozess_absenkung_prio
    union all 
    select * from teilprozess_bergundfelssturz_prio
    union all 
    select * from teilprozess_einsturz_prio
    union all 
    select * from teilprozess_eisschlag_prio
    union  all
    select * from teilprozess_hangmure_prio
    union all 
    select * from teilprozess_permanentrutschung_prio
    union all 
    SELECT * from teilprozess_spontanrutschung_prio
    union all 
    select * from teilprozess_steinblockschlag_prio
    union all 
    select * from teilprozess_uebermurung_prio
    union all 
    select * from teilprozess_ueberschwemmungdynamisch_prio
    union all 
    select * from teilprozess_ueberschwemmungstatisch_prio
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
   

