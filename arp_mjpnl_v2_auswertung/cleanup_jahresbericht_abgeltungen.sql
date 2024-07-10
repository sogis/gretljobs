DELETE FROM 
    ${DB_Schema_MJPNL}.auswertung_jahresbericht_abgeltungen
WHERE 
    jahr = ${AUSZAHLUNGSJAHR}::integer;