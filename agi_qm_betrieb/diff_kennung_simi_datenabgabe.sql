LOAD spatial;

ATTACH ${connectionStringSimi} AS simidb (TYPE POSTGRES, READ_ONLY);

-- Publizierte Gebiete
DROP TABLE IF EXISTS diffKennungSimiDatenabgabe;
CREATE TEMP TABLE diffKennungSimiDatenabgabe AS 
WITH published_sub_area AS
(
    SELECT DISTINCT 
        theme_publication_id,
        spsa.published
    FROM 
        simidb.simi.simitheme_published_sub_area AS spsa 
)
,
-- Themenbereitstellung mit Publikation
theme_publication AS
(
    SELECT
        stp.id,
        stp.theme_id,
        stp.data_class,
        stp.class_suffix_override,
        spsa.published
    FROM 
        simidb.simi.simitheme_theme_publication AS stp 
        LEFT JOIN published_sub_area AS spsa 
        ON spsa.theme_publication_id = stp.id 
    WHERE 
        spsa.published IS NOT NULL 
    --GROUP BY stp.id, spsa.published
)
,
-- Themen und ihre Themenbereitstellungen mit Publikation.
simitheme_theme AS
(
    SELECT 
        st.identifier,
        stp.class_suffix_override,
        CASE 
            WHEN stp.class_suffix_override IS NOT NULL
                THEN concat(st.identifier, '.' , stp.class_suffix_override)
            ELSE st.identifier
        END AS kennung,
        stp.data_class,
        stp.published,
        stp.id 
    FROM 
        simidb.simi.simitheme_theme AS st
        LEFT JOIN theme_publication AS stp 
        ON stp.theme_id = st.id
    WHERE 
        st.identifier NOT like ('orgtheme.%') AND st.identifier NOT IN ('theme.from.migration') AND stp.published IS NOT NULL 
    ORDER BY 
        kennung ASC 
)

SELECT 
    DISTINCT kennung
FROM 
    simitheme_theme
ORDER BY 
    kennung ASC 
;

DROP TABLE IF EXISTS myresult_diff;
CREATE TEMP TABLE myresult_diff AS 
(
    SELECT 
        kennung,
        'Datenablage minus SIMI' AS kategorie
    FROM 
        '/tmp/sftpDirectoriesList.csv'

    EXCEPT

    SELECT 
        kennung,
        'Datenablage minus SIMI' AS kategorie
    FROM 
        diffKennungSimiDatenabgabe
)
UNION ALL
(
    SELECT 
        kennung,
        'SIMI minus Datenablage' AS kategorie
    FROM 
        diffKennungSimiDatenabgabe

    EXCEPT

    SELECT 
        kennung,
        'SIMI minus Datenablage' AS kategorie
    FROM 
        '/tmp/sftpDirectoriesList.csv'
)
;

COPY (SELECT * FROM myresult_diff) TO 'diff_kennung_simi_datenabgabe.xlsx' WITH (FORMAT GDAL, DRIVER 'xlsx');

