DELETE FROM 
    ${DB_Schema_MJPNL}.auswertung_snapshot_wbl_wiese
WHERE
    jahr = ${AUSZAHLUNGSJAHR}::integer;