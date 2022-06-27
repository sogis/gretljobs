UPDATE awjf_schutzwald_v1.behandelte_flaeche
    SET geometrie = ST_Multi(ST_RemoveRepeatedPoints(ST_ReducePrecision(ST_Buffer(geometrie, 0.001), 0.001), 0.001))
;

UPDATE awjf_schutzwald_v1.schutzwald
    SET geometrie = ST_Multi(ST_RemoveRepeatedPoints(ST_ReducePrecision(ST_Buffer(geometrie, 0.001), 0.001), 0.001))
;

UPDATE awjf_schutzwald_v1.schutzwald_info
    SET geometrie = ST_RemoveRepeatedPoints(ST_ReducePrecision(ST_Buffer(geometrie, 0.001), 0.001), 0.001)
;
