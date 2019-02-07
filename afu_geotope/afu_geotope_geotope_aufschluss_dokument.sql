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
),
rrbs AS (
    SELECT
        trim(regexp_split_to_table(aufschluesse.rrb_nr, E'\\,')) AS rrb_nr,
        trim(regexp_split_to_table(aufschluesse.rrb_date, E'\\,')) AS rrb_date,
        ingeso_oid
    FROM
        ingeso.aufschluesse
    WHERE
        aufschluesse."archive" = 0
        AND
        rrb_date != ''
        AND
        rrb_nr != ''
),
correct_rrbs AS (
    SELECT
        rrb_nr,
        CASE 
            WHEN 
                rrb_nr = '6885'
                AND 
                rrb_date IN ('10.12.0971', '10.12.1071', '10.12. 1971')
                    THEN '10.12.1971'
            WHEN
                rrb_nr = '2962'
                AND
                rrb_date = '11.091989'
                    THEN '11.09.1989'
            WHEN
                rrb_nr = '2443'
                AND
                rrb_date = '2.05.1972'
                    THEN '02.05.1972'
            ELSE rrb_date
        END AS rrb_date,
        ingeso_oid
    FROM
        rrbs
),
rrb_mapping_with_new_model AS (
    SELECT
        geotope_dokument.t_id AS dokument,
        geotope_aufschluss.t_id AS aufschluss
    FROM
        correct_rrbs
        LEFT JOIN afu_geotope.geotope_dokument
            ON 
                geotope_dokument.offizielle_nr = rrb_nr
                AND
                geotope_dokument.publiziert_ab = to_date(rrb_date, 'DD.MM.YYYY')
        LEFT JOIN afu_geotope.geotope_aufschluss
            ON geotope_aufschluss.nummer = cast(correct_rrbs.ingeso_oid AS varchar)
    WHERE
        geotope_dokument.t_id IS NOT NULL
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

UNION ALL

SELECT
    dokument,
    aufschluss
FROM
    rrb_mapping_with_new_model
;
