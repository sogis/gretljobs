/* Dummy-Entry Vereinbarung */
INSERT INTO ${DB_Schema_MJPNL}.mjpnl_vereinbarung
(t_id, t_basket, t_ili_tid, vereinbarungs_nr, vereinbarungs_nr_alt, flaechen_id_alt,
geometrie, gelan_pid_gelan, gelan_bewe_id, uebersteuerung_bewirtschafter, bewe_id_geprueft,
bfs_nr, gemeinde, gb_nr, flurname, vereinbarungsart, ist_nutzungsvereinbarung,
flaeche, rrb_nr, rrb_publiziert_ab, status_vereinbarung, soemmerungsgebiet, mjpnl_version,
kontrollintervall, startdatum, enddatum, bemerkung, uzl_subregion, dateipfad_oder_url, erstellungsdatum,
operator_erstellung, aenderungsdatum, operator_aenderung)
VALUES(
  9999999,
  (SELECT t_id FROM ${DB_Schema_MJPNL}.t_ili2db_basket WHERE t_ili_tid = 'SO_ARP_MJPNL_20201026.MJPNL' LIMIT 1),
  uuid_generate_v4(),
  '01_DUMMY_00001',
  'Dummy',
  0,
  ST_GeomFromText('MultiPolygon(((2607251.77485882537439466 1228263.4145868313498795, 2607286.84019394358620048 1228231.1071994190569967, 2607340.42317794449627399 1228270.90044489037245512, 2607304.56985776731744409 1228305.17779494961723685, 2607251.77485882537439466 1228263.4145868313498795)))'),
  (SELECT pid_gelan FROM ${DB_Schema_MJPNL}.betrbsdttrktrdten_gelan_person LIMIT 1),
  'GELAN_BEWE_DUMMY',
  false,
  true,
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
  now()::DATE,
  (now()::DATE + INTERVAL '12 years')::DATE,
  'Dummy-Entry',
  (SELECT t_id FROM ${DB_Schema_MJPNL}.umweltziele_uzl_subregion LIMIT 1),
  'Dummy-Pfad',
  now()::DATE,
  'bjsvwneu',
  NULL,
  NULL);

/* Dummy-Entry in t_ili2db_basket um statische Baskets den Einträgen von mjpnl_leistung und mjpnl_vereinbarung zuzuweisen */
INSERT
  INTO ${DB_Schema_MJPNL}.t_ili2db_basket
    (t_id, dataset, topic, t_ili_tid, attachmentkey)
 SELECT
    9999999 AS t_id,
    t_id AS dataset,
    'Dummy-Topic' AS topic,
    uuid_generate_v4() AS t_ili_tid,
    'Dummy' AS attachmentkey
 FROM
 ${DB_Schema_MJPNL}.t_ili2db_dataset
 WHERE datasetname = 'MJPNL'
;

/* Dummy-Entry in umweltziele_uzl_subregion um statischer entry den Einträgen von mjpnl_leistung und mjpnl_vereinbarung zuzuweisen */
INSERT
  INTO ${DB_Schema_MJPNL}.umweltziele_uzl_subregion
    (t_id, t_basket, srcode, srname,geometrie )
 SELECT
    9999999, u.t_basket, u.srcode, u.srname, u.geometrie
 FROM ${DB_Schema_MJPNL}.umweltziele_uzl_subregion as u LIMIT 1
;