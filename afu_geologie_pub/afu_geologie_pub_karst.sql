SELECT
  ogc_fid,
  wkb_geometry,
  symbol
FROM
  geologie.karst
WHERE
  archive = 0