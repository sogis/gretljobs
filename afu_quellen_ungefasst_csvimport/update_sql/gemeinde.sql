WITH 

quell_gemeinde AS (
  SELECT 
    COALESCE(g.gemeindename, '!ERR!') AS gemname,
    q.t_id
  FROM 
    afu_quellen_ungefasst_staging_v1.csv_import q
  LEFT JOIN
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze g ON st_within(q.punkt, g.geometrie)
)

UPDATE 
  afu_quellen_ungefasst_staging_v1.csv_import
SET 
  gemeindename = gemname
FROM 
  quell_gemeinde qg
WHERE 
  csv_import.t_id = qg.t_id
;