SELECT 
    ruledarea_level_3.aname AS "name",
    ageometry AS geometrie,
    canton AS kanton,
    organisation.aname AS "operator" 
FROM
    awa_stromversorgungssicherheit.supplyscy_rldreas_ruledarea_level_3 AS ruledarea_level_3
    LEFT JOIN awa_stromversorgungssicherheit.supplyscy_rldreas_organisation AS organisation
    ON organisation.t_id = ruledarea_level_3."operator"
;
