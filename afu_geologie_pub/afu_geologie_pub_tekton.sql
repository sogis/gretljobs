SELECT 
  ogc_fid,
  wkb_geometry,
  symbol
FROM
  geologie.tekton
WHERE
  archive = 0