UPDATE
    av.bodenbedeckung_boflaeche
SET
    geometrie = ST_Buffer(geometrie, 10)
;
