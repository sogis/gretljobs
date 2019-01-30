SELECT
    CASE
        WHEN text = 'Tertiär (Paläogen)'
            THEN 'Tertiaer'
        WHEN text = 'Quartär (Neogen)'
            THEN 'Quartaer'
        ELSE text
    END AS bezeichnung
FROM
    ingeso.code
WHERE
    codeart_id = 4
;