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
        foto1 IS NOT NULL
    
    UNION ALL
    
    SELECT 
        hoehlen.ingeso_oid,
        hoehlen.ingesonr_alt,
        hoehlen.foto1_name
    FROM
        ingeso.hoehlen
    WHERE
        hoehlen."archive" = 0
        AND
        foto1 IS NOT NULL
    
    UNION ALL
    
    SELECT 
        erratiker.ingeso_oid,
        erratiker.ingesonr_alt,
        erratiker.foto1_name
    FROM
        ingeso.erratiker
    WHERE
        erratiker."archive" = 0
        AND
        foto1 IS NOT NULL
    
    UNION ALL
    
    SELECT 
        landsformen.ingeso_oid,
        landsformen.ingesonr_alt,
        landsformen.foto1_name
    FROM
        ingeso.landsformen
    WHERE
        landsformen."archive" = 0
        AND
        foto1 IS NOT NULL

    UNION ALL
    
    SELECT 
        fundstl_grabungen.ingeso_oid,
        fundstl_grabungen.ingesonr_alt,
        fundstl_grabungen.foto1_name
    FROM
        ingeso.fundstl_grabungen
    WHERE
        fundstl_grabungen."archive" = 0
        AND
        foto1 IS NOT NULL
    
    UNION ALL
    
    SELECT 
        aufschluesse.ingeso_oid,
        aufschluesse.ingesonr_alt,
        aufschluesse.foto2_name
    FROM
        ingeso.aufschluesse
    WHERE
        aufschluesse."archive" = 0
        AND
        foto2 IS NOT NULL
    
    UNION ALL
    
    SELECT 
        hoehlen.ingeso_oid,
        hoehlen.ingesonr_alt,
        hoehlen.foto2_name
    FROM
        ingeso.hoehlen
    WHERE
        hoehlen."archive" = 0
        AND
        foto2 IS NOT NULL
    
    UNION ALL
    
    SELECT 
        erratiker.ingeso_oid,
        erratiker.ingesonr_alt,
        erratiker.foto2_name
    FROM
        ingeso.erratiker
    WHERE
        erratiker."archive" = 0
        AND
        foto2 IS NOT NULL
    
    UNION ALL
    
    SELECT 
        landsformen.ingeso_oid,
        landsformen.ingesonr_alt,
        landsformen.foto2_name
    FROM
        ingeso.landsformen
    WHERE
        landsformen."archive" = 0
        AND
        foto2 IS NOT NULL

    UNION ALL
    
    SELECT 
        fundstl_grabungen.ingeso_oid,
        fundstl_grabungen.ingesonr_alt,
        fundstl_grabungen.foto2_name
    FROM
        ingeso.fundstl_grabungen
    WHERE
        fundstl_grabungen."archive" = 0
        AND
        foto2 IS NOT NULL
),
dokumente AS (
    SELECT
        dokument_name
    FROM
        ingeso.dokumente
    WHERE
        "archive" = 0
),
rrbs AS (
    SELECT 
        trim(regexp_split_to_table(aufschluesse.rrb_nr, E'\\,')) AS rrb_nr,
        trim(regexp_split_to_table(aufschluesse.rrb_date, E'\\,')) AS rrb_date
    FROM
        ingeso.aufschluesse
    WHERE
        rrb_nr != ''
        AND
        aufschluesse."archive" = 0
        AND
        trim(aufschluesse.rrb_date) != ''

    UNION

    SELECT
        trim(regexp_split_to_table(erratiker.rrb_nr, E'\\,')),
        trim(regexp_split_to_table(erratiker.rrb_date, E'\\,'))
    FROM
        ingeso.erratiker
    WHERE
        erratiker.rrb_nr != ''
        AND
        erratiker."archive" = 0
        AND
        trim(erratiker.rrb_date) != ''

    UNION

    SELECT
        trim(regexp_split_to_table(fundstl_grabungen.rrb_nr, E'\\,')),
        trim(regexp_split_to_table(fundstl_grabungen.rrb_date, E'\\,'))
    FROM
        ingeso.fundstl_grabungen
    WHERE
        fundstl_grabungen.rrb_nr != ''
        AND
        fundstl_grabungen."archive" = 0
        AND
        trim(fundstl_grabungen.rrb_date) != ''

    UNION

    SELECT
        trim(regexp_split_to_table(hoehlen.rrb_nr, E'\\,')),
        trim(regexp_split_to_table(hoehlen.rrb_date, E'\\,'))
    FROM
        ingeso.hoehlen
    WHERE
        hoehlen.rrb_nr != ''
        AND
        hoehlen."archive" = 0
        AND
        trim(hoehlen.rrb_date) != ''

    UNION

    SELECT
        trim(regexp_split_to_table(regexp_split_to_table(landsformen.rrb_nr, E'\\,'), 'und')),
        trim(regexp_split_to_table(regexp_split_to_table(landsformen.rrb_date, E'\\,'), 'und'))
    FROM
        ingeso.landsformen
    WHERE
        landsformen.rrb_nr != ''
        AND
        landsformen."archive" = 0
        AND
        trim(landsformen.rrb_date) != ''
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
        END AS rrb_date
    FROM
        rrbs
)

SELECT
    rrb_nr AS titel,
    rrb_nr AS offizieller_titel,
    'RRB' AS abkuerzung,
    NULL AS pfad,
    'RRB' AS typ,
    rrb_nr AS offizielle_nr,
    'inKraft' AS rechtsstatus,
    to_date(rrb_date, 'DD.MM.YYYY') AS publiziert_ab
FROM
    correct_rrbs
WHERE
    rrb_nr != '1398'
    AND
    rrb_date != '02.07.2002'
    
UNION

SELECT
    foto_name AS titel,
    foto_name AS offizieller_titel,
    NULL AS abkuerzung,
    concat('documents/ch.so.afu.geotope/', foto_name) AS pfad,
    'Foto' AS typ,
    NULL AS offizielle_nr,
    'inKraft' AS rechtsstatus,
    NULL AS publiziert_ab
FROM
    fotos

UNION

SELECT
    dokument_name AS titel,
    dokument_name AS offizieller_titel,
    NULL AS abkuerzung,
    concat('documents/ch.so.afu.geotope/', dokument_name) AS pfad,
    'Bericht' AS typ,
    NULL AS offizielle_nr,
    'inKraft' AS rechtsstatus,
    NULL AS publiziert_ab
FROM
    dokumente
WHERE
    dokument_name != 'RRB_HuppergrubeRickenbach.pdf'

UNION

SELECT
    dokumente.dokument_name AS titel,
    dokumente.dokument_name AS offizieller_titel,
    'RRB' AS abkuerzung,
    concat('documents/ch.so.afu.geotope/', dokument_name) AS pfad,
    'RRB' AS typ,
    correct_rrbs.rrb_nr AS offizielle_nr,
    'inKraft' AS rechtsstatus,
    to_date(correct_rrbs.rrb_date, 'DD.MM.YYYY') AS publiziert_ab
FROM
    dokumente,
    correct_rrbs
WHERE
    dokumente.dokument_name = 'RRB_HuppergrubeRickenbach.pdf'
    AND
    correct_rrbs.rrb_nr = '1398'
    AND
    correct_rrbs.rrb_date = '02.07.2002'
;