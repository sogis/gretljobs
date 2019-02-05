WITH fotos AS (
    SELECT 
        hoehlen.ingeso_oid,
        hoehlen.ingesonr_alt,
        hoehlen.foto1_name AS foto_name
    FROM
        ingeso.hoehlen
    WHERE
        hoehlen."archive" = 0
        AND
        hoehlen.foto1 IS NOT NULL
        AND
        hoehlen.objektart_spez = 425

    UNION

    SELECT 
        hoehlen.ingeso_oid,
        hoehlen.ingesonr_alt,
        hoehlen.foto2_name
    FROM
        ingeso.hoehlen
    WHERE
        hoehlen."archive" = 0
        AND
        hoehlen.foto2 IS NOT NULL
        AND
        hoehlen.objektart_spez = 425
),
fotos_mapping_with_new_modell AS (
    SELECT
        geotope_dokument.t_id AS dokument,
        geotope_quelle.t_id AS quelle
        
    FROM
        afu_geotope.geotope_dokument
        LEFT JOIN fotos
            ON fotos.foto_name = geotope_dokument.titel
        LEFT JOIN afu_geotope.geotope_quelle
            ON cast(fotos.ingeso_oid AS varchar) = geotope_quelle.nummer
    WHERE
        geotope_quelle.t_id IS NOT NULL
),
dokuments_mapping_with_new_model AS (
    SELECT
        geotope_dokument.t_id AS dokument,
        geotope_quelle.t_id AS quelle
    FROM
        afu_geotope.geotope_dokument
        LEFT JOIN ingeso.dokumente
            ON dokumente.dokument_name= geotope_dokument.titel
        LEFT JOIN ingeso.hoehlen
            ON dokumente.ingeso_id = hoehlen.ingeso_id
        LEFT JOIN afu_geotope.geotope_quelle
            ON cast(hoehlen.ingeso_oid AS varchar) = geotope_quelle.nummer
    WHERE
        dokumente."archive" = 0
        AND
        geotope_quelle.t_id IS NOT NULL
        AND
        hoehlen.objektart_spez = 425
)
SELECT
    dokument,
    quelle
FROM
    fotos_mapping_with_new_modell
    
UNION ALL

SELECT
    dokument,
    quelle
FROM
    dokuments_mapping_with_new_model
;
