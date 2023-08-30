/*
Setzt Status der Abrechnungen pro Leistung auf ausbezahlt, sofern freigegeben.
*/

UPDATE
    ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung
SET
    status_abrechnung = 'ausbezahlt'
WHERE 
    auszahlungsjahr = ${AUSZAHLUNGSJAHR}::integer
    AND 
    status_abrechnung = 'freigegeben'
