/* Dummy-Entry Vereinbarung */
INSERT INTO ${DB_Schema_MJPNL}.mjpnl_vereinbarung
(t_id, t_basket, t_ili_tid, vereinbarungs_nr, vereinbarungs_nr_alt, flaechen_id_alt,
geometrie, gelan_pid_gelan, gelan_bewe_id, uebersteuerung_bewirtschafter,
bfs_nr, gemeinde, gb_nr, flurname, vereinbarungsart, ist_nutzungsvereinbarung,
flaeche, rrb_nr, rrb_publiziert_ab, status_vereinbarung, soemmerungsgebiet, mjpnl_version,
kontrollintervall, bemerkung, uzl_subregion, dateipfad_oder_url, erstellungsdatum,
operator_erstellung, aenderungsdatum, operator_aenderung)
VALUES(
  9999999,
  5,
  uuid_generate_v4(),
  '01_DUMMY_00001',
  'Dummy',
  0,
  ST_GeomFromText('MultiPolygon(((2607251.77485882537439466 1228263.4145868313498795, 2607286.84019394358620048 1228231.1071994190569967, 2607340.42317794449627399 1228270.90044489037245512, 2607304.56985776731744409 1228305.17779494961723685, 2607251.77485882537439466 1228263.4145868313498795)))'),
  (SELECT pid_gelan FROM ${DB_Schema_MJPNL}.betrbsdttrktrdten_gelan_person LIMIT 1),
  'GELAN_BEWE_DUMMY',
  false,
  '{2601}',
  '{"Dummy-Gemeinde"}',
  '{"Dummy-GBNr"}',
  '{"Dummy-Flurname"}',
  'Wiese',
  false,
  1,
  NULL,
  NULL,
  'inaktiv',
  false,
  'MJPNL_2020',
  4,
  'Dummy-Entry',
  (SELECT t_id FROM ${DB_Schema_MJPNL}.umweltziele_uzl_subregion LIMIT 1),
  'Dummy-Pfad',
  now()::date,
  'bjsvwneu',
  NULL,
  NULL);

/* Dummy-Entry Abrechnung per Bewirtschafter */
INSERT INTO ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_bewirtschafter
(t_id, t_basket, t_ili_tid, gelan_pid_gelan, gelan_person, gelan_ortschaft, gelan_iban, betrag_total, status_abrechnung, datum_abrechnung, auszahlungsjahr, bemerkung, dateipfad_oder_url, erstellungsdatum, operator_erstellung, aenderungsdatum, operator_aenderung)
VALUES(9999999, 5, uuid_generate_v4(), (SELECT pid_gelan FROM ${DB_Schema_MJPNL}.betrbsdttrktrdten_gelan_person LIMIT 1), 'Dummy-Name','Dummy-Ortschaft', 'CH16090100565713403', 99, 'initialisiert', '1990-01-01', 1900, 'Dummy-Entry', 'Dummy-Pfad', now()::date, 'bjsvwneu', NULL, NULL);

/* Dummy-Entry Abrechnung per Vereinbarung */
INSERT INTO ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_vereinbarung
(t_id, t_basket, t_ili_tid, vereinbarungs_nr, flurnamen, gemeinde, flaeche, gesamtbetrag, auszahlungsjahr, status_abrechnung, datum_abrechnung, bemerkung, abrechnungperbewirtschafter, vereinbarung)
VALUES(9999999, 5, uuid_generate_v4(), '01_DUMMY_00001', 'Dummy-Flurnamen', 'Dummy-Gemeinde', 99, 99, 1900, 'initialisiert', '1990-01-01', 'Dummy Entry', 9999999, 9999999);
