WITH fotos AS (
    SELECT 
        hoehlen.objektname,
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
        hoehlen.objektname,
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
            ON fotos.objektname = geotope_hoehle.objektname
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
            ON hoehlen.objektname = geotope_hoehle.objektname
    WHERE
        dokumente."archive" = 0
        AND
        geotope_hoehle.t_id IS NOT NULL
        AND
        hoehlen.objektart_spez = 140
),
rrbs AS (
    SELECT
        trim(regexp_split_to_table(hoehlen.rrb_nr, E'\\,')) AS rrb_nr,
        trim(regexp_split_to_table(hoehlen.rrb_date, E'\\,')) AS rrb_date,
        objektname
    FROM
        ingeso.hoehlen
    WHERE
        hoehlen."archive" = 0
        AND
        rrb_date != ''
        AND
        rrb_nr != ''
        AND
        hoehlen.objektart_spez = 140
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
        objektname
    FROM
        rrbs
),
rrb_mapping_with_new_model AS (
    SELECT
        geotope_dokument.t_id AS dokument,
        geotope_hoehle.t_id AS hoehle
    FROM
        correct_rrbs
        LEFT JOIN afu_geotope.geotope_dokument
            ON 
                geotope_dokument.offizielle_nr = rrb_nr
                AND
                geotope_dokument.publiziert_ab = to_date(rrb_date, 'DD.MM.YYYY')
        LEFT JOIN afu_geotope.geotope_hoehle
            ON geotope_hoehle.objektname = correct_rrbs.objektname
    WHERE
        geotope_dokument.t_id IS NOT NULL
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

UNION ALL

SELECT
    dokument,
    hoehle
FROM
    rrb_mapping_with_new_model
;
