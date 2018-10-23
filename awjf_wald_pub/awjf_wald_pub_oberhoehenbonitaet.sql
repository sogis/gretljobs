SELECT 
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    id,
    ohb_code,
    CASE
        WHEN ohb_code = 10
            THEN '<= 10 m'
        WHEN ohb_code = 14
            THEN '11 - 14 m'
        WHEN ohb_code = 18
            THEN '15 - 18 m'
        WHEN ohb_code = 22
            THEN '19 - 22 m'
        WHEN ohb_code = 26
            THEN '23 - 26 m'
        WHEN ohb_code = 30
            THEN '27 - 30 m'
        WHEN ohb_code = 100
            THEN '> 30 m'
    END AS oberhoehenbonitaet
FROM 
    awjf.oberhoehenbonitaet
WHERE 
    archive = 0
;
