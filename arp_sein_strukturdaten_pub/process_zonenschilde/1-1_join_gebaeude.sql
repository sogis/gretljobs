-- GWR Daten mit Zonenschild-ID anreichern

ALTER TABLE export.gebaeude 
    ADD COLUMN schild_uuid UUID;

UPDATE export.gebaeude g
    SET schild_uuid = z.schild_uuid
    FROM export.zonenschild_geoms z
    WHERE ST_Within(g.geometrie, z.geometrie)
;

CREATE INDEX
    ON export.gebaeude(schild_uuid)
;