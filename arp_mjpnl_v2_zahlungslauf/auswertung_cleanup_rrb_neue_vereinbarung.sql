-- wir löschen alle "aktuellen", heisst die ohne oder mit diesjährigem publikationsjahr (weil wir die wieder abfüllen)
DELETE FROM 
    ${DB_Schema_MJPNL}.auswertung_rrb_neue_vereinbarung
WHERE 
    jahr = ${AUSZAHLUNGSJAHR}::integer or jahr IS NULL;