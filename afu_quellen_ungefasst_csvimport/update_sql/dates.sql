WITH 

dates AS (
  SELECT 
    to_date(datum_csv, 'DD/MM/YYYY') AS dat,
    to_date(bioerhebung_csv, 'DD/MM/YYYY') AS biodat,
    t_id
  FROM 
    afu_quellen_ungefasst_staging_v1.csv_import
)

UPDATE 
  afu_quellen_ungefasst_staging_v1.csv_import
SET 
  datum = dat,
  bioerhebung = biodat
FROM 
  dates
WHERE 
  csv_import.t_id = dates.t_id
;