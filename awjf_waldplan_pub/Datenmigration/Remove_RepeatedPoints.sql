-- Punkte entfernen, die näher als z.B. 0.001 Einheiten sind
UPDATE awjf_waldplan_v2.waldplan_waldfunktion
SET geometrie = ST_RemoveRepeatedPoints(geometrie, 0.001);

-- Punkte entfernen, die näher als z.B. 0.001 Einheiten sind
UPDATE awjf_waldplan_v2.waldplan_waldnutzung
SET geometrie = ST_RemoveRepeatedPoints(geometrie, 0.001);