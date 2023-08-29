DELETE FROM 
    ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung 
WHERE 
    auszahlungsjahr = ${AUSZAHLUNGSJAHR}::integer
    AND NOT einmalig; -- denn diese wurden manuell erfasst