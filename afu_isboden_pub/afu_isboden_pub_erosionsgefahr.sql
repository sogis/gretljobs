SELECT
  ogc_fid,
  wkb_geometry,
  grid_code
FROM
  afu_isboden.erosionsgefahr_qgis_server_client_t
WHERE 
  archive = 0
