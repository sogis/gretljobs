SELECT
  ogc_fid,
  wkb_geometry,
  fallrtg,
  fall,
  symbol,
  "label"
FROM
  geologie.sfall
WHERE
  archive = 0