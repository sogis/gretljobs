WITH code_parent AS (
    SELECT
        CASE
            WHEN text = 'Aalénien'
                THEN 'Aalenien'
            WHEN text = 'Sinémurien-Pliensbachien'
                THEN 'Sinemurien_Pliensbachien'
            WHEN text = 'Séquanien'
                THEN 'Sequanien'
            WHEN text = 'Lutétien'
                THEN 'Lutetien'
            WHEN text = 'Helvétien OMM'
                THEN 'Helvetien_OMM'
            WHEN text = 'Rupélien UMM'
                THEN 'Rupelien_UMM'
            WHEN text = 'Stampien UMM-USM'
                THEN 'Stampien_UMM_USM'
            WHEN text = 'Mittlerer-Unterer Buntsandstein'
                THEN 'Mittlerer_Unterer_Buntsandstein'
            WHEN text = 'Günz Vergletscherung'
                THEN 'Guenz_Vergletscherung'
            WHEN text = 'Würm Vergletscherung'
                THEN 'Wuerm_Vergletscherung'
            WHEN text = 'Latdorfien/Sannoisien'
                THEN 'Latdorfien_Sannoisien'
            ELSE replace(trim(text), ' ', '_')
        END AS bezeichnung,
        code_id,
        codeart_id
    FROM
        ingeso.code
    WHERE
        codeart_id = 5
)

SELECT
    CASE
        WHEN code_child.text = 'Mäandrina Schichten'
            THEN 'Maeandrina_Schichten'
        WHEN code_child.text = 'Dalle nacreé'
            THEN 'Dalle_nacree'
        WHEN code_child.text = 'Arieten (Gryphiten) Kalk'
            THEN 'Arieten_Kalk'
        WHEN code_child.text = 'Terrain à chailles'
            THEN 'Terrain_a_chailles'
        WHEN code_child.text = 'Röt'
            THEN 'Roet'
        WHEN code_child.text = 'Gansinger Dolomit (Hauptsteinmergel)'
            THEN 'Gansinger_Dolomit'
        WHEN code_child.text = 'Rhät'
            THEN 'Rhaet'
        WHEN code_child.text = 'Grundmoräne'
            THEN 'Grundmoraene'
        WHEN code_child.text = 'Seitenmoräne'
            THEN 'Seitenmoraene'
        WHEN code_child.text = 'U-Tal'
            THEN 'U_Tal'
        WHEN code_child.text = 'Vorbourg-Kalke'
            THEN 'Vorbourg_Kalke'
        WHEN code_child.text = 'Moräne'
            THEN 'Moraene'
        WHEN code_child.text = 'UMM-USM'
            THEN 'UMM_USM'
        ELSE replace(trim(code_child.text), ' ', '_')
    END AS bezeichnung,
    lithostratigrphie_geologische_stufe.t_id AS geologische_stufe
FROM
    ingeso.code_code
    JOIN code_parent
        ON code_parent.code_id = code_code.code_parent_id
    JOIN ingeso.code AS code_child
        ON code_child.code_id = code_code.code_child_id
    JOIN afu_geotope.lithostratigrphie_geologische_stufe
        ON lithostratigrphie_geologische_stufe.bezeichnung = code_parent.bezeichnung

UNION

SELECT
    'unbekannt' AS bezeichnung,
    lithostratigrphie_geologische_stufe.t_id AS geologische_stufe
FROM
    afu_geotope.lithostratigrphie_geologische_stufe