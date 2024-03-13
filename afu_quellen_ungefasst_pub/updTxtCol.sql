SET search_path TO ${dbSchema}, public;

WITH 

codemap AS (
  SELECT 
    ilicode,
    dispname
  FROM 
    bewertung
)

UPDATE 
  quelle_ungefasst 
SET 
  gesamtbewertung_txt = dispname
FROM 
  codemap
WHERE 
  gesamtbewertung = ilicode
;