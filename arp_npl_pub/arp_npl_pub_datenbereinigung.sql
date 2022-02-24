-- Erschliessung Linienobjekt
-- Remove nan coordinates
UPDATE
 ${dbSchemaNPL}.nutzungsplanung_erschliessung_linienobjekt
 SET geometrie =
       ST_MakeValid(geometrie)
  WHERE
   ST_IsValid(geometrie) = False
;

-- remove LineString geometries with too few points
DELETE
   FROM ${dbSchemaNPL}.nutzungsplanung_erschliessung_linienobjekt
   WHERE
     ST_IsValid(geometrie) = False AND ST_IsValidReason(geometrie) ~* 'Too few points in geometry'
;

-- Grundnutzung
-- remove Polygon geometries with too few points
DELETE
   FROM ${dbSchemaNPL}.nutzungsplanung_grundnutzung
   WHERE
     ST_IsValid(geometrie) = False AND ST_IsValidReason(geometrie) ~* 'Too few points in geometry'
;

-- Überlagernd Fläche
-- remove Polygon geometries with too few points
DELETE
   FROM ${dbSchemaNPL}.nutzungsplanung_ueberlagernd_flaeche
   WHERE
     ST_IsValid(geometrie) = False AND ST_IsValidReason(geometrie) ~* 'Too few points in geometry'
;

-- Überlagernd Linie
-- Remove nan coordinates
UPDATE
 ${dbSchemaNPL}.nutzungsplanung_ueberlagernd_linie
 SET geometrie =
       ST_MakeValid(geometrie)
  WHERE
   ST_IsValid(geometrie) = False
;
