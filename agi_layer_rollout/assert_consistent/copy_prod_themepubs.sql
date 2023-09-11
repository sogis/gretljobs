-- Auf Prod vorhandene publizierte Themepubs zwecks Konsistenzvergleich in Helper auf Integration kopieren.
WITH 

published_themepubs AS (
    SELECT 
        theme_publication_id
    FROM 
        simi.simitheme_published_sub_area
    GROUP BY 
        theme_publication_id 
)

SELECT 
    concat(t.identifier, '.' || class_suffix_override) AS theme_identifier,
  
    -- Ausgabe der folgenden Felder nur zwecks Schema-Kompatibilität mit Helper.
    tp.id,
    1 AS version,
    cast('1999-11-11' AS timestamp) AS published,
    cast('1999-11-11' AS timestamp) AS prev_published,
    'dummy' AS tpub_data_class,
    'dummy' AS subarea_coverage_ident, 
    'dummy' AS subarea_identifier
FROM
    simi.simitheme_theme_publication tp 
JOIN 
    simi.simitheme_theme t ON tp.theme_id = t.id 
JOIN 
    published_themepubs pt ON tp.id = pt.theme_publication_id
;