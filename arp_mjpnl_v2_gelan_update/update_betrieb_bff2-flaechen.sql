UPDATE 
  ${DB_Schema_MJPNL}.bff_qualitaet_bff_qualitaet AS bff 
SET 
  betrieb = bewe.betrieb 
FROM 
  ${DB_Schema_MJPNL}.betrbsdttrktrdten_bewirtschaftungseinheit AS bewe 
WHERE 
  ST_IsValid(bff.geometrie) = TRUE 
  AND
  ST_WITHIN(
    ST_PointOnSurface(bff.geometrie), 
    bewe.geometrie
  )
;
