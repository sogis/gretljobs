WITH fotos AS (
    SELECT 
        fundstl_grabungen.ingeso_oid,
        fundstl_grabungen.ingesonr_alt,
        fundstl_grabungen.foto1_name AS foto_name
    FROM
        ingeso.fundstl_grabungen
    WHERE
        fundstl_grabungen."archive" = 0
        AND
        fundstl_grabungen.foto1 IS NOT NULL

    UNION

    SELECT 
        fundstl_grabungen.ingeso_oid,
        fundstl_grabungen.ingesonr_alt,
        fundstl_grabungen.foto2_name
    FROM
        ingeso.fundstl_grabungen
    WHERE
        fundstl_grabungen."archive" = 0
        AND
        fundstl_grabungen.foto2 IS NOT NULL
),
fotos_mapping_with_new_modell AS (
    SELECT
        geotope_dokument.t_id AS dokument,
        geotope_fundstelle_grabung.t_id AS fundstelle_grabung
        
    FROM
        afu_geotope.geotope_dokument
        LEFT JOIN fotos
            ON fotos.foto_name = geotope_dokument.titel
        LEFT JOIN afu_geotope.geotope_fundstelle_grabung
            ON cast(fotos.ingeso_oid AS varchar) = geotope_fundstelle_grabung.nummer
    WHERE
        geotope_fundstelle_grabung.t_id IS NOT NULL
),
dokuments_mapping_with_new_model AS (
    SELECT
        geotope_dokument.t_id AS dokument,
        geotope_fundstelle_grabung.t_id AS fundstelle_grabung
    FROM
        afu_geotope.geotope_dokument
        LEFT JOIN ingeso.dokumente
            ON dokumente.dokument_name= geotope_dokument.titel
        LEFT JOIN ingeso.fundstl_grabungen
            ON dokumente.ingeso_id = fundstl_grabungen.ingeso_id
        LEFT JOIN afu_geotope.geotope_fundstelle_grabung
            ON cast(fundstl_grabungen.ingeso_oid AS varchar) = geotope_fundstelle_grabung.nummer
    WHERE
        dokumente."archive" = 0
        AND
        geotope_fundstelle_grabung.t_id IS NOT NULL
)
SELECT
    dokument,
    fundstelle_grabung
FROM
    fotos_mapping_with_new_modell
    
UNION ALL

SELECT
    dokument,
    fundstelle_grabung
FROM
    dokuments_mapping_with_new_model
;
