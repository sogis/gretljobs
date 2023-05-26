UPDATE
     ${DB_Schema_MJPNL}.mjpnl_vereinbarung vb
  SET
     uzl_subregion = uzl.t_id
  FROM ${DB_Schema_MJPNL}.umweltziele_uzl_subregion uzl
    WHERE ST_Within(ST_PointOnSurface(vb.geometrie),uzl.geometrie)
;
