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
    geotope_erratiker.t_id AS erratiker,
    fachbereich.t_id AS fachbereich
FROM afu_geotope.geotope_erratiker
    LEFT JOIN ingeso.erratiker
        ON 
            geotope_erratiker.objektname = erratiker.objektname
            AND 
            geotope_erratiker.alte_inventar_nummer = erratiker.ingesonr_alt
    LEFT JOIN fachbereich
        ON erratiker.fachbereich1 = fachbereich.code_id
WHERE
    erratiker."archive" = 0
    AND
    erratiker.fachbereich1 IS NOT NULL

UNION ALL

SELECT
    geotope_erratiker.t_id AS erratiker,
    fachbereich.t_id AS fachbereich
FROM afu_geotope.geotope_erratiker
    LEFT JOIN ingeso.erratiker
        ON 
            geotope_erratiker.objektname = erratiker.objektname
            AND 
            geotope_erratiker.alte_inventar_nummer = erratiker.ingesonr_alt
    LEFT JOIN fachbereich
        ON erratiker.fachbereich2 = fachbereich.code_id
WHERE
    erratiker."archive" = 0
    AND
    erratiker.fachbereich2 IS NOT NULL

UNION ALL

SELECT
    geotope_erratiker.t_id AS erratiker,
    fachbereich.t_id AS fachbereich
FROM afu_geotope.geotope_erratiker
    LEFT JOIN ingeso.erratiker
        ON 
            geotope_erratiker.objektname = erratiker.objektname
            AND 
            geotope_erratiker.alte_inventar_nummer = erratiker.ingesonr_alt
    LEFT JOIN fachbereich
        ON erratiker.fachbereich3 = fachbereich.code_id
WHERE
    erratiker."archive" = 0
    AND
    erratiker.fachbereich3 IS NOT NULL
;