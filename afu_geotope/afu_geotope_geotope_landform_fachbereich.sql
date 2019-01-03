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
    geotope_landschaftsform.t_id AS landform,
    fachbereich.t_id AS fachbereich
FROM afu_geotope.geotope_landschaftsform
    LEFT JOIN ingeso.landsformen
        ON 
            geotope_landschaftsform.nummer = landsformen.ingeso_oid::varchar
            AND 
            geotope_landschaftsform.alte_inventar_nummer = landsformen.ingesonr_alt
    LEFT JOIN fachbereich
        ON landsformen.fachbereich1 = fachbereich.code_id
WHERE
    landsformen."archive" = 0
    AND
    landsformen.fachbereich1 IS NOT NULL

UNION ALL

SELECT
    geotope_landschaftsform.t_id AS landform,
    fachbereich.t_id AS fachbereich
FROM afu_geotope.geotope_landschaftsform
    LEFT JOIN ingeso.landsformen
        ON 
            geotope_landschaftsform.nummer = landsformen.ingeso_oid::varchar
            AND 
            geotope_landschaftsform.alte_inventar_nummer = landsformen.ingesonr_alt
    LEFT JOIN fachbereich
        ON landsformen.fachbereich2 = fachbereich.code_id
WHERE
    landsformen."archive" = 0
    AND
    landsformen.fachbereich2 IS NOT NULL

UNION ALL

SELECT
    geotope_landschaftsform.t_id AS landform,
    fachbereich.t_id AS fachbereich
FROM afu_geotope.geotope_landschaftsform
    LEFT JOIN ingeso.landsformen
        ON 
            geotope_landschaftsform.nummer = landsformen.ingeso_oid::varchar
            AND 
            geotope_landschaftsform.alte_inventar_nummer = landsformen.ingesonr_alt
    LEFT JOIN fachbereich
        ON landsformen.fachbereich3 = fachbereich.code_id
WHERE
    landsformen."archive" = 0
    AND
    landsformen.fachbereich3 IS NOT NULL
;