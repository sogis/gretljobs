DELETE FROM 
    ${DB_Schema_MJPNL}.auswertung_snapshot_wiese
WHERE
    jahr = ${AUSZAHLUNGSJAHR}::integer;