SET search_path TO ${dbSchema};

INSERT INTO
  absturz(
    geometrie,
    importdatum,
    rgewaesser,
    nummer,
    typ,
    material,
    hoehe,
    erhebungsdatum
  )
SELECT
    punktberechnet AS geometrie,
    current_date AS importdatum,
    rgewaesser,
    nummer,
    typ,
    material,
    hoehe,
    erhebungsdatum
FROM 
  absturzcsv
;
  
 