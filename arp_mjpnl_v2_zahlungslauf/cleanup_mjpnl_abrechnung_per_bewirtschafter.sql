DELETE FROM 
    ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_bewirtschafter
WHERE 
    auszahlungsjahr = ${AUSZAHLUNGSJAHR}::integer;