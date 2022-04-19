SET search_path TO ${dbSchema};

WITH 

basis_tid AS (
  SELECT 
    COALESCE(b.t_id, -c.gnrso) AS basis_tid, -- Falls JOIN nicht möglich absichtlich auf -gnrso setzen, damit Skript mit Fehler abbricht.
    c.t_id AS csv_tid
  FROM 
    oekomorphcsv c
  LEFT JOIN
    gewaesserbasisgeometrie b ON c.gnrso = b.gnrso 
)

UPDATE 
  oekomorphcsv 
SET 
  rgewaesser = basis_tid
FROM 
  basis_tid b
WHERE 
  t_id = b.csv_tid 
;
