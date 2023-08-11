/* Da wir idealerweise zuerst die einzelnen Leistungen kalkulieren und dannach die Informationen in den anderenen Tabellen zusammenfassen und die Leistungen dazu linken, brauchen wir dummy entries, damit die FK constraints nicht verletzt werden */

/* Dummy-Entry Abrechnung per Bewirtschafter */
INSERT INTO ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_bewirtschafter
(t_id, t_basket, t_ili_tid, gelan_pid_gelan, gelan_person, gelan_ortschaft, gelan_iban, betrag_total, status_abrechnung, datum_abrechnung, auszahlungsjahr, bemerkung, dateipfad_oder_url, erstellungsdatum, operator_erstellung, aenderungsdatum, operator_aenderung, migriert)
VALUES(9999999, (SELECT t_id FROM ${DB_Schema_MJPNL}.t_ili2db_basket WHERE t_ili_tid = 'SO_ARP_MJPNL_20201026.MJPNL' LIMIT 1), uuid_generate_v4(), (SELECT pid_gelan FROM ${DB_Schema_MJPNL}.betrbsdttrktrdten_gelan_person LIMIT 1), 'Dummy-Name','Dummy-Ortschaft', 'CH16090100565713403', 99, 'freigegeben', '1990-01-01', date_part('year', now())::integer, 'Dummy-Entry', 'Dummy-Pfad', now()::DATE, 'Dummy', NULL, NULL, TRUE);

/* Dummy-Entry Abrechnung per Vereinbarung */
INSERT INTO ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_vereinbarung
(t_id, t_basket, t_ili_tid, vereinbarungs_nr, gelan_pid_gelan, gelan_bewe_id, gb_nr, flurnamen, gemeinde, flaeche, anzahl_baeume, betrag_flaeche, betrag_baeume, betrag_pauschal, gesamtbetrag, auszahlungsjahr, status_abrechnung, datum_abrechnung, bewirtschaftabmachung_messerbalkenmaehgeraet, bewirtschaftabmachung_herbstweide, bemerkung, abrechnungperbewirtschafter, vereinbarung, migriert)
VALUES(9999999, (SELECT t_id FROM ${DB_Schema_MJPNL}.t_ili2db_basket WHERE t_ili_tid = 'SO_ARP_MJPNL_20201026.MJPNL' LIMIT 1), uuid_generate_v4(), '01_DUMMY_00001', (SELECT pid_gelan FROM ${DB_Schema_MJPNL}.betrbsdttrktrdten_gelan_person LIMIT 1), 'GELAN_BEWE_DUMMY', '{"Dummy-GBNr"}', 'Dummy-Flurnamen', 'Dummy-Gemeinde', 99, 0, 99, 0, 0, 99, date_part('year', now())::integer, 'freigegeben', '1990-01-01', FALSE, FALSE, 'Dummy Entry', 9999999, 9999999, TRUE);
