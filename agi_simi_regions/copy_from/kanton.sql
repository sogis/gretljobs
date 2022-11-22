SELECT 
  uuid_generate_v4 () AS id,
  --kantonskuerzel AS identifier, 
  'so' AS identifier, 
  kantonsname AS title,
  st_asbinary(geometrie) AS geom_wkb,
  localtimestamp AS updated,
  'kanton' AS coverage_ident
FROM 
  agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze;