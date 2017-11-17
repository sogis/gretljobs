SELECT 
  ogc_fid AS t_id, 
  wkb_geometry AS geometrie, 
  bgk,
  area,
  perimeter,
  methode,
  shapefile,
  zuordnung,
  agd,
  gz
FROM 
  afu_baugrundklassen
WHERE
  archive = 0
  ;