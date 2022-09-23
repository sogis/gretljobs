SELECT 
  uuid_generate_v4 () AS id,
  bfs_gemeindenummer::varchar AS identifier, 
  gemeindename AS title,
  st_asbinary(geometrie) AS geom_wkb,
  localtimestamp AS updated,
  'av_gem' AS coverage_ident
FROM 
  public.hoheitsgrenzen_gemeindegrenze;