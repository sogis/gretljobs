-- STATENT Daten mit Zonenschild-ID anreichern

ALTER TABLE export.statent 
    ADD COLUMN schild_uuid UUID;

UPDATE export.statent s
    SET schild_uuid = z.schild_uuid
    FROM export.zonenschild_geoms z
    WHERE ST_Within(s.geometrie, z.geometrie)
;

CREATE INDEX
    ON export.statent(schild_uuid)
;