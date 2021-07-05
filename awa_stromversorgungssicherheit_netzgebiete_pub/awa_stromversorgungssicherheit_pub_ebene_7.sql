SELECT 
    ruledarea_level7.aname,
    ageometry AS geometrie,
    canton AS kanton,
    organisation.aname AS betreiber 
FROM
    awa_stromversorgungssicherheit.supplyscy_rldreas_ruledarea_level7 AS ruledarea_level7
    LEFT JOIN awa_stromversorgungssicherheit.supplyscy_rldreas_organisation AS organisation
    ON organisation.t_id = ruledarea_level7."operator"
;
