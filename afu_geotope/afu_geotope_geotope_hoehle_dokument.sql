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
        hoehlen.objektart_spez = 140

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
        hoehlen.objektart_spez = 140
),
fotos_mapping_with_new_modell AS (
    SELECT
        geotope_dokument.t_id AS dokument,
        geotope_hoehle.t_id AS hoehle
        
    FROM
        afu_geotope.geotope_dokument
        LEFT JOIN fotos
            ON fotos.foto_name = geotope_dokument.titel
        LEFT JOIN afu_geotope.geotope_hoehle
            ON cast(fotos.ingeso_oid AS varchar) = geotope_hoehle.nummer
    WHERE
        geotope_hoehle.t_id IS NOT NULL
),
dokuments_mapping_with_new_model AS (
    SELECT
        geotope_dokument.t_id AS dokument,
        geotope_hoehle.t_id AS hoehle
    FROM
        afu_geotope.geotope_dokument
        LEFT JOIN ingeso.dokumente
            ON dokumente.dokument_name= geotope_dokument.titel
        LEFT JOIN ingeso.hoehlen
            ON dokumente.ingeso_id = hoehlen.ingeso_id
        LEFT JOIN afu_geotope.geotope_hoehle
            ON cast(hoehlen.ingeso_oid AS varchar) = geotope_hoehle.nummer
    WHERE
        dokumente."archive" = 0
        AND
        geotope_hoehle.t_id IS NOT NULL
        AND
        hoehlen.objektart_spez = 140
)
SELECT
    dokument,
    hoehle
FROM
    fotos_mapping_with_new_modell
    
UNION ALL

SELECT
    dokument,
    hoehle
FROM
    dokuments_mapping_with_new_model
;
