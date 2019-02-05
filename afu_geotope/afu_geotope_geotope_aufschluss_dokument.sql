WITH fotos AS (
    SELECT 
        aufschluesse.ingeso_oid,
        aufschluesse.ingesonr_alt,
        aufschluesse.foto1_name AS foto_name
    FROM
        ingeso.aufschluesse
    WHERE
        aufschluesse."archive" = 0
        AND
        aufschluesse.foto1 IS NOT NULL

    UNION

    SELECT 
        aufschluesse.ingeso_oid,
        aufschluesse.ingesonr_alt,
        aufschluesse.foto2_name
    FROM
        ingeso.aufschluesse
    WHERE
        aufschluesse."archive" = 0
        AND
        aufschluesse.foto2 IS NOT NULL
),
fotos_mapping_with_new_modell AS (
    SELECT
        geotope_dokument.t_id AS dokument,
        geotope_aufschluss.t_id AS aufschluss,
        fotos.*
    FROM
        afu_geotope.geotope_dokument
        LEFT JOIN fotos
            ON fotos.foto_name = geotope_dokument.titel
        LEFT JOIN afu_geotope.geotope_aufschluss
            ON cast(fotos.ingeso_oid AS varchar) = geotope_aufschluss.nummer
    WHERE
        geotope_aufschluss.t_id IS NOT NULL
),
dokuments_mapping_with_new_model AS (
    SELECT
        geotope_dokument.t_id AS dokument,
        geotope_aufschluss.t_id AS aufschluss
    FROM
        afu_geotope.geotope_dokument
        LEFT JOIN ingeso.dokumente
            ON dokumente.dokument_name= geotope_dokument.titel
        LEFT JOIN ingeso.aufschluesse
            ON dokumente.ingeso_id = aufschluesse.ingeso_id
        LEFT JOIN afu_geotope.geotope_aufschluss
            ON cast(aufschluesse.ingeso_oid AS varchar) = geotope_aufschluss.nummer
    WHERE
        dokumente."archive" = 0
        AND
        geotope_aufschluss.t_id IS NOT NULL
)
SELECT
    dokument,
    aufschluss
FROM
    fotos_mapping_with_new_modell
    
UNION ALL

SELECT
    dokument,
    aufschluss
FROM
    dokuments_mapping_with_new_model
;
