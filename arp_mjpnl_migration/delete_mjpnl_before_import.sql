-- delete previous data that should be replaced
DELETE FROM ${DB_Schema_MJPNL}.mjpnl_beurteilung_wiese WHERE operator_erstellung = 'Migration';
DELETE FROM ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung;
DELETE FROM ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_vereinbarung;
DELETE FROM ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_bewirtschafter;
DELETE FROM ${DB_Schema_MJPNL}.mjpnl_vereinbarung WHERE mjpnl_version = 'MJPNL_2020';
DELETE FROM ${DB_Schema_MJPNL}.t_ili2db_basket WHERE t_id = 9999999;
DELETE FROM ${DB_Schema_MJPNL}.umweltziele_uzl_subregion WHERE t_id = 9999999;
