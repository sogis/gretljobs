SELECT 
    ruledarea_level3.aname,
    ageometry AS geometrie,
    canton AS kanton,
    organisation.aname AS betreiber
FROM
    awa_stromversorgungssicherheit.supplyscy_rldreas_ruledarea_level3 AS ruledarea_level3
    LEFT JOIN awa_stromversorgungssicherheit.supplyscy_rldreas_organisation AS organisation
    ON organisation.t_id = ruledarea_level3."operator"
;
