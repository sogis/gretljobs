SELECT 
  ogc_fid, 
  wkb_geometry, 
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

