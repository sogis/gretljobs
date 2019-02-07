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
),
rrbs AS (
    SELECT
        trim(regexp_split_to_table(fundstl_grabungen.rrb_nr, E'\\,')) AS rrb_nr,
        trim(regexp_split_to_table(fundstl_grabungen.rrb_date, E'\\,')) AS rrb_date,
        ingeso_oid
    FROM
        ingeso.fundstl_grabungen
    WHERE
        fundstl_grabungen."archive" = 0
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
        geotope_fundstelle_grabung.t_id AS fundstelle_grabung
    FROM
        correct_rrbs
        LEFT JOIN afu_geotope.geotope_dokument
            ON 
                geotope_dokument.offizielle_nr = rrb_nr
                AND
                geotope_dokument.publiziert_ab = to_date(rrb_date, 'DD.MM.YYYY')
        LEFT JOIN afu_geotope.geotope_fundstelle_grabung
            ON geotope_fundstelle_grabung.nummer = cast(correct_rrbs.ingeso_oid AS varchar)
    WHERE
        geotope_dokument.t_id IS NOT NULL
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

UNION ALL

SELECT
    dokument,
    fundstelle_grabung
FROM
    rrb_mapping_with_new_model
;
