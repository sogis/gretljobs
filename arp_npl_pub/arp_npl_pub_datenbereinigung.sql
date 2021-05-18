-- Erschliessung Linienobjekt
-- Remove nan coordinates
-- TODO: this needs an update after Postgis 3.1 and GEOS 3.9 was deployed
-- ST_MakeValid() should then properly handle NaN stuff
UPDATE
 arp_npl_pub.nutzungsplanung_erschliessung_linienobjekt
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
   FROM arp_npl_pub.nutzungsplanung_erschliessung_linienobjekt
   WHERE
     ST_IsValid(geometrie) = False AND ST_IsValidReason(geometrie) ~* 'Too few points in geometry'
;

-- Grundnutzung
-- remove Polygon geometries with too few points
DELETE
   FROM arp_npl_pub.nutzungsplanung_grundnutzung
   WHERE
     ST_IsValid(geometrie) = False AND ST_IsValidReason(geometrie) ~* 'Too few points in geometry'
;

-- Überlagernd Fläche
-- remove Polygon geometries with too few points
DELETE
   FROM arp_npl_pub.nutzungsplanung_ueberlagernd_flaeche
   WHERE
     ST_IsValid(geometrie) = False AND ST_IsValidReason(geometrie) ~* 'Too few points in geometry'
;

-- Überlagernd Linie
-- Remove nan coordinates
UPDATE
 arp_npl_pub.nutzungsplanung_ueberlagernd_linie
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
