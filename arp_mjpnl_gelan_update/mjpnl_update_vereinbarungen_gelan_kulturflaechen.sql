--Kultur_Ids zuweisen
UPDATE ${DB_Schema_MJPNL}.mjpnl_vereinbarung AS vbg
SET kultur_id=(
    SELECT array_agg(kf.kultur_id) AS kultur_id
    FROM ${DB_Schema_MJPNL}.betrbsdttrktrdten_kultur_flaechen kf
    WHERE
        ST_Intersects(kf.geometrie,vbg.geometrie)
        AND
        (ST_MaximumInscribedCircle(ST_Intersection(kf.geometrie,vbg.geometrie))).radius > 1
);