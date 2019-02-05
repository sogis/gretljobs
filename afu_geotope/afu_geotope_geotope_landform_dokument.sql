WITH fotos AS (
    SELECT 
        landsformen.ingeso_oid,
        landsformen.ingesonr_alt,
        landsformen.foto1_name AS foto_name
    FROM
        ingeso.landsformen
    WHERE
        landsformen."archive" = 0
        AND
        landsformen.foto1 IS NOT NULL

    UNION

    SELECT 
        landsformen.ingeso_oid,
        landsformen.ingesonr_alt,
        landsformen.foto2_name
    FROM
        ingeso.landsformen
    WHERE
        landsformen."archive" = 0
        AND
        landsformen.foto2 IS NOT NULL
),
fotos_mapping_with_new_modell AS (
    SELECT
        geotope_dokument.t_id AS dokument,
        geotope_landschaftsform.t_id AS landform
        
    FROM
        afu_geotope.geotope_dokument
        LEFT JOIN fotos
            ON fotos.foto_name = geotope_dokument.titel
        LEFT JOIN afu_geotope.geotope_landschaftsform
            ON cast(fotos.ingeso_oid AS varchar) = geotope_landschaftsform.nummer
    WHERE
        geotope_landschaftsform.t_id IS NOT NULL
),
dokuments_mapping_with_new_model AS (
    SELECT
        geotope_dokument.t_id AS dokument,
        geotope_landschaftsform.t_id AS landform
    FROM
        afu_geotope.geotope_dokument
        LEFT JOIN ingeso.dokumente
            ON dokumente.dokument_name= geotope_dokument.titel
        LEFT JOIN ingeso.landsformen
            ON dokumente.ingeso_id = landsformen.ingeso_id
        LEFT JOIN afu_geotope.geotope_landschaftsform
            ON cast(landsformen.ingeso_oid AS varchar) = geotope_landschaftsform.nummer
    WHERE
        dokumente."archive" = 0
        AND
        geotope_landschaftsform.t_id IS NOT NULL
)
SELECT
    dokument,
    landform
FROM
    fotos_mapping_with_new_modell
    
UNION ALL

SELECT
    dokument,
    landform
FROM
    dokuments_mapping_with_new_model
;
