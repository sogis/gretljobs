UPDATE 
  simi.simitheme_published_sub_area p
SET 
  sub_area_ident = identifier,
  sub_area_id = NULL 
FROM  
  simi.simitheme_sub_area s
WHERE 
  p.sub_area_id = s.id 
;