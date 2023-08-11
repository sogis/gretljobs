DELETE FROM 
    ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung 
WHERE 
    auszahlungsjahr = date_part('year', now())::integer
    AND einmalig IS NOT TRUE; -- denn diese wurden manuell erfasst