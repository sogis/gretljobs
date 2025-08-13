ALTER TABLE export.wohnung 
    ADD COLUMN schild_uuid UUID;

UPDATE export.wohnung g
    SET schild_uuid = z.schild_uuid
    FROM export.zonenschild_geoms z
    WHERE ST_Within(g.geometrie, z.geometrie)
;

CREATE INDEX
    ON export.wohnung(schild_uuid)
;