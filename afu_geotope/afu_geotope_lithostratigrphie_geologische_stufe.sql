WITH code_parent AS (
    SELECT
        CASE
            WHEN text = 'Eozän'
                THEN 'Eozaen'
            WHEN text = 'Miozän'
                THEN 'Miozaen'
            WHEN text = 'Oligozän'
                THEN 'Oligozaen'
            WHEN text = 'Paläozän'
                THEN 'Palaeozaen'
            WHEN text = 'Pliozän'
                THEN 'Pliozaen'
            WHEN text = 'Holozän'
                THEN 'Holozaen'
            WHEN text = 'Pleistozän'
                THEN 'Pleistozaen'
            ELSE text
        END AS bezeichnung,
        code_id,
        codeart_id
    FROM
        ingeso.code
    WHERE
        codeart_id = 13
)

SELECT
    CASE
        WHEN code_child.text = 'Aalénien'
            THEN 'Aalenien'
        WHEN code_child.text = 'Sinémurien-Pliensbachien'
            THEN 'Sinemurien_Pliensbachien'
        WHEN code_child.text = 'Séquanien'
            THEN 'Sequanien'
        WHEN code_child.text = 'Lutétien'
            THEN 'Lutetien'
        WHEN code_child.text = 'Helvétien OMM'
            THEN 'Helvetien_OMM'
        WHEN code_child.text = 'Rupélien UMM'
            THEN 'Rupelien_UMM'
        WHEN code_child.text = 'Stampien UMM-USM'
            THEN 'Stampien_UMM_USM'
        WHEN code_child.text = 'Mittlerer-Unterer Buntsandstein'
            THEN 'Mittlerer_Unterer_Buntsandstein'
        WHEN code_child.text = 'Günz Vergletscherung'
            THEN 'Guenz_Vergletscherung'
        WHEN code_child.text = 'Würm Vergletscherung'
            THEN 'Wuerm_Vergletscherung'
        WHEN code_child.text = 'Latdorfien/Sannoisien'
            THEN 'Latdorfien_Sannoisien'
        ELSE replace(trim(code_child.text), ' ', '_')
    END AS bezeichnung,
    lithostratigrphie_geologische_serie.t_id AS geologische_serie
FROM
    ingeso.code_code
    JOIN code_parent
        ON code_parent.code_id = code_code.code_parent_id
    JOIN ingeso.code AS code_child
        ON code_child.code_id = code_code.code_child_id
    JOIN afu_geotope.lithostratigrphie_geologische_serie
        ON lithostratigrphie_geologische_serie.bezeichnung = code_parent.bezeichnung

UNION

SELECT
    'unbekannt' AS bezeichnung,
    lithostratigrphie_geologische_serie.t_id AS geologisches_serie
FROM
    afu_geotope.lithostratigrphie_geologische_serie