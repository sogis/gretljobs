-- ACHTUNG: NEUES DATASET UND BASKET MÜSSEN ANGELEGT WORDEN SEIN!!! 

delete from afu_naturgefahren_staging_v1.synoptische_intensitaet
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

teilprozess_absenkung as ( 
    select 
       'absenkung' as teilprozess,
        '-1' as jaehrlichkeit,
        (string_to_array(iwcode, '_'))[2] as intensitaet,
        geometrie, 
        case when 
             (string_to_array(iwcode, '_'))[1] = 'restgefaehrdung' then 1 
             when
             (string_to_array(iwcode, '_'))[1] = 'gelb' then 2 
             when
             (string_to_array(iwcode, '_'))[1] = 'blau' then 3 
             when
             (string_to_array(iwcode, '_'))[1] = 'rot' then 4 
        end as prio
    from 
        afu_naturgefahren_v1.befundabsenkung befund 
    where 
        befund.t_basket in (select t_id from orig_basket)
    union all 
    SELECT
        'absenkung' as teilprozess,
        null as jaehrlichkeit,  --Bei diesem Teilprozess gibt es keine Jährlichkeit
        'keine_einwirkung' as intensitaet,
        geometrie,
        0 as prio
    from
        afu_naturgefahren_v1.abklaerungsperimeter
    where 
        ea_absenkung != 'nicht_beurteilt'
),

teilprozess_absenkung_prio as (
    SELECT 
        a.teilprozess,
        a.jaehrlichkeit,
        a.intensitaet,
        ST_Multi(COALESCE(
            ST_Difference(a.geometrie, blade.geometrie),
            a.geometrie
        )) AS geometrie
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
            a.prio < b.prio
            and 
            a.jaehrlichkeit = b.jaehrlichkeit 
    ) AS blade
),

teilprozess_bergundfelssturz as ( 
    select 
       'fels_bergsturz' as teilprozess,
        case when 
            (string_to_array(iwcode, '_'))[3] ~ '^[0-9\.]+$'
            then 
                (string_to_array(iwcode, '_'))[3]
            else 
                '-1' 
        end as jaehrlichkeit,
        (string_to_array(iwcode, '_'))[2] as intensitaet,
        geometrie, 
        case when 
             (string_to_array(iwcode, '_'))[1] = 'restgefaehrdung' then 1 
             when
             (string_to_array(iwcode, '_'))[1] = 'gelb' then 2 
             when
             (string_to_array(iwcode, '_'))[1] = 'blau' then 3 
             when
             (string_to_array(iwcode, '_'))[1] = 'rot' then 4 
        end as prio
    from 
        afu_naturgefahren_v1.befundbergfelssturz befund 
    where 
        befund.t_basket in (select t_id from orig_basket)
    union all 
    SELECT
        'fels_bergsturz' as teilprozess,
        '30' as jaehrlichkeit,
        'keine_einwirkung' as intensitaet,
        geometrie,
        0 as prio
    from
        afu_naturgefahren_v1.abklaerungsperimeter
    where 
        s_berg_felssturz != 'nicht_beurteilt'
    union all 
    SELECT
        'fels_bergsturz' as teilprozess,
        '100' as jaehrlichkeit,
        'keine_einwirkung' as intensitaet,
        geometrie,
        0 as prio
    from
        afu_naturgefahren_v1.abklaerungsperimeter
    where 
        s_berg_felssturz != 'nicht_beurteilt'
    union all 
    SELECT
        'fels_bergsturz' as teilprozess,
        '300' as jaehrlichkeit,
        'keine_einwirkung' as intensitaet,
        geometrie,
        0 as prio
    from
        afu_naturgefahren_v1.abklaerungsperimeter
    where 
        s_berg_felssturz != 'nicht_beurteilt'
    union all 
    SELECT
        'fels_bergsturz' as teilprozess,
        '-1' as jaehrlichkeit, --für die Restgefährdung
        'keine_einwirkung' as intensitaet,
        geometrie,
        0 as prio
    from
        afu_naturgefahren_v1.abklaerungsperimeter
    where 
        s_berg_felssturz != 'nicht_beurteilt'
),

