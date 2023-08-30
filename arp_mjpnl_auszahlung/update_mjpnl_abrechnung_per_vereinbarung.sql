/*
Setzt Status der Abrechnungen pro Vereinbarung auf ausbezahlt, sofern freigegeben.
*/

UPDATE
    ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_vereinbarung
SET
    status_abrechnung = 'ausbezahlt'
WHERE 
    auszahlungsjahr = ${AUSZAHLUNGSJAHR}::integer
    AND 
    status_abrechnung = 'freigegeben'
