SELECT 
  uuid_generate_v4 () AS id,
  bfs_gemeindenummer::varchar AS identifier, 
  gemeindename AS title,
  st_asbinary(geometrie) AS geom_wkb,
  localtimestamp AS updated,
  'gemeinden' AS coverage_ident -- must be lowercase
FROM 
  agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze;