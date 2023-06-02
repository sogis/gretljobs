
DELETE FROM 
    ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung 
WHERE 
    auszahlungsjahr = ( SELECT date_part('year', now())::integer ) 
    AND migriert IS NOT TRUE;


DELETE FROM 
    ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_vereinbarung
WHERE 
    auszahlungsjahr = ( SELECT date_part('year', now())::integer ) 
    AND migriert IS NOT TRUE;


DELETE FROM 
    ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_bewirtschafter
WHERE 
    auszahlungsjahr = ( SELECT date_part('year', now())::integer ) 
    AND migriert IS NOT TRUE;