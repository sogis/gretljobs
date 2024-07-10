DELETE FROM 
    ${DB_Schema_MJPNL}.auswertung_snapshot_weide
WHERE
    jahr = ${AUSZAHLUNGSJAHR}::integer;