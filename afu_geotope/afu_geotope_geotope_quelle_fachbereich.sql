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
    geotope_quelle.t_id AS quelle,
    fachbereich.t_id AS fachbereich
FROM afu_geotope.geotope_quelle
    LEFT JOIN ingeso.hoehlen
        ON 
            geotope_quelle.objektname = hoehlen.objektname
            AND 
            geotope_quelle.alte_inventar_nummer = hoehlen.ingesonr_alt
    LEFT JOIN fachbereich
        ON hoehlen.fachbereich1 = fachbereich.code_id
WHERE
    hoehlen."archive" = 0
    AND
    hoehlen.fachbereich1 IS NOT NULL
    AND
    hoehlen.objektart_spez = 425

UNION ALL

SELECT
    geotope_quelle.t_id AS quelle,
    fachbereich.t_id AS fachbereich
FROM afu_geotope.geotope_quelle
    LEFT JOIN ingeso.hoehlen
        ON 
            geotope_quelle.objektname = hoehlen.objektname
            AND 
            geotope_quelle.alte_inventar_nummer = hoehlen.ingesonr_alt
    LEFT JOIN fachbereich
        ON hoehlen.fachbereich2 = fachbereich.code_id
WHERE
    hoehlen."archive" = 0
    AND
    hoehlen.fachbereich2 IS NOT NULL
    AND
    hoehlen.objektart_spez = 425

UNION ALL

SELECT
    geotope_quelle.t_id AS quelle,
    fachbereich.t_id AS fachbereich
FROM afu_geotope.geotope_quelle
    LEFT JOIN ingeso.hoehlen
        ON 
            geotope_quelle.objektname = hoehlen.objektname
            AND 
            geotope_quelle.alte_inventar_nummer = hoehlen.ingesonr_alt
    LEFT JOIN fachbereich
        ON hoehlen.fachbereich3 = fachbereich.code_id
WHERE
    hoehlen."archive" = 0
    AND
    hoehlen.fachbereich3 IS NOT NULL
    AND
    hoehlen.objektart_spez = 425
;