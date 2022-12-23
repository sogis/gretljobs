UPDATE 
  ${DB_Schema_QRcat}.onlinerisk_betrieb b 
SET 
  anzahl_szenarien_brand = (
    SELECT 
      count(*) 
    FROM 
      ${DB_Schema_QRcat}.qrcat_szenario sz 
    WHERE 
      sz.id_betrieb = b.t_id 
      AND sz.szenario_art = 'Brand'
  ), 
  anzahl_szenarien_explosion = (
    SELECT 
      count(*) 
    FROM 
      ${DB_Schema_QRcat}.qrcat_szenario sz 
    WHERE 
      sz.id_betrieb = b.t_id 
      AND sz.szenario_art = 'Explosion'
  ), 
  anzahl_szenarien_toxische_wolke = (
    SELECT 
      count(*) 
    FROM 
      ${DB_Schema_QRcat}.qrcat_szenario sz 
    WHERE 
      sz.id_betrieb = b.t_id 
      AND sz.szenario_art = 'toxische_Wolke'
  );
