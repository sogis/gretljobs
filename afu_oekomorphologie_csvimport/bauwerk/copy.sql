SET search_path TO 'afu_fliessgewaesser_v1';

INSERT INTO
  bauwerk(
    geometrie, 
    importdatum,
    rgewaesser, 
    bauwerknr, 
    typ, 
    hoehe, 
    erhebungsdatum
  )
SELECT
    punktberechnet AS geometrie,
    current_date AS importdatum,
    rgewaesser, 
    bauwerknr, 
    typ, 
    hoehe, 
    erhebungsdatum
FROM 
  bauwerkcsv
;