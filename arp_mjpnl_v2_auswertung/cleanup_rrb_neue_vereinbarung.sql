DELETE FROM 
    ${DB_Schema_MJPNL}.auswertung_rrb_neue_vereinbarung
WHERE 
    jahr = ${AUSZAHLUNGSJAHR}::integer;