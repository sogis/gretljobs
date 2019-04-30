SELECT
    ogc_fid AS t_id,
    CASE
        WHEN belag = 1 
            THEN 'Asphalt' 
        WHEN belag = 2 
            THEN 'Mergel' 
        WHEN belag = 3 
            THEN 'Holzkasten' 
    END AS belag,
    wkb_geometry AS geometrie,
    werkeigentuemer,
    letzte_pwi
FROM
    alw_bergwege
WHERE
    archive = 0
;
