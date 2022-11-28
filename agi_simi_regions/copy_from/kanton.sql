SELECT 
  uuid_generate_v4 () AS id,
  lower(kantonskuerzel) AS identifier, 
  kantonsname AS title,
  st_asbinary(geometrie) AS geom_wkb,
  localtimestamp AS updated,
  'kanton' AS coverage_ident --must be lowercase
FROM 
  agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze;