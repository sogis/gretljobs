/* Zusammenzug Zahlungen per Bewirtschafter, Auszahlungsjahr und Status Zahlung nur für das Jahr 2023 (da wir die Historisierung der Bewirtschafter der Vorjahren nicht haben).*/

INSERT INTO ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_bewirtschafter 
(t_basket, gelan_pid_gelan, gelan_person, gelan_ortschaft, gelan_iban, betrag_total, status_abrechnung,
 datum_abrechnung, auszahlungsjahr, dateipfad_oder_url, erstellungsdatum, operator_erstellung, migriert)

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
     AND vbg.status_vereinbarung = 'aktiv' AND vbg.bewe_id_geprueft IS TRUE
   ORDER BY pers.pid_gelan ASC
)
/* Dann Abrechnungsdaten per Bewirtschafter und Auszahlungsjahr und Status aggregieren */
SELECT 
   MIN(vbg.t_basket) AS t_basket,   
   pers.pid_gelan,
   pers.name_vorname AS gelan_person,
   pers.ortschaft AS gelan_ortschaft,
   pers.iban,
   SUM(abrg_vbg.gesamtbetrag) AS betrag_total,
   -- wenn es ein status_abrechnung "in_bearbeitung" oder wenn nicht dann "freigegeben" gibt, dann soll der status demensprechend gleich sein
   CASE 
     WHEN (SELECT COUNT(*) FROM ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_vereinbarung v WHERE v.status_abrechnung = 'in_bearbeitung' AND v.gelan_pid_gelan = pers.pid_gelan AND v.auszahlungsjahr = abrg_vbg.auszahlungsjahr) > 0 
     THEN 'in_bearbeitung' 
     WHEN (SELECT COUNT(*) FROM ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_vereinbarung v WHERE v.status_abrechnung = 'freigegeben' AND v.gelan_pid_gelan = pers.pid_gelan AND v.auszahlungsjahr = abrg_vbg.auszahlungsjahr) > 0 
     THEN 'freigegeben' 
     -- ansonsten ist es für alle gleich ("ausbezahlt" oder "intern_verrechnet")
     ELSE MAX(abrg_vbg.status_abrechnung) 
   END AS status_abrechnung,
   -- wenn es eine status_abrechnung "freigegeben" oder "in_bearbeitung" gibt, dann soll es noch kein datum_abrechnung haben
   CASE 
     WHEN (SELECT COUNT(*) FROM ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_vereinbarung v WHERE v.status_abrechnung = 'in_bearbeitung' AND v.gelan_pid_gelan = pers.pid_gelan AND v.auszahlungsjahr = abrg_vbg.auszahlungsjahr) > 0 
     OR (SELECT COUNT(*) FROM ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_vereinbarung v WHERE v.status_abrechnung = 'freigegeben' AND v.gelan_pid_gelan = pers.pid_gelan AND v.auszahlungsjahr = abrg_vbg.auszahlungsjahr) > 0 
     THEN NULL
     -- ansonsten kann es das späteste datum nehmen
     ELSE MAX(abrg_vbg.datum_abrechnung) 
   END AS datum_abrechnung,
   abrg_vbg.auszahlungsjahr,
   'Migration' AS dateipfad_oder_url,
   COALESCE ( MAX(abrg_vbg.datum_abrechnung), now()::date ) AS erstellungsdatum,
   'Migration' AS operator_erstellung,
   TRUE AS migriert
FROM
  gelan_persons pers
  LEFT JOIN ${DB_Schema_MJPNL}.mjpnl_vereinbarung vbg
     ON pers.pid_gelan = vbg.gelan_pid_gelan
  LEFT JOIN ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_vereinbarung abrg_vbg
     ON vbg.vereinbarungs_nr = abrg_vbg.vereinbarungs_nr
  WHERE 
    abrg_vbg.gesamtbetrag IS NOT NULL 
    AND abrg_vbg.auszahlungsjahr = 2023
  GROUP BY pers.pid_gelan, pers.iban, pers.name_vorname, pers.ortschaft, abrg_vbg.auszahlungsjahr
  ORDER BY pers.pid_gelan ASC
;

/* Abrechnung per Vereinbarung aktualisieren mit Fremdschlüsseln zur Abrechnung per Bewirtschafter */
WITH abrg_per_bewirtschafter AS (
SELECT 
   abrg_bew.t_id,
   abrg_bew.auszahlungsjahr,
   vbg.vereinbarungs_nr 
FROM
   ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_bewirtschafter abrg_bew
   LEFT JOIN ${DB_Schema_MJPNL}.mjpnl_vereinbarung vbg
      ON abrg_bew.gelan_pid_gelan = vbg.gelan_pid_gelan
   ORDER BY vbg.vereinbarungs_nr ASC, abrg_bew.auszahlungsjahr ASC
)
UPDATE
  ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_vereinbarung abrg_vbg 
    SET abrechnungperbewirtschafter = abrg_bew.t_id
  FROM abrg_per_bewirtschafter abrg_bew
    WHERE
       abrg_vbg.vereinbarungs_nr = abrg_bew.vereinbarungs_nr
       AND abrg_vbg.auszahlungsjahr = abrg_bew.auszahlungsjahr 
;
