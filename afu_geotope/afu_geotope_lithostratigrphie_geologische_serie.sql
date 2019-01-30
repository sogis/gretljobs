WITH code_parent AS (
    SELECT
        CASE
            WHEN text = 'Tertiär (Paläogen)'
                THEN 'Tertiaer'
            WHEN text = 'Quartär (Neogen)'
                THEN 'Quartaer'
            ELSE text
        END AS bezeichnung,
        code_id,
        codeart_id
    FROM
        ingeso.code
    WHERE
        codeart_id = 4
)

SELECT
    CASE
        WHEN code_child.text IS NULL
            THEN 'unbekannt'
        WHEN code_child.text = 'Eozän'
            THEN 'Eozaen'
        WHEN code_child.text = 'Miozän'
            THEN 'Miozaen'
        WHEN code_child.text = 'Oligozän'
            THEN 'Oligozaen'
        WHEN code_child.text = 'Paläozän'
            THEN 'Palaeozaen'
        WHEN code_child.text = 'Pliozän'
            THEN 'Pliozaen'
        WHEN code_child.text = 'Holozän'
            THEN 'Holozaen'
        WHEN code_child.text = 'Pleistozän'
            THEN 'Pleistozaen'
        ELSE code_child.text
    END AS bezeichnung,
    lithostratigrphie_geologisches_system.t_id AS geologisches_system
FROM
    ingeso.code_code
    JOIN code_parent
        ON code_parent.code_id = code_code.code_parent_id
    JOIN ingeso.code AS code_child
        ON code_child.code_id = code_code.code_child_id
    JOIN afu_geotope.lithostratigrphie_geologisches_system
        ON lithostratigrphie_geologisches_system.bezeichnung = code_parent.bezeichnung

UNION

SELECT
    'unbekannt' AS bezeichnung,
    lithostratigrphie_geologisches_system.t_id AS geologisches_system
FROM
    afu_geotope.lithostratigrphie_geologisches_system