WITH 

themepub_fullident AS (
    SELECT 
        concat(t.identifier, '.' ||  tp.class_suffix_override) AS full_ident
    FROM
        simi.simi.simitheme_theme_publication tp
    JOIN
        simi.simi.simitheme_theme t ON tp.theme_id = t.id 
)

SELECT 
    h.theme_identifier AS sub_area_ident
FROM 
    simi.simitheme_published_sub_area_helper h
LEFT JOIN 
    themepub_fullident tp 
        ON h.theme_identifier = tp.full_ident
WHERE 
    tp.full_ident IS NULL 
;