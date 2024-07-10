/*
Setzt Status und Datum der Abrechnungen pro Vereinbarung auf ausbezahlt, sofern freigegeben.
*/

UPDATE
    ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_vereinbarung
SET
    status_abrechnung = 'ausbezahlt',
    datum_abrechnung = (${AUSZAHLUNGSJAHR} || '-12-15')::date
WHERE 
    auszahlungsjahr = ${AUSZAHLUNGSJAHR}::integer
    AND 
    status_abrechnung = 'freigegeben'
