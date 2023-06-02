-- Füge den migrierten Daten den korrekten Basket (der vom Topic MJPNL) zu 
UPDATE ${DB_Schema_MJPNL}.mjpnl_vereinbarung
SET t_basket = (SELECT t_id FROM ${DB_Schema_MJPNL}.t_ili2db_basket WHERE topic = 'SO_ARP_MJPNL_20201026.MJPNL' LIMIT 1);

UPDATE ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung
SET t_basket = (SELECT t_id FROM ${DB_Schema_MJPNL}.t_ili2db_basket WHERE topic = 'SO_ARP_MJPNL_20201026.MJPNL' LIMIT 1);

-- Lösche Dummy-Basket
DELETE FROM ${DB_Schema_MJPNL}.t_ili2db_basket WHERE t_id = 9999999;
