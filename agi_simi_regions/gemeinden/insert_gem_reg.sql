SELECT 
  t_ili_tid,
  ${tid}::integer AS rdatenabdeckung,
  geometrie AS apolygon,
  bfs_gemeindenummer::varchar AS identifier,
  gemeindename AS bezeichnung
FROM 
  agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze
