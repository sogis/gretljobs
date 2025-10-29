WITH
orig_dataset AS (
    SELECT
        t_id  AS dataset  
    FROM 
        afu_naturgefahren_v1.t_ili2db_dataset
    WHERE 
        datasetname = ${kennung}
)

,orig_basket AS (
    SELECT 
        basket.t_id 
    FROM 
        afu_naturgefahren_v1.t_ili2db_basket basket,
        orig_dataset
    WHERE 
        basket.dataset = orig_dataset.dataset
        AND 
        topic like '%Befunde'
)

/*
Die Flächen des Teilprozesses werden priorisiert gemäss dem zweiten Wert im IWCode (Farbe)
Zusätzlich werden noch die Flächen hinzugefügt, welche beurteilt wurden, aber keine Einwirkung aufweisen. 
Diese erhalten natürlich die niedrigste Prio. 
*/

,teilprozess_absenkung AS ( 
    SELECT 
       'absenkung' AS teilprozess,
        null AS jaehrlichkeit,
        (string_to_array(iwcode, '_'))[2] AS intensitaet,
        geometrie, 
        CASE WHEN 
             (string_to_array(iwcode, '_'))[1] = 'restgefaehrdung' THEN 1 
             WHEN
             (string_to_array(iwcode, '_'))[1] = 'gelb' THEN 2 
             WHEN
             (string_to_array(iwcode, '_'))[1] = 'blau' THEN 3 
             WHEN
             (string_to_array(iwcode, '_'))[1] = 'rot' THEN 4 
        end AS prio
    FROM 
        afu_naturgefahren_v1.befundabsenkung befund 
    WHERE 
        befund.t_basket in (SELECT t_id FROM orig_basket)
    UNION ALL 
    SELECT
        'absenkung' AS teilprozess,
        null AS jaehrlichkeit,  --Bei diesem Teilprozess gibt es keine Jährlichkeit
        'keine_einwirkung' AS intensitaet,
        geometrie,
        0 AS prio
    FROM
        afu_naturgefahren_v1.abklaerungsperimeter
    WHERE 
        ea_absenkung != 'nicht_beurteilt'
)

/* 
Die Flächen werden nun gemäss ihrer Priorisierung verschnitten. Die Fläche mit der hüheren Priorisierung gewinnt. 
*/

,teilprozess_absenkung_prio AS (
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
            AND 
            a.prio < b.prio
            AND 
            a.jaehrlichkeit = b.jaehrlichkeit 
    ) AS blade
)

,teilprozess_bergundfelssturz AS ( 
    SELECT 
       'fels_bergsturz' AS teilprozess,
        CASE WHEN 
            (string_to_array(iwcode, '_'))[3] ~ '^[0-9\.]+$'
            THEN 
                (string_to_array(iwcode, '_'))[3]
            ELSE 
                '-1' 
        end AS jaehrlichkeit,
        (string_to_array(iwcode, '_'))[2] AS intensitaet,
        geometrie, 
        CASE WHEN 
             (string_to_array(iwcode, '_'))[1] = 'restgefaehrdung' THEN 1 
             WHEN
             (string_to_array(iwcode, '_'))[1] = 'gelb' THEN 2 
             WHEN
             (string_to_array(iwcode, '_'))[1] = 'blau' THEN 3 
             WHEN
             (string_to_array(iwcode, '_'))[1] = 'rot' THEN 4 
        end AS prio
    FROM 
        afu_naturgefahren_v1.befundbergfelssturz befund 
    WHERE 
        befund.t_basket in (SELECT t_id FROM orig_basket)
    UNION ALL 
    SELECT
        'fels_bergsturz' AS teilprozess,
        '30' AS jaehrlichkeit,
        'keine_einwirkung' AS intensitaet,
        geometrie,
        0 AS prio
    FROM
        afu_naturgefahren_v1.abklaerungsperimeter
    WHERE 
        s_berg_felssturz != 'nicht_beurteilt'
    UNION ALL 
    SELECT
        'fels_bergsturz' AS teilprozess,
        '100' AS jaehrlichkeit,
        'keine_einwirkung' AS intensitaet,
        geometrie,
        0 AS prio
    FROM
        afu_naturgefahren_v1.abklaerungsperimeter
    WHERE 
        s_berg_felssturz != 'nicht_beurteilt'
    UNION ALL 
    SELECT
        'fels_bergsturz' AS teilprozess,
        '300' AS jaehrlichkeit,
        'keine_einwirkung' AS intensitaet,
        geometrie,
        0 AS prio
    FROM
        afu_naturgefahren_v1.abklaerungsperimeter
    WHERE 
        s_berg_felssturz != 'nicht_beurteilt'
    UNION ALL 
    SELECT
        'fels_bergsturz' AS teilprozess,
        '-1' AS jaehrlichkeit, --für die Restgefährdung
        'keine_einwirkung' AS intensitaet,
        geometrie,
        0 AS prio
    FROM
        afu_naturgefahren_v1.abklaerungsperimeter
    WHERE 
        s_berg_felssturz != 'nicht_beurteilt'
)

,teilprozess_bergundfelssturz_prio AS (
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
            AND 
            a.prio < b.prio             
            AND 
            a.jaehrlichkeit = b.jaehrlichkeit 
    ) AS blade
)

,teilprozess_einsturz AS ( 
    SELECT 
       'einsturz' AS teilprozess,
        null AS jaehrlichkeit,
        (string_to_array(iwcode, '_'))[2] AS intensitaet,
        geometrie,
        CASE WHEN 
             (string_to_array(iwcode, '_'))[1] = 'restgefaehrdung' THEN 1 
             WHEN
             (string_to_array(iwcode, '_'))[1] = 'gelb' THEN 2 
             WHEN
             (string_to_array(iwcode, '_'))[1] = 'blau' THEN 3 
             WHEN
             (string_to_array(iwcode, '_'))[1] = 'rot' THEN 4 
        end AS prio
    FROM 
        afu_naturgefahren_v1.befundeinsturz befund 
    WHERE 
        befund.t_basket in (SELECT t_id FROM orig_basket)
    UNION ALL 
    SELECT
        'einsturz' AS teilprozess,
        null AS jaehrlichkeit, --Bei diesem Teilprozess gibt es keine Jährlichkeit
        'keine_einwirkung' AS intensitaet,
        geometrie,
        0 AS prio
    FROM
        afu_naturgefahren_v1.abklaerungsperimeter
    WHERE 
        ea_einsturz != 'nicht_beurteilt'
)

,teilprozess_einsturz_prio AS (
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
            AND 
            a.prio < b.prio             
            AND 
            a.jaehrlichkeit = b.jaehrlichkeit 
    ) AS blade
)

,teilprozess_hangmure AS ( 
    SELECT 
       'hangmure' AS teilprozess,
        CASE WHEN 
            (string_to_array(iwcode, '_'))[3] ~ '^[0-9\.]+$'
            THEN 
                (string_to_array(iwcode, '_'))[3]
            else 
                '-1' 
        end AS jaehrlichkeit,
        (string_to_array(iwcode, '_'))[2] AS intensitaet,
        geometrie, 
        CASE WHEN 
             (string_to_array(iwcode, '_'))[1] = 'restgefaehrdung' THEN 1 
             WHEN
             (string_to_array(iwcode, '_'))[1] = 'gelb' THEN 2 
             WHEN
             (string_to_array(iwcode, '_'))[1] = 'blau' THEN 3 
             WHEN
             (string_to_array(iwcode, '_'))[1] = 'rot' THEN 4 
        end AS prio
    FROM 
        afu_naturgefahren_v1.befundhangmure befund 
    WHERE 
        befund.t_basket in (SELECT t_id FROM orig_basket)
    UNION ALL 
    SELECT
        'hangmure' AS teilprozess,
        '30' AS jaehrlichkeit, 
        'keine_einwirkung' AS intensitaet,
        geometrie,
        0 AS prio
    FROM
        afu_naturgefahren_v1.abklaerungsperimeter
    WHERE 
        r_hangmure != 'nicht_beurteilt'
    UNION ALL 
    SELECT
        'hangmure' AS teilprozess,
        '100' AS jaehrlichkeit, 
        'keine_einwirkung' AS intensitaet,
        geometrie,
        0 AS prio
    FROM
        afu_naturgefahren_v1.abklaerungsperimeter
    WHERE 
        r_hangmure != 'nicht_beurteilt'
    UNION ALL 
    SELECT
        'hangmure' AS teilprozess,
        '300' AS jaehrlichkeit, 
        'keine_einwirkung' AS intensitaet,
        geometrie,
        0 AS prio
    FROM
        afu_naturgefahren_v1.abklaerungsperimeter
    WHERE 
        r_hangmure != 'nicht_beurteilt'
)

,teilprozess_hangmure_prio AS (
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
            AND 
            a.prio < b.prio             
            AND 
            a.jaehrlichkeit = b.jaehrlichkeit 
    ) AS blade
)

,teilprozess_permanentrutschung AS ( 
    SELECT 
       'permanente_rutschung' AS teilprozess,
        null AS jaehrlichkeit,
        (string_to_array(iwcode, '_'))[2] AS intensitaet,
        geometrie, 
        CASE WHEN 
             (string_to_array(iwcode, '_'))[1] = 'restgefaehrdung' THEN 1 
             WHEN
             (string_to_array(iwcode, '_'))[1] = 'gelb' THEN 2 
             WHEN
             (string_to_array(iwcode, '_'))[1] = 'blau' THEN 3 
             WHEN
             (string_to_array(iwcode, '_'))[1] = 'rot' THEN 4 
        end AS prio
    FROM 
        afu_naturgefahren_v1.befundpermanenterutschung befund
    WHERE 
        befund.t_basket in (SELECT t_id FROM orig_basket)
    UNION ALL 
    SELECT
        'permanente_rutschung' AS teilprozess,
        null AS jaehrlichkeit, --Bei diesem Teilprozess gibt es keine Jährlichkeiten
        'keine_einwirkung' AS intensitaet,
        geometrie,
        0 AS prio
    FROM
        afu_naturgefahren_v1.abklaerungsperimeter
    WHERE 
        r_permanente_rutschung != 'nicht_beurteilt'
)

,teilprozess_permanentrutschung_prio AS (
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
            AND 
            a.prio < b.prio             
            AND 
            a.jaehrlichkeit = b.jaehrlichkeit 
    ) AS blade
)

,teilprozess_spontanrutschung AS ( 
    SELECT 
       'spontane_rutschung' AS teilprozess,
        CASE WHEN 
            (string_to_array(iwcode, '_'))[3] ~ '^[0-9\.]+$'
            THEN 
                (string_to_array(iwcode, '_'))[3]
            else 
                '-1' 
        end AS jaehrlichkeit,
        (string_to_array(iwcode, '_'))[2] AS intensitaet,
        geometrie, 
        CASE WHEN 
             (string_to_array(iwcode, '_'))[1] = 'restgefaehrdung' THEN 1 
             WHEN
             (string_to_array(iwcode, '_'))[1] = 'gelb' THEN 2 
             WHEN
             (string_to_array(iwcode, '_'))[1] = 'blau' THEN 3 
             WHEN
             (string_to_array(iwcode, '_'))[1] = 'rot' THEN 4 
        end AS prio
    FROM 
        afu_naturgefahren_v1.befundspontanerutschung befund 
    LEFT JOIN
        afu_naturgefahren_v1.t_ili2db_basket basket
        ON 
        befund.t_basket = basket.t_id 
    WHERE 
        befund.t_basket in (SELECT t_id FROM orig_basket)
    UNION ALL 
    SELECT
        'spontane_rutschung' AS teilprozess,
        '30' AS jaehrlichkeit, 
        'keine_einwirkung' AS intensitaet,
        geometrie,
        0 AS prio
    FROM
        afu_naturgefahren_v1.abklaerungsperimeter
    WHERE 
        r_spontane_rutschung != 'nicht_beurteilt'
    UNION ALL 
    SELECT
        'spontane_rutschung' AS teilprozess,
        '100' AS jaehrlichkeit, 
        'keine_einwirkung' AS intensitaet,
        geometrie,
        0 AS prio
    FROM
        afu_naturgefahren_v1.abklaerungsperimeter
    WHERE 
        r_spontane_rutschung != 'nicht_beurteilt'
    UNION ALL 
    SELECT
        'spontane_rutschung' AS teilprozess,
        '300' AS jaehrlichkeit, 
        'keine_einwirkung' AS intensitaet,
        geometrie,
        0 AS prio
    FROM
        afu_naturgefahren_v1.abklaerungsperimeter
    WHERE 
        r_spontane_rutschung != 'nicht_beurteilt'
)

,teilprozess_spontanrutschung_prio AS (
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
            AND 
            a.prio < b.prio             
            AND 
            a.jaehrlichkeit = b.jaehrlichkeit 
    ) AS blade
)

,teilprozess_steinblockschlag AS ( 
    SELECT 
       'stein_blockschlag' AS teilprozess,
        CASE WHEN 
            (string_to_array(iwcode, '_'))[3] ~ '^[0-9\.]+$'
            THEN 
                (string_to_array(iwcode, '_'))[3]
            else 
                '-1' 
        end AS jaehrlichkeit,
        (string_to_array(iwcode, '_'))[2] AS intensitaet,
        geometrie, 
        CASE WHEN 
             (string_to_array(iwcode, '_'))[1] = 'restgefaehrdung' THEN 1 
             WHEN
             (string_to_array(iwcode, '_'))[1] = 'gelb' THEN 2 
             WHEN
             (string_to_array(iwcode, '_'))[1] = 'blau' THEN 3 
             WHEN
             (string_to_array(iwcode, '_'))[1] = 'rot' THEN 4 
        end AS prio
    FROM 
        afu_naturgefahren_v1.befundsteinblockschlag befund 
    WHERE 
        befund.t_basket in (SELECT t_id FROM orig_basket)
    UNION ALL 
    SELECT
        'stein_blockschlag' AS teilprozess,
        '30' AS jaehrlichkeit, 
        'keine_einwirkung' AS intensitaet,
        geometrie,
        0 AS prio
    FROM
        afu_naturgefahren_v1.abklaerungsperimeter
    WHERE 
        s_stein_blockschlag != 'nicht_beurteilt'
    UNION ALL 
    SELECT
        'stein_blockschlag' AS teilprozess,
        '100' AS jaehrlichkeit, 
        'keine_einwirkung' AS intensitaet,
        geometrie,
        0 AS prio
    FROM
        afu_naturgefahren_v1.abklaerungsperimeter
    WHERE 
        s_stein_blockschlag != 'nicht_beurteilt'
    UNION ALL 
    SELECT
        'stein_blockschlag' AS teilprozess,
        '300' AS jaehrlichkeit, 
        'keine_einwirkung' AS intensitaet,
        geometrie,
        0 AS prio
    FROM
        afu_naturgefahren_v1.abklaerungsperimeter
    WHERE 
        s_stein_blockschlag != 'nicht_beurteilt'
    UNION ALL 
    SELECT
        'stein_blockschlag' AS teilprozess,
        '-1' AS jaehrlichkeit, 
        'keine_einwirkung' AS intensitaet,
        geometrie,
        0 AS prio
    FROM
        afu_naturgefahren_v1.abklaerungsperimeter
    WHERE 
        s_stein_blockschlag != 'nicht_beurteilt'
)

,teilprozess_steinblockschlag_prio AS (
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
            AND 
            a.prio < b.prio             
            AND 
            a.jaehrlichkeit = b.jaehrlichkeit 
    ) AS blade
)

,teilprozess_uebermurung AS ( 
    SELECT 
       'uebermurung' AS teilprozess,
        CASE WHEN 
            (string_to_array(iwcode, '_'))[3] ~ '^[0-9\.]+$'
            THEN 
                (string_to_array(iwcode, '_'))[3]
            else 
                '-1' 
        end AS jaehrlichkeit,
        (string_to_array(iwcode, '_'))[2] AS intensitaet,
        geometrie, 
        CASE WHEN 
             (string_to_array(iwcode, '_'))[1] = 'restgefaehrdung' THEN 1 
             WHEN
             (string_to_array(iwcode, '_'))[1] = 'gelb' THEN 2 
             WHEN
             (string_to_array(iwcode, '_'))[1] = 'blau' THEN 3 
             WHEN
             (string_to_array(iwcode, '_'))[1] = 'rot' THEN 4 
        end AS prio
    FROM 
        afu_naturgefahren_v1.befunduebermurung befund 
    WHERE 
        befund.t_basket in (SELECT t_id FROM orig_basket)
    UNION ALL 
    SELECT
        'uebermurung' AS teilprozess,
        '30' AS jaehrlichkeit, 
        'keine_einwirkung' AS intensitaet,
        geometrie,
        0 AS prio
    FROM
        afu_naturgefahren_v1.abklaerungsperimeter
    WHERE 
        w_uebermurung != 'nicht_beurteilt'
    UNION ALL 
    SELECT
        'uebermurung' AS teilprozess,
        '100' AS jaehrlichkeit, 
        'keine_einwirkung' AS intensitaet,
        geometrie,
        0 AS prio
    FROM
        afu_naturgefahren_v1.abklaerungsperimeter
    WHERE 
        w_uebermurung != 'nicht_beurteilt'
    UNION ALL 
    SELECT
        'uebermurung' AS teilprozess,
        '300' AS jaehrlichkeit, 
        'keine_einwirkung' AS intensitaet,
        geometrie,
        0 AS prio
    FROM
        afu_naturgefahren_v1.abklaerungsperimeter
    WHERE 
        w_uebermurung != 'nicht_beurteilt'
    UNION ALL 
    SELECT
        'uebermurung' AS teilprozess,
        '-1' AS jaehrlichkeit, 
        'keine_einwirkung' AS intensitaet,
        geometrie,
        0 AS prio
    FROM
        afu_naturgefahren_v1.abklaerungsperimeter
    WHERE 
        w_uebermurung != 'nicht_beurteilt'
)

,teilprozess_uebermurung_prio AS (
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
            AND 
            a.prio < b.prio             
            AND 
            a.jaehrlichkeit = b.jaehrlichkeit 
    ) AS blade
)

,teilprozess_ueberschwemmung AS ( 
    SELECT 
       'ueberschwemmung' AS teilprozess,
        CASE WHEN 
            (string_to_array(iwcode, '_'))[3] ~ '^[0-9\.]+$'
            THEN 
                (string_to_array(iwcode, '_'))[3]
            else 
                '-1' 
        end AS jaehrlichkeit,
        (string_to_array(iwcode, '_'))[2] AS intensitaet,
        geometrie, 
        CASE WHEN 
             (string_to_array(iwcode, '_'))[1] = 'restgefaehrdung' THEN 1 
             WHEN
             (string_to_array(iwcode, '_'))[1] = 'gelb' THEN 2 
             WHEN
             (string_to_array(iwcode, '_'))[1] = 'blau' THEN 3 
             WHEN
             (string_to_array(iwcode, '_'))[1] = 'rot' THEN 4 
        end AS prio
    FROM 
        afu_naturgefahren_v1.befundueberschwemmungdynamisch befund 
    WHERE 
        befund.t_basket in (SELECT t_id FROM orig_basket)
    
    UNION ALL -- Dynamische und Statische Überschwemmungen werden zusammengefasst.
    
    SELECT 
       'ueberschwemmung' AS teilprozess,
        CASE WHEN 
            (string_to_array(iwcode, '_'))[3] ~ '^[0-9\.]+$'
            THEN 
                (string_to_array(iwcode, '_'))[3]
            else 
                '-1' 
        end AS jaehrlichkeit,
        (string_to_array(iwcode, '_'))[2] AS intensitaet,
        geometrie, 
        CASE WHEN 
             (string_to_array(iwcode, '_'))[1] = 'restgefaehrdung' THEN 1 
             WHEN
             (string_to_array(iwcode, '_'))[1] = 'gelb' THEN 2 
             WHEN
             (string_to_array(iwcode, '_'))[1] = 'blau' THEN 3 
             WHEN
             (string_to_array(iwcode, '_'))[1] = 'rot' THEN 4 
        end AS prio
    FROM 
        afu_naturgefahren_v1.befundueberschwemmungstatisch befund 
    WHERE 
        befund.t_basket in (SELECT t_id FROM orig_basket)
    UNION ALL 
    SELECT
        'ueberschwemmung' AS teilprozess,
        '30' AS jaehrlichkeit, 
        'keine_einwirkung' AS intensitaet,
        geometrie,
        0 AS prio
    FROM
        afu_naturgefahren_v1.abklaerungsperimeter
    WHERE 
        w_ueberschwemmung_statisch != 'nicht_beurteilt'
        or 
        w_ueberschwemmung_dynamisch != 'nicht_beurteilt'
    UNION ALL 
    SELECT
        'ueberschwemmung' AS teilprozess,
        '100' AS jaehrlichkeit, 
        'keine_einwirkung' AS intensitaet,
        geometrie,
        0 AS prio
    FROM
        afu_naturgefahren_v1.abklaerungsperimeter
    WHERE 
        w_ueberschwemmung_statisch != 'nicht_beurteilt'
        or 
        w_ueberschwemmung_dynamisch != 'nicht_beurteilt'
    UNION ALL 
    SELECT
        'ueberschwemmung' AS teilprozess,
        '300' AS jaehrlichkeit, 
        'keine_einwirkung' AS intensitaet,
        geometrie,
        0 AS prio
    FROM
        afu_naturgefahren_v1.abklaerungsperimeter
    WHERE 
        w_ueberschwemmung_statisch != 'nicht_beurteilt'
        or 
        w_ueberschwemmung_dynamisch != 'nicht_beurteilt'
    UNION ALL 
    SELECT
        'ueberschwemmung' AS teilprozess,
        '-1' AS jaehrlichkeit, 
        'keine_einwirkung' AS intensitaet,
        geometrie,
        0 AS prio
    FROM
        afu_naturgefahren_v1.abklaerungsperimeter
    WHERE 
        w_ueberschwemmung_statisch != 'nicht_beurteilt'
        or 
        w_ueberschwemmung_dynamisch != 'nicht_beurteilt'
) 

,teilprozess_ueberschwemmung_prio AS (
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
            AND 
            a.prio < b.prio             
            AND 
            a.jaehrlichkeit = b.jaehrlichkeit 
    ) AS blade
)

/* 
Nun werden alle Teilprozesse zusammengefügt.
*/

,alle_teilprozesse AS (
    SELECT * FROM teilprozess_absenkung_prio
    UNION ALL 
    SELECT * FROM teilprozess_bergundfelssturz_prio
    UNION ALL 
    SELECT * FROM teilprozess_einsturz_prio
    union  all
    SELECT * FROM teilprozess_hangmure_prio
    UNION ALL 
    SELECT * FROM teilprozess_permanentrutschung_prio
    UNION ALL 
    SELECT * FROM teilprozess_spontanrutschung_prio
    UNION ALL 
    SELECT * FROM teilprozess_steinblockschlag_prio
    UNION ALL 
    SELECT * FROM teilprozess_uebermurung_prio
    UNION ALL 
    SELECT * FROM teilprozess_ueberschwemmung_prio
)

/* 
Union und dump sorgen dafür, dass Flächen gleicher Teilprozesse, Intensität und Jährlichkeit zusammengefügt werden, aber nicht in einem riesigen Multipolygon enden. 
*/

,alle_teilprozesse_union AS (
    SELECT 
        teilprozess,
        jaehrlichkeit,
        intensitaet,
        st_union(geometrie) AS geometrie
    FROM 
        alle_teilprozesse
    GROUP BY 
        teilprozess,
        jaehrlichkeit,
        intensitaet
)

,alle_teilprozesse_dump AS (
    SELECT 
        teilprozess,
        jaehrlichkeit,
        intensitaet,
        (st_dump(geometrie)).geom AS geometrie
    FROM 
        alle_teilprozesse_union
)

,basket AS (
    SELECT 
        t_id,
        attachmentkey
    FROM 
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
SELECT
    basket.t_id AS t_basket, 
    teilprozess,
    jaehrlichkeit::integer,
    intensitaet,
    geometrie, 
    'Neudaten' AS datenherkunft,
    basket.attachmentkey AS auftrag_neudaten
FROM 
    alle_teilprozesse_dump, 
    basket
;
