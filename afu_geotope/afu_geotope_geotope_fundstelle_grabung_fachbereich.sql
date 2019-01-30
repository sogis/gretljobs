WITH fachbereich AS (
    SELECT
        geotope_fachbereich.t_id,
        geotope_fachbereich.fachbereichsname,
        code.code_id
    FROM
        afu_geotope.geotope_fachbereich
        LEFT JOIN ingeso.code
            ON code.text = geotope_fachbereich.fachbereichsname
    WHERE
        code.codeart_id = 8
)


SELECT
    geotope_fundstelle_grabung.t_id AS fundstelle_grabung,
    fachbereich.t_id AS fachbereich
FROM afu_geotope.geotope_fundstelle_grabung
    LEFT JOIN ingeso.fundstl_grabungen
        ON 
            geotope_fundstelle_grabung.nummer = fundstl_grabungen.ingeso_oid::varchar
            AND 
            geotope_fundstelle_grabung.alte_inventar_nummer = fundstl_grabungen.ingesonr_alt
    LEFT JOIN fachbereich
        ON fundstl_grabungen.fachbereich1 = fachbereich.code_id
WHERE
    fundstl_grabungen."archive" = 0
    AND
    fundstl_grabungen.fachbereich1 IS NOT NULL

UNION ALL

SELECT
    geotope_fundstelle_grabung.t_id AS fundstelle_grabung,
    fachbereich.t_id AS fachbereich
FROM afu_geotope.geotope_fundstelle_grabung
    LEFT JOIN ingeso.fundstl_grabungen
        ON 
            geotope_fundstelle_grabung.nummer = fundstl_grabungen.ingeso_oid::varchar
            AND 
            geotope_fundstelle_grabung.alte_inventar_nummer = fundstl_grabungen.ingesonr_alt
    LEFT JOIN fachbereich
        ON fundstl_grabungen.fachbereich2 = fachbereich.code_id
WHERE
    fundstl_grabungen."archive" = 0
    AND
    fundstl_grabungen.fachbereich2 IS NOT NULL

UNION ALL

SELECT
    geotope_fundstelle_grabung.t_id AS fundstelle_grabung,
    fachbereich.t_id AS fachbereich
FROM afu_geotope.geotope_fundstelle_grabung
    LEFT JOIN ingeso.fundstl_grabungen
        ON 
            geotope_fundstelle_grabung.nummer = fundstl_grabungen.ingeso_oid::varchar
            AND 
            geotope_fundstelle_grabung.alte_inventar_nummer = fundstl_grabungen.ingesonr_alt
    LEFT JOIN fachbereich
        ON fundstl_grabungen.fachbereich3 = fachbereich.code_id
WHERE
    fundstl_grabungen."archive" = 0
    AND
    fundstl_grabungen.fachbereich3 IS NOT NULL
;