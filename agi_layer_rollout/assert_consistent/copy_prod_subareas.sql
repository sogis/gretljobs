-- Auf Prod vorhandene Subareas zwecks Konsistenzvergleich in Helper auf Integration kopieren.
SELECT 
  coverage_ident AS subarea_coverage_ident, 
  identifier AS subarea_identifier,
  
  -- Ausgabe der folgenden Felder nur zwecks Schema-Kompatibilität mit Helper.
  id,
  1 AS version,
  cast('1999-11-11' AS timestamp) AS published,
  cast('1999-11-11' AS timestamp) AS prev_published,
  'dummy' AS tpub_data_class,
  'dummy' AS theme_identifier
FROM 
  simi.simitheme_sub_area
;