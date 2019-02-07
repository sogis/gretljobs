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
),
rrbs AS (
    SELECT
        trim(regexp_split_to_table(regexp_split_to_table(landsformen.rrb_nr, E'\\,'), 'und')) AS rrb_nr,
        trim(regexp_split_to_table(regexp_split_to_table(landsformen.rrb_date, E'\\,'), 'und')) AS rrb_date,
        ingeso_oid
    FROM
        ingeso.landsformen
    WHERE
        landsformen."archive" = 0
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
        geotope_landschaftsform.t_id AS landform, *
    FROM
        correct_rrbs
        LEFT JOIN afu_geotope.geotope_dokument
            ON 
                geotope_dokument.offizielle_nr = rrb_nr
                AND
                geotope_dokument.publiziert_ab = to_date(rrb_date, 'DD.MM.YYYY')
        LEFT JOIN afu_geotope.geotope_landschaftsform
            ON geotope_landschaftsform.nummer = cast(correct_rrbs.ingeso_oid AS varchar)
    WHERE
        geotope_dokument.t_id IS NOT NULL
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

UNION ALL

SELECT
    dokument,
    landform
FROM
    rrb_mapping_with_new_model
;
