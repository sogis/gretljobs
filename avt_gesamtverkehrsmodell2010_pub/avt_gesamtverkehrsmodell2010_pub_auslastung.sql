SELECT 
    ogc_fid AS t_id,
    so_id,
    nummer,
    sostrid,
    wkb_geometry AS geometrie,
    so_typ,
    CASE
        WHEN ausl_kat_2010 = 1
            THEN 'flüssig'
        WHEN ausl_kat_2010 = 2
            THEN 'dicht'
        WHEN ausl_kat_2010 = 3
            THEN 'gesättigt'
        WHEN ausl_kat_2010 = 4
            THEN 'stop+ go'
        WHEN ausl_kat_2010 = 5
            THEN 'Stau'
    END AS ausl_kat_2010,
    CASE
        WHEN ausl_kat_2020 = 1
            THEN 'flüssig'
        WHEN ausl_kat_2020 = 2
            THEN 'dicht'
        WHEN ausl_kat_2020 = 3
            THEN 'gesättigt'
        WHEN ausl_kat_2020 = 4
            THEN 'stop+ go'
         WHEN ausl_kat_2020 = 5
            THEN 'Stau'
    END AS ausl_kat_2020,
    CASE
        WHEN ausl_kat_2030 = 1
            THEN 'flüssig'
        WHEN ausl_kat_2030 = 2
            THEN 'dicht'
        WHEN ausl_kat_2030 = 3
            THEN 'gesättigt'
        WHEN ausl_kat_2030 = 4
            THEN 'stop+ go'
         WHEN ausl_kat_2030 = 5
            THEN 'Stau'
    END AS ausl_kat_2030
FROM
    verkehrsmodell2013.auslastung_kat
;