teilprozess_bergundfelssturz_prio as (
    SELECT 
        a.teilprozess,
        a.jaehrlichkeit,
        a.intensitaet,
        ST_Multi(COALESCE(
            ST_Difference(a.geometrie, blade.geometrie),
            a.geometrie
        )) AS geometrie
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
            a.prio < b.prio             
            and 
            a.jaehrlichkeit = b.jaehrlichkeit 
    ) AS blade
),

teilprozess_einsturz as ( 
    select 
       'einsturz' as teilprozess,
        '-1' as jaehrlichkeit,
        (string_to_array(iwcode, '_'))[2] as intensitaet,
        geometrie,
        case when 
             (string_to_array(iwcode, '_'))[1] = 'restgefaehrdung' then 1 
             when
             (string_to_array(iwcode, '_'))[1] = 'gelb' then 2 
             when
             (string_to_array(iwcode, '_'))[1] = 'blau' then 3 
             when
             (string_to_array(iwcode, '_'))[1] = 'rot' then 4 
        end as prio
    from 
        afu_naturgefahren_v1.befundeinsturz befund 
    where 
        befund.t_basket in (select t_id from orig_basket)
    union all 
    SELECT
        'einsturz' as teilprozess,
        null as jaehrlichkeit, --Bei diesem Teilprozess gibt es keine Jährlichkeit
        'keine_einwirkung' as intensitaet,
        geometrie,
        0 as prio
    from
        afu_naturgefahren_v1.abklaerungsperimeter
    where 
        ea_einsturz != 'nicht_beurteilt'
),

teilprozess_einsturz_prio as (
    SELECT 
        a.teilprozess,
        a.jaehrlichkeit,
        a.intensitaet,
        ST_Multi(COALESCE(
            ST_Difference(a.geometrie, blade.geometrie),
            a.geometrie
        )) AS geometrie
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
            a.prio < b.prio             
            and 
            a.jaehrlichkeit = b.jaehrlichkeit 
    ) AS blade
),

teilprozess_hangmure as ( 
    select 
       'hangmure' as teilprozess,
        case when 
            (string_to_array(iwcode, '_'))[3] ~ '^[0-9\.]+$'
            then 
                (string_to_array(iwcode, '_'))[3]
            else 
                '-1' 
        end as jaehrlichkeit,
        (string_to_array(iwcode, '_'))[2] as intensitaet,
        geometrie, 
        case when 
             (string_to_array(iwcode, '_'))[1] = 'restgefaehrdung' then 1 
             when
             (string_to_array(iwcode, '_'))[1] = 'gelb' then 2 
             when
             (string_to_array(iwcode, '_'))[1] = 'blau' then 3 
             when
             (string_to_array(iwcode, '_'))[1] = 'rot' then 4 
        end as prio
    from 
        afu_naturgefahren_v1.befundhangmure befund 
    where 
        befund.t_basket in (select t_id from orig_basket)
    union all 
    SELECT
        'hangmure' as teilprozess,
        '30' as jaehrlichkeit, 
        'keine_einwirkung' as intensitaet,
        geometrie,
        0 as prio
    from
        afu_naturgefahren_v1.abklaerungsperimeter
    where 
        r_hangmure != 'nicht_beurteilt'
    union all 
    SELECT
        'hangmure' as teilprozess,
        '100' as jaehrlichkeit, 
        'keine_einwirkung' as intensitaet,
        geometrie,
        0 as prio
    from
        afu_naturgefahren_v1.abklaerungsperimeter
    where 
        r_hangmure != 'nicht_beurteilt'
    union all 
    SELECT
        'hangmure' as teilprozess,
        '300' as jaehrlichkeit, 
        'keine_einwirkung' as intensitaet,
        geometrie,
        0 as prio
    from
        afu_naturgefahren_v1.abklaerungsperimeter
    where 
        r_hangmure != 'nicht_beurteilt'
),

