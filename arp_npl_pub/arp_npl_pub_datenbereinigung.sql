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
