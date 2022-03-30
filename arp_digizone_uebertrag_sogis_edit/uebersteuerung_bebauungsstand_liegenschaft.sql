SELECT 
  wkb_geometry AS geometrie, 
  new_date :: date AS datum_erstellung, 
  NULL :: date AS datum_aenderung 
FROM 
  digizone.bebauung 
WHERE 
  archive = 0 
  AND wkb_geometry IS NOT NULL 
  AND bebaut = True;
