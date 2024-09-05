DELETE FROM avt_mehrjahresplanung_pub_v1.strassenzustand WHERE "geometrie" IS NULL;

UPDATE
    avt_mehrjahresplanung_pub_v1.strassenzustand
SET
    "geometrie" = ST_SnapToGrid("geometrie", 0.001);