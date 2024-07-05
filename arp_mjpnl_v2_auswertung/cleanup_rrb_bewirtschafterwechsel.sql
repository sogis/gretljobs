DELETE FROM 
    ${DB_Schema_MJPNL}.auswertung_rrb_bewirtschafterwechsel
WHERE 
    jahr = ${AUSZAHLUNGSJAHR}::integer;