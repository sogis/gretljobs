/* Zusammenzug Zahlungen per Bewirtschafter, Auszahlungsjahr und Status Zahlung */

INSERT INTO ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_bewirtschafter 
(t_basket, gelan_pid_gelan, gelan_person, gelan_ortschaft, gelan_iban, betrag_total, status_abrechnung,
 datum_abrechnung, auszahlungsjahr, dateipfad_oder_url, erstellungsdatum, operator_erstellung)

WITH gelan_persons AS (
/* zuerst alle GELAN Personen filtern die eine aktive Vereinbarung haben */
SELECT 
    DISTINCT
      pers.pid_gelan,
      pers.name_vorname,
      pers.ortschaft,
      pers.iban
FROM
    ${DB_Schema_MJPNL}.mjpnl_vereinbarung vbg
    LEFT JOIN ${DB_Schema_MJPNL}.betrbsdttrktrdten_gelan_person pers
      ON vbg.gelan_pid_gelan = pers.pid_gelan
   WHERE
     pers.pid_gelan IS NOT NULL AND pers.iban IS NOT NULL
     AND vbg.status_vereinbarung = 'aktiv'
   ORDER BY pers.pid_gelan ASC
)
/* Dann Abrechnungsdaten per Bewirtschafter und Auszahlungsjahr und Status aggregieren */
SELECT 
   (SELECT t_id FROM ${DB_Schema_MJPNL}.t_ili2db_basket WHERE topic = 'SO_ARP_MJPNL_20201026.MJPNL' LIMIT 1) AS t_basket,   
   pers.pid_gelan,
   pers.name_vorname AS gelan_person,
   pers.ortschaft AS gelan_ortschaft,
   pers.iban,
   SUM(abrg_vbg.gesamtbetrag) AS betrag_total,
   MIN(abrg_vbg.status_abrechnung) AS status_abrechnung,
   MAX(abrg_vbg.datum_abrechnung) AS datum_abrechnung,
   abrg_vbg.auszahlungsjahr,
   'Migration' AS dateipfad_oder_url,
   COALESCE ( MAX(abrg_vbg.datum_abrechnung), now()::date ) AS erstellungsdatum,
   'Migration' AS operator_erstellung
FROM
  gelan_persons pers
  LEFT JOIN ${DB_Schema_MJPNL}.mjpnl_vereinbarung vbg
     ON pers.pid_gelan = vbg.gelan_pid_gelan
  LEFT JOIN ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_vereinbarung abrg_vbg
     ON vbg.vereinbarungs_nr = abrg_vbg.vereinbarungs_nr
  WHERE abrg_vbg.gesamtbetrag IS NOT NULL AND abrg_vbg.auszahlungsjahr IS NOT NULL
  GROUP BY pers.pid_gelan, pers.iban, pers.name_vorname, pers.ortschaft, abrg_vbg.auszahlungsjahr, abrg_vbg.status_abrechnung
  ORDER BY pers.pid_gelan ASC, abrg_vbg.auszahlungsjahr ASC
;

/* Abrechnung per Vereinbarung aktualisieren mit Fremdschlüsseln zur Abrechnung per Bewirtschafter */
WITH abrg_per_bewirtschafter AS (
SELECT 
   abrg_bew.t_id,
   abrg_bew.auszahlungsjahr,
   abrg_bew.status_abrechnung,
   vbg.vereinbarungs_nr 
FROM
   ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_bewirtschafter abrg_bew
   LEFT JOIN ${DB_Schema_MJPNL}.mjpnl_vereinbarung vbg
      ON abrg_bew.gelan_pid_gelan = vbg.gelan_pid_gelan
   WHERE
      abrg_bew.t_id != 9999999
   ORDER BY vbg.vereinbarungs_nr ASC, abrg_bew.auszahlungsjahr ASC, abrg_bew.status_abrechnung ASC
)
/* Update der Abrechnung per Vereinbarung über gemeinsame Attribute */
UPDATE
  ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_vereinbarung abrg_vbg 
    SET abrechnungperbewirtschafter = abrg_bew.t_id
  FROM abrg_per_bewirtschafter abrg_bew
    WHERE
       abrg_vbg.vereinbarungs_nr = abrg_bew.vereinbarungs_nr
       AND abrg_vbg.auszahlungsjahr = abrg_bew.auszahlungsjahr 
       AND abrg_vbg.status_abrechnung = abrg_bew.status_abrechnung
;
