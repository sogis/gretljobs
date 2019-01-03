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
    geotope_aufschluss.t_id AS aufschluss,
    fachbereich.t_id AS fachbereich
FROM afu_geotope.geotope_aufschluss
    LEFT JOIN ingeso.aufschluesse
        ON 
            geotope_aufschluss.nummer = aufschluesse.ingeso_oid::varchar
            AND 
            geotope_aufschluss.alte_inventar_nummer = aufschluesse.ingesonr_alt
    LEFT JOIN fachbereich
        ON aufschluesse.fachbereich1 = fachbereich.code_id
WHERE
    aufschluesse."archive" = 0
    AND
    aufschluesse.fachbereich1 IS NOT NULL

UNION ALL

SELECT
    geotope_aufschluss.t_id AS aufschluss,
    fachbereich.t_id AS fachbereich
FROM afu_geotope.geotope_aufschluss
    LEFT JOIN ingeso.aufschluesse
        ON 
            geotope_aufschluss.nummer = aufschluesse.ingeso_oid::varchar
            AND 
            geotope_aufschluss.alte_inventar_nummer = aufschluesse.ingesonr_alt
    LEFT JOIN fachbereich
        ON aufschluesse.fachbereich2 = fachbereich.code_id
WHERE
    aufschluesse."archive" = 0
    AND
    aufschluesse.fachbereich2 IS NOT NULL

UNION ALL

SELECT
    geotope_aufschluss.t_id AS aufschluss,
    fachbereich.t_id AS fachbereich
FROM afu_geotope.geotope_aufschluss
    LEFT JOIN ingeso.aufschluesse
        ON 
            geotope_aufschluss.nummer = aufschluesse.ingeso_oid::varchar
            AND 
            geotope_aufschluss.alte_inventar_nummer = aufschluesse.ingesonr_alt
    LEFT JOIN fachbereich
        ON aufschluesse.fachbereich3 = fachbereich.code_id
WHERE
    aufschluesse."archive" = 0
    AND
    aufschluesse.fachbereich3 IS NOT NULL
;