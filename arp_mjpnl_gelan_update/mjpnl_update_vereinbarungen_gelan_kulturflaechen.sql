--Kultur_Ids zuweisen
UPDATE ${DB_Schema_MJPNL}.mjpnl_vereinbarung AS vbg
SET kultur_id=(
    SELECT array_agg(kf.kultur_id) AS kultur_id
    FROM ${DB_Schema_MJPNL}.betrbsdttrktrdten_kultur_flaechen kf
    WHERE
        ST_IsValid(vbg.geometrie) = TRUE 
        AND
        ST_Intersects(kf.geometrie,vbg.geometrie)
        AND
        (ST_MaximumInscribedCircle(ST_Intersection(kf.geometrie,vbg.geometrie))).radius > 1
WHERE
    -- nur wenn aktuelles Datum nicht zwischen dem 1. Dezember und dem 15. Januar liegt
    (date_part('month',now()) NOT IN (1,12) OR (date_part('month',now())=1 AND date_part('day',now())>15))
);