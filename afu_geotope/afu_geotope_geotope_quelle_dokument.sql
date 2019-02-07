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
),
rrbs AS (
    SELECT
        trim(regexp_split_to_table(hoehlen.rrb_nr, E'\\,')) AS rrb_nr,
        trim(regexp_split_to_table(hoehlen.rrb_date, E'\\,')) AS rrb_date,
        ingeso_oid
    FROM
        ingeso.hoehlen
    WHERE
        hoehlen."archive" = 0
        AND
        rrb_date != ''
        AND
        rrb_nr != ''
        AND
        hoehlen.objektart_spez = 425
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
        geotope_quelle.t_id AS quelle
    FROM
        correct_rrbs
        LEFT JOIN afu_geotope.geotope_dokument
            ON 
                geotope_dokument.offizielle_nr = rrb_nr
                AND
                geotope_dokument.publiziert_ab = to_date(rrb_date, 'DD.MM.YYYY')
        LEFT JOIN afu_geotope.geotope_quelle
            ON geotope_quelle.nummer = cast(correct_rrbs.ingeso_oid AS varchar)
    WHERE
        geotope_dokument.t_id IS NOT NULL
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

UNION ALL

SELECT
    dokument,
    quelle
FROM
    rrb_mapping_with_new_model
;
