UPDATE 
  simi.simitheme_published_sub_area p
SET 
  sub_area_ident = null,
  sub_area_id = s.id 
FROM  
  simi.simitheme_sub_area s,
  simi.simitheme_theme_publication t
WHERE 
    p.sub_area_ident = s.identifier 
  AND 
    p.theme_publication_id = t.id
  AND 
    s.coverage_ident = t.coverage_ident 
;