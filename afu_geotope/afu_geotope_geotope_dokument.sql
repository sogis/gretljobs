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
)

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
    'RRB' AS typ,
    NULL AS offizielle_nr,
    'inKraft' AS rechtsstatus,
    NULL AS publiziert_ab
FROM
    dokumente
;