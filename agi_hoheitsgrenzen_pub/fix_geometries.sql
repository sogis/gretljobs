UPDATE 
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze SET geometrie = ST_Multi(ST_ReducePrecision(geometrie, 0.001))
;

UPDATE 
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze_generalisiert SET geometrie = ST_Multi(ST_ReducePrecision(geometrie, 0.001))
;

UPDATE 
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_bezirksgrenze SET geometrie = ST_Multi(ST_ReducePrecision(geometrie, 0.001))
;

UPDATE 
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_bezirksgrenze_generalisiert SET geometrie = ST_Multi(ST_ReducePrecision(geometrie, 0.001))
;

UPDATE 
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze SET geometrie = ST_Multi(ST_ReducePrecision(geometrie, 0.001))
;

UPDATE 
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze_generalisiert SET geometrie = ST_Multi(ST_ReducePrecision(geometrie, 0.001))
;
