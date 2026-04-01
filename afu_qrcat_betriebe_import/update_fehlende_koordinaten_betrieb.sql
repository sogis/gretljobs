-- First run, try to update with coordinate values from untersuchungseinheit
UPDATE 
  ${DB_Schema_QRcat}.onlinerisk_betrieb b 
SET 
  geometrie = (
    SELECT 
      ST_GeometricMedian(
        ST_Union(ue.geometrie)
      ) 
    FROM 
      ${DB_Schema_QRcat}.onlinerisk_untersuchungseinheit ue 
    WHERE 
      ue.id_betrieb = b.t_id 
      AND ue.geometrie IS NOT NULL 
    GROUP BY 
      ue.id_betrieb
  ) 
WHERE 
  b.geometrie IS NULL;

-- second run, try to update with coordinate values FROM gebaeude
UPDATE 
  ${DB_Schema_QRcat}.onlinerisk_betrieb b 
SET 
  geometrie = (
    SELECT 
      ST_GeometricMedian(
        ST_Union(g.geometrie)
      ) 
    FROM 
      ${DB_Schema_QRcat}.onlinerisk_untersuchungseinheit ue 
      LEFT JOIN ${DB_Schema_QRcat}.onlinerisk_gebaeude g ON g.id_untersuchungseinheit = ue.t_id 
    WHERE 
      ue.id_betrieb = b.t_id 
      AND g.geometrie IS NOT NULL 
    GROUP BY 
      ue.id_betrieb, 
      g.id_untersuchungseinheit
  ) 
WHERE 
  b.geometrie IS NULL;

-- third run, try to update with coordinate values FROM bereich
UPDATE 
  ${DB_Schema_QRcat}.onlinerisk_betrieb b 
SET 
  geometrie = (
    SELECT 
      ST_GeometricMedian(
        ST_Union(ber.geometrie)
      ) 
    FROM 
      ${DB_Schema_QRcat}.onlinerisk_untersuchungseinheit ue 
      LEFT JOIN ${DB_Schema_QRcat}.onlinerisk_gebaeude g ON g.id_untersuchungseinheit = ue.t_id 
      LEFT JOIN ${DB_Schema_QRcat}.onlinerisk_bereich ber ON ber.id_gebaeude = g.t_id 
    WHERE 
      ue.id_betrieb = b.t_id 
      AND g.geometrie IS NOT NULL 
    GROUP BY 
      ue.id_betrieb
  ) 
WHERE 
  b.geometrie IS NULL;
