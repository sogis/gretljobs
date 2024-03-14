WITH 

enum_map AS (
  SELECT 
    *
  FROM (
    VALUES 
    ('naturnah','naturnah'),
    ('bedingt naturnah','bedingt_naturnah'),
    ('mässig beeinträchtigt','maessig_beeintraechtigt'),
    ('geschädigt','geschaedigt'),
    ('stark geschädigt','stark_geschaedigt')
  ) t(txt, enumval)  
),

mapped AS (
  SELECT 
    COALESCE(m.enumval, '!ERR!') AS enumval,
    c.t_id
  FROM 
    afu_quellen_ungefasst_staging_v1.csv_import c
  LEFT JOIN
    enum_map m ON c.gesamtbewertung_csv = m.txt
)

UPDATE 
  afu_quellen_ungefasst_staging_v1.csv_import
SET 
  gesamtbewertung = m.enumval
FROM 
  mapped m
WHERE 
  csv_import.t_id = m.t_id
;