teilprozess_hangmure_prio as (
    SELECT 
        a.teilprozess,
        a.jaehrlichkeit,
        a.intensitaet,
        ST_Multi(COALESCE(
            ST_Difference(a.geometrie, blade.geometrie),
            a.geometrie
        )) AS geometrie
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
            a.prio < b.prio             
            and 
            a.jaehrlichkeit = b.jaehrlichkeit 
    ) AS blade
),

teilprozess_permanentrutschung as ( 
    select 
       'permanente_rutschung' as teilprozess,
        '-1' as jaehrlichkeit,
        (string_to_array(iwcode, '_'))[2] as intensitaet,
        geometrie, 
        case when 
             (string_to_array(iwcode, '_'))[1] = 'restgefaehrdung' then 1 
             when
             (string_to_array(iwcode, '_'))[1] = 'gelb' then 2 
             when
             (string_to_array(iwcode, '_'))[1] = 'blau' then 3 
             when
             (string_to_array(iwcode, '_'))[1] = 'rot' then 4 
        end as prio
    from 
        afu_naturgefahren_v1.befundpermanenterutschung befund
    where 
        befund.t_basket in (select t_id from orig_basket)
    union all 
    SELECT
        'permanente_rutschung' as teilprozess,
        null as jaehrlichkeit, --Bei diesem Teilprozess gibt es keine Jährlichkeiten
        'keine_einwirkung' as intensitaet,
        geometrie,
        0 as prio
    from
        afu_naturgefahren_v1.abklaerungsperimeter
    where 
        r_permanente_rutschung != 'nicht_beurteilt'
),

teilprozess_permanentrutschung_prio as (
    SELECT 
        a.teilprozess,
        a.jaehrlichkeit,
        a.intensitaet,
        ST_Multi(COALESCE(
            ST_Difference(a.geometrie, blade.geometrie),
            a.geometrie
        )) AS geometrie
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
            a.prio < b.prio             
            and 
            a.jaehrlichkeit = b.jaehrlichkeit 
    ) AS blade
),

teilprozess_spontanrutschung as ( 
    select 
       'spontane_rutschung' as teilprozess,
        case when 
            (string_to_array(iwcode, '_'))[3] ~ '^[0-9\.]+$'
            then 
                (string_to_array(iwcode, '_'))[3]
            else 
                '-1' 
        end as jaehrlichkeit,
        (string_to_array(iwcode, '_'))[2] as intensitaet,
        geometrie, 
        case when 
             (string_to_array(iwcode, '_'))[1] = 'restgefaehrdung' then 1 
             when
             (string_to_array(iwcode, '_'))[1] = 'gelb' then 2 
             when
             (string_to_array(iwcode, '_'))[1] = 'blau' then 3 
             when
             (string_to_array(iwcode, '_'))[1] = 'rot' then 4 
        end as prio
    from 
        afu_naturgefahren_v1.befundspontanerutschung befund 
    left join
        afu_naturgefahren_v1.t_ili2db_basket basket
        on 
        befund.t_basket = basket.t_id 
    where 
        befund.t_basket in (select t_id from orig_basket)
    union all 
    SELECT
        'spontane_rutschung' as teilprozess,
        '30' as jaehrlichkeit, 
        'keine_einwirkung' as intensitaet,
        geometrie,
        0 as prio
    from
        afu_naturgefahren_v1.abklaerungsperimeter
    where 
        r_spontane_rutschung != 'nicht_beurteilt'
    union all 
    SELECT
        'spontane_rutschung' as teilprozess,
        '100' as jaehrlichkeit, 
        'keine_einwirkung' as intensitaet,
        geometrie,
        0 as prio
    from
        afu_naturgefahren_v1.abklaerungsperimeter
    where 
        r_spontane_rutschung != 'nicht_beurteilt'
    union all 
    SELECT
        'spontane_rutschung' as teilprozess,
        '300' as jaehrlichkeit, 
        'keine_einwirkung' as intensitaet,
        geometrie,
        0 as prio
    from
        afu_naturgefahren_v1.abklaerungsperimeter
    where 
        r_spontane_rutschung != 'nicht_beurteilt'
),

