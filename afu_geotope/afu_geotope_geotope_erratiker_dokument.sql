WITH fotos AS (
    SELECT 
        erratiker.ingeso_oid,
        erratiker.ingesonr_alt,
        erratiker.foto1_name AS foto_name
    FROM
        ingeso.erratiker
    WHERE
        erratiker."archive" = 0
        AND
        erratiker.foto1 IS NOT NULL

    UNION

    SELECT 
        erratiker.ingeso_oid,
        erratiker.ingesonr_alt,
        erratiker.foto2_name
    FROM
        ingeso.erratiker
    WHERE
        erratiker."archive" = 0
        AND
        erratiker.foto2 IS NOT NULL
),
fotos_mapping_with_new_modell AS (
    SELECT
        geotope_dokument.t_id AS dokument,
        geotope_erratiker.t_id AS erratiker
        
    FROM
        afu_geotope.geotope_dokument
        LEFT JOIN fotos
            ON fotos.foto_name = geotope_dokument.titel
        LEFT JOIN afu_geotope.geotope_erratiker
            ON cast(fotos.ingeso_oid AS varchar) = geotope_erratiker.nummer
    WHERE
        geotope_erratiker.t_id IS NOT NULL
),
dokuments_mapping_with_new_model AS (
    SELECT
        geotope_dokument.t_id AS dokument,
        geotope_erratiker.t_id AS erratiker
    FROM
        afu_geotope.geotope_dokument
        LEFT JOIN ingeso.dokumente
            ON dokumente.dokument_name= geotope_dokument.titel
        LEFT JOIN ingeso.erratiker
            ON dokumente.ingeso_id = erratiker.ingeso_id
        LEFT JOIN afu_geotope.geotope_erratiker
            ON cast(erratiker.ingeso_oid AS varchar) = geotope_erratiker.nummer
    WHERE
        dokumente."archive" = 0
        AND
        geotope_erratiker.t_id IS NOT NULL
)
SELECT
    dokument,
    erratiker
FROM
    fotos_mapping_with_new_modell
    
UNION ALL

SELECT
    dokument,
    erratiker
FROM
    dokuments_mapping_with_new_model
;
