DELETE FROM 
    ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_bewirtschafter
WHERE 
    auszahlungsjahr = ( SELECT date_part('year', now())::integer );