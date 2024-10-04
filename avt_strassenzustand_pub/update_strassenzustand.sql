DELETE FROM avt_strassenzustand_staging_v1.strassenzustand WHERE "geometrie" IS NULL;

UPDATE
    avt_strassenzustand_staging_v1.strassenzustand
SET
    "geometrie" = ST_SnapToGrid("geometrie", 0.001)
;