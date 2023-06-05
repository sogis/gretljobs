UPDATE ${DB_Schema_MJPNL}.mjpnl_vereinbarung
SET geometrie = ST_RemoveRepeatedPoints(geometrie, 0.001);