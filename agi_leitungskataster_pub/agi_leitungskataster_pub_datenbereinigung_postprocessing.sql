-- elektrizitaet_trasse
-- Remove nan coordinates
UPDATE
 agi_leitungskataster_pub.elektrizitaet_trasse
 SET geometrie =
       ST_GeometryFromText(
         -- remove extra comma at the end of wkt, if nan coordinate is at the end
         regexp_replace(
          -- match and replace nan coordinates
          regexp_replace(ST_AsText(geometrie),'(-nan -nan)+,*','','g'),
          ',\)$',
          ')'
         ),
         2056
       )
  WHERE
   ST_IsValid(geometrie) = False AND ST_IsValidReason(geometrie) ~* 'nan'
;

-- remove LineString geometries with too few points
DELETE
   FROM agi_leitungskataster_pub.elektrizitaet_trasse
   WHERE
     ST_IsValid(geometrie) = False AND ST_IsValidReason(geometrie) ~* 'Too few points in geometry'