teilprozess_spontanrutschung_prio as (
    SELECT 
        a.teilprozess,
        a.jaehrlichkeit,
        a.intensitaet,
        ST_Multi(COALESCE(
            ST_Difference(a.geometrie, blade.geometrie),
            a.geometrie
        )) AS geometrie
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
            a.prio < b.prio             
            and 
            a.jaehrlichkeit = b.jaehrlichkeit 
    ) AS blade
),

teilprozess_steinblockschlag as ( 
    select 
       'stein_blockschlag' as teilprozess,
        case when 
            (string_to_array(iwcode, '_'))[3] ~ '^[0-9\.]+$'
            then 
                (string_to_array(iwcode, '_'))[3]
            else 
                '-1' 
        end as jaehrlichkeit,
        (string_to_array(iwcode, '_'))[2] as intensitaet,
        geometrie, 
        case when 
             (string_to_array(iwcode, '_'))[1] = 'restgefaehrdung' then 1 
             when
             (string_to_array(iwcode, '_'))[1] = 'gelb' then 2 
             when
             (string_to_array(iwcode, '_'))[1] = 'blau' then 3 
             when
             (string_to_array(iwcode, '_'))[1] = 'rot' then 4 
        end as prio
    from 
        afu_naturgefahren_v1.befundsteinblockschlag befund 
    where 
        befund.t_basket in (select t_id from orig_basket)
    union all 
    SELECT
        'stein_blockschlag' as teilprozess,
        '30' as jaehrlichkeit, 
        'keine_einwirkung' as intensitaet,
        geometrie,
        0 as prio
    from
        afu_naturgefahren_v1.abklaerungsperimeter
    where 
        s_stein_blockschlag != 'nicht_beurteilt'
    union all 
    SELECT
        'stein_blockschlag' as teilprozess,
        '100' as jaehrlichkeit, 
        'keine_einwirkung' as intensitaet,
        geometrie,
        0 as prio
    from
        afu_naturgefahren_v1.abklaerungsperimeter
    where 
        s_stein_blockschlag != 'nicht_beurteilt'
    union all 
    SELECT
        'stein_blockschlag' as teilprozess,
        '300' as jaehrlichkeit, 
        'keine_einwirkung' as intensitaet,
        geometrie,
        0 as prio
    from
        afu_naturgefahren_v1.abklaerungsperimeter
    where 
        s_stein_blockschlag != 'nicht_beurteilt'
    union all 
    SELECT
        'stein_blockschlag' as teilprozess,
        '-1' as jaehrlichkeit, 
        'keine_einwirkung' as intensitaet,
        geometrie,
        0 as prio
    from
        afu_naturgefahren_v1.abklaerungsperimeter
    where 
        s_stein_blockschlag != 'nicht_beurteilt'
),

teilprozess_steinblockschlag_prio as (
    SELECT 
        a.teilprozess,
        a.jaehrlichkeit,
        a.intensitaet,
        ST_Multi(COALESCE(
            ST_Difference(a.geometrie, blade.geometrie),
            a.geometrie
        )) AS geometrie
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
            a.prio < b.prio             
            and 
            a.jaehrlichkeit = b.jaehrlichkeit 
    ) AS blade
),

teilprozess_uebermurung as ( 
    select 
       'uebermurung' as teilprozess,
        case when 
            (string_to_array(iwcode, '_'))[3] ~ '^[0-9\.]+$'
            then 
                (string_to_array(iwcode, '_'))[3]
            else 
                '-1' 
        end as jaehrlichkeit,
        (string_to_array(iwcode, '_'))[2] as intensitaet,
        geometrie, 
        case when 
             (string_to_array(iwcode, '_'))[1] = 'restgefaehrdung' then 1 
             when
             (string_to_array(iwcode, '_'))[1] = 'gelb' then 2 
             when
             (string_to_array(iwcode, '_'))[1] = 'blau' then 3 
             when
             (string_to_array(iwcode, '_'))[1] = 'rot' then 4 
        end as prio
    from 
        afu_naturgefahren_v1.befunduebermurung befund 
    where 
        befund.t_basket in (select t_id from orig_basket)
    union all 
    SELECT
        'uebermurung' as teilprozess,
        '30' as jaehrlichkeit, 
        'keine_einwirkung' as intensitaet,
        geometrie,
        0 as prio
    from
        afu_naturgefahren_v1.abklaerungsperimeter
    where 
        w_uebermurung != 'nicht_beurteilt'
    union all 
    SELECT
        'uebermurung' as teilprozess,
        '100' as jaehrlichkeit, 
        'keine_einwirkung' as intensitaet,
        geometrie,
        0 as prio
    from
        afu_naturgefahren_v1.abklaerungsperimeter
    where 
        w_uebermurung != 'nicht_beurteilt'
    union all 
    SELECT
        'uebermurung' as teilprozess,
        '300' as jaehrlichkeit, 
        'keine_einwirkung' as intensitaet,
        geometrie,
        0 as prio
    from
        afu_naturgefahren_v1.abklaerungsperimeter
    where 
        w_uebermurung != 'nicht_beurteilt'
    union all 
    SELECT
        'uebermurung' as teilprozess,
        '-1' as jaehrlichkeit, 
        'keine_einwirkung' as intensitaet,
        geometrie,
        0 as prio
    from
        afu_naturgefahren_v1.abklaerungsperimeter
    where 
        w_uebermurung != 'nicht_beurteilt'
),

teilprozess_uebermurung_prio as (
    SELECT 
        a.teilprozess,
        a.jaehrlichkeit,
        a.intensitaet,
        ST_Multi(COALESCE(
            ST_Difference(a.geometrie, blade.geometrie),
            a.geometrie
        )) AS geometrie
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
            a.prio < b.prio             
            and 
            a.jaehrlichkeit = b.jaehrlichkeit 
    ) AS blade
),

teilprozess_ueberschwemmung as ( 
    select 
       'ueberschwemmung' as teilprozess,
        case when 
            (string_to_array(iwcode, '_'))[3] ~ '^[0-9\.]+$'
            then 
                (string_to_array(iwcode, '_'))[3]
            else 
                '-1' 
        end as jaehrlichkeit,
        (string_to_array(iwcode, '_'))[2] as intensitaet,
        geometrie, 
        case when 
             (string_to_array(iwcode, '_'))[1] = 'restgefaehrdung' then 1 
             when
             (string_to_array(iwcode, '_'))[1] = 'gelb' then 2 
             when
             (string_to_array(iwcode, '_'))[1] = 'blau' then 3 
             when
             (string_to_array(iwcode, '_'))[1] = 'rot' then 4 
        end as prio
    from 
        afu_naturgefahren_v1.befundueberschwemmungdynamisch befund 
    where 
        befund.t_basket in (select t_id from orig_basket)
    
    union all -- Dynamische und Statische Überschwemmungen werden zusammengefasst.
    
    select 
       'ueberschwemmung' as teilprozess,
        case when 
            (string_to_array(iwcode, '_'))[3] ~ '^[0-9\.]+$'
            then 
                (string_to_array(iwcode, '_'))[3]
            else 
                '-1' 
        end as jaehrlichkeit,
        (string_to_array(iwcode, '_'))[2] as intensitaet,
        geometrie, 
        case when 
             (string_to_array(iwcode, '_'))[1] = 'restgefaehrdung' then 1 
             when
             (string_to_array(iwcode, '_'))[1] = 'gelb' then 2 
             when
             (string_to_array(iwcode, '_'))[1] = 'blau' then 3 
             when
             (string_to_array(iwcode, '_'))[1] = 'rot' then 4 
        end as prio
    from 
        afu_naturgefahren_v1.befundueberschwemmungstatisch befund 
    where 
        befund.t_basket in (select t_id from orig_basket)
    union all 
    SELECT
        'ueberschwemmung' as teilprozess,
        '30' as jaehrlichkeit, 
        'keine_einwirkung' as intensitaet,
        geometrie,
        0 as prio
    from
        afu_naturgefahren_v1.abklaerungsperimeter
    where 
        w_ueberschwemmung_statisch != 'nicht_beurteilt'
        or 
        w_ueberschwemmung_dynamisch != 'nicht_beurteilt'
    union all 
    SELECT
        'ueberschwemmung' as teilprozess,
        '100' as jaehrlichkeit, 
        'keine_einwirkung' as intensitaet,
        geometrie,
        0 as prio
    from
        afu_naturgefahren_v1.abklaerungsperimeter
    where 
        w_ueberschwemmung_statisch != 'nicht_beurteilt'
        or 
        w_ueberschwemmung_dynamisch != 'nicht_beurteilt'
    union all 
    SELECT
        'ueberschwemmung' as teilprozess,
        '300' as jaehrlichkeit, 
        'keine_einwirkung' as intensitaet,
        geometrie,
        0 as prio
    from
        afu_naturgefahren_v1.abklaerungsperimeter
    where 
        w_ueberschwemmung_statisch != 'nicht_beurteilt'
        or 
        w_ueberschwemmung_dynamisch != 'nicht_beurteilt'
    union all 
    SELECT
        'ueberschwemmung' as teilprozess,
        '-1' as jaehrlichkeit, 
        'keine_einwirkung' as intensitaet,
        geometrie,
        0 as prio
    from
        afu_naturgefahren_v1.abklaerungsperimeter
    where 
        w_ueberschwemmung_statisch != 'nicht_beurteilt'
        or 
        w_ueberschwemmung_dynamisch != 'nicht_beurteilt'
), 

teilprozess_ueberschwemmung_prio as (
    SELECT 
        a.teilprozess,
        a.jaehrlichkeit,
        a.intensitaet,
        ST_Multi(COALESCE(
            ST_Difference(a.geometrie, blade.geometrie),
            a.geometrie
        )) AS geometrie
    FROM  
        teilprozess_ueberschwemmung AS a
    CROSS JOIN LATERAL (
        SELECT 
            ST_Union(geometrie) AS geometrie
        FROM   
            teilprozess_ueberschwemmung AS b
        WHERE 
            a.geometrie && b.geometrie 
            and 
            a.prio < b.prio             
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
    select * from teilprozess_ueberschwemmung_prio
),

alle_teilprozesse_union as (
    select 
        teilprozess,
        jaehrlichkeit,
        intensitaet,
        st_union(geometrie) as geometrie
    FROM 
        alle_teilprozesse
    GROUP BY 
        teilprozess,
        jaehrlichkeit,
        intensitaet
),

alle_teilprozesse_dump as (
    select 
        teilprozess,
        jaehrlichkeit,
        intensitaet,
        (st_dump(geometrie)).geom as geometrie
    FROM 
        alle_teilprozesse_union
),

basket as (
    select 
        t_id,
        attachmentkey
    from 
        afu_naturgefahren_staging_v1.t_ili2db_basket
)

INSERT INTO afu_naturgefahren_staging_v1.synoptische_intensitaet (
    t_basket,
    teilprozess, 
    jaehrlichkeit, 
    intensitaet, 
    geometrie, 
    datenherkunft, 
    auftrag_neudaten
)
select
    basket.t_id as t_basket, 
    teilprozess,
    jaehrlichkeit::integer,
    intensitaet,
    geometrie, 
    'Neudaten' as datenherkunft,
    basket.attachmentkey as auftrag_neudaten
from 
    alle_teilprozesse_dump, 
    basket
;
   






