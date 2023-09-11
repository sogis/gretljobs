WITH 

theme_referenced_areas AS (
    SELECT 
        s.coverage_ident,
        s.identifier AS area_ident
    FROM 
        simi.simitheme_sub_area s
    JOIN
        simi.simitheme_theme_publication t ON s.coverage_ident = t.coverage_ident 
    GROUP BY 
       s.coverage_ident, s.identifier
)

SELECT 
    concat_ws(':', r.coverage_ident, r.area_ident)  AS sub_area_ident 
FROM 
    theme_referenced_areas r
LEFT JOIN 
    simi.simitheme_published_sub_area_helper h
        ON 
                r.coverage_ident = h.subarea_coverage_ident
            AND 
                r.area_ident = h.subarea_identifier
WHERE
    h.subarea_identifier IS NULL -- Gibt es auf prod nicht
;