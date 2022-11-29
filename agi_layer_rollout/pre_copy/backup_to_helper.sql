INSERT INTO 
  simi.simitheme_published_sub_area_helper(
    subarea_coverage_ident,
    subarea_identifier,
    theme_identifier,
    tpub_data_class,
    tpub_class_suffix_override,
    published,
    prev_published,
    id,
    update_ts,
    updated_by,
    create_ts,
    created_by,
    "version"
  )
SELECT 
  s.coverage_ident AS subarea_coverage_ident, 
  s.identifier AS subarea_identifier,
  t.identifier AS theme_identifier,
  tp.data_class AS tpub_data_class,
  tp.class_suffix_override AS tpub_class_suffix_override,
  p.published,
  p.prev_published,
  p.id,
  p.update_ts,
  p.updated_by,
  p.create_ts,
  p.created_by,
  p."version"
FROM 
  simi.simitheme_published_sub_area p
JOIN
  simi.simitheme_sub_area s ON p.sub_area_id = s.id
JOIN
  simi.simitheme_theme_publication tp ON p.theme_publication_id = tp.id 
JOIN 
  simi.simitheme_theme t ON tp.theme_id = t.id
;
