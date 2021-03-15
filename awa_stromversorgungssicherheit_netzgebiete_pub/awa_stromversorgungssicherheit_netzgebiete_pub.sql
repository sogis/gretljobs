SELECT 
    ageometry AS geometrie,
    levels.aname AS "name",
    organisation.aname AS betreiber,
    ebene,
    NULL::int AS konflikt
FROM 
(
    SELECT 
        aname,
        ageometry,
        3 AS ebene,
        "operator" 
    FROM
        awa_stromversorgungssicherheit.supplyscy_rldreas_ruledarea_level3 
    
    UNION ALL
    
    SELECT 
        aname,
        ageometry,
        5 AS ebene,
        "operator" 
    FROM
        awa_stromversorgungssicherheit.supplyscy_rldreas_ruledarea_level5
        
    UNION ALL
    
    SELECT 
        aname,
        ageometry,
        7 AS ebene,
        "operator" 
    FROM
        awa_stromversorgungssicherheit.supplyscy_rldreas_ruledarea_level7
) AS levels 
    LEFT JOIN awa_stromversorgungssicherheit.supplyscy_rldreas_organisation AS organisation
    ON organisation.t_id = levels."operator"
;