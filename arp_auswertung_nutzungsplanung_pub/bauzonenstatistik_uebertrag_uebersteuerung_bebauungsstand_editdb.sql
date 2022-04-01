SELECT 
  bebaut, 
  geometrie 
FROM 
  ${DB_Schema_Uebersteuerung}.bauzonenstatistik_uebersteuerung_bebauungsstand_liegenschaft 
WHERE 
  geometrie IS NOT NULL;
