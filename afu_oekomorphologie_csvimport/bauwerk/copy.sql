SET search_path TO ${dbSchema};

INSERT INTO
  bauwerk(
    geometrie, 
    importdatum,
    rgewaesser, 
    typ, 
    hoehe, 
    erhebungsdatum
  )
SELECT
    punktberechnet AS geometrie,
    current_date AS importdatum,
    rgewaesser, 
    typ, 
    hoehe, 
    erhebungsdatum
FROM 
  bauwerkcsv
;