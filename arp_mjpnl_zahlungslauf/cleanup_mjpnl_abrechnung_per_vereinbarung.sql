DELETE FROM 
    ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_vereinbarung
WHERE 
    auszahlungsjahr = ${AUSZAHLUNGSJAHR}::integer;