/* Zusammenzug Zahlungen per Bewirtschafter, Auszahlungsjahr und Status Zahlung */
/* Entspricht arp_mjpnl_migration/mjpnl_postprocessing_abrechnung_per_bewirtschafter.sql muss allerdings nur die diesjährigen Leistungen berücksichtigen - somit stimmt auch die Historisierung, weil es den aktuellen Bewirtschafter nimmt. */

INSERT INTO ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_bewirtschafter 
(t_basket, gelan_pid_gelan, gelan_person, gelan_ortschaft, gelan_iban, gelan_kreditor, betrag_total, betrag_ausbezahlt_total, betrag_ausbezahlt_an_dritte_total, betrag_abgeltungslos_total, status_abrechnung,
 datum_abrechnung, auszahlungsjahr, dateipfad_oder_url, erstellungsdatum, operator_erstellung, migriert)

WITH gelan_persons AS (
/* zuerst alle GELAN Personen filtern die eine aktive Vereinbarung haben oder eine mit bereits ausbezahlten Leistungen */
SELECT 
    DISTINCT
      pers.pid_gelan,
      pers.name_vorname,
      pers.ortschaft,
      pers.iban,
      pers.kreditor_afin_solothurn
FROM
    ${DB_Schema_MJPNL}.mjpnl_vereinbarung vbg
    LEFT JOIN ${DB_Schema_MJPNL}.betrbsdttrktrdten_gelan_person pers
      ON vbg.gelan_pid_gelan = pers.pid_gelan
   WHERE
     pers.pid_gelan IS NOT NULL AND pers.iban IS NOT NULL
     AND (
        -- aktive und geprüfte Vereinbarungen
        (vbg.status_vereinbarung = 'aktiv' AND vbg.bewe_id_geprueft IS TRUE AND vbg.ist_nutzungsvereinbarung IS NOT TRUE)
        OR
        -- mind. eine diesjährige Leistung, die bereits ausbezahlt ist
        (SELECT COUNT(*) FROM ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung l WHERE l.status_abrechnung IN ('ausbezahlt','intern_verrechnet','ausbezahlt_an_dritte') AND l.vereinbarung = vbg.t_id AND l.auszahlungsjahr = ${AUSZAHLUNGSJAHR}::integer) > 0 
     )
   ORDER BY pers.pid_gelan ASC
)
/* Dann Abrechnungsdaten per Bewirtschafter und Auszahlungsjahr und Status aggregieren */
SELECT 
   MIN(vbg.t_basket) AS t_basket,   
   pers.pid_gelan,
   pers.name_vorname AS gelan_person,
   pers.ortschaft AS gelan_ortschaft,
   pers.iban,
   pers.kreditor_afin_solothurn,
   SUM(abrg_vbg.gesamtbetrag) AS betrag_total, 
   SUM(abrg_vbg.betrag_pauschal_einmalig_ausbezahlt) as betrag_ausbezahlt_total,
   SUM(abrg_vbg.betrag_pauschal_einmalig_ausbezahlt_an_dritte) as betrag_ausbezahlt_an_dritte_total,
   SUM(abrg_vbg.betrag_abgeltungslos) as betrag_abgeltungslos_total,
   CASE 
      -- wenn es ein status_abrechnung "freigegeben" gibt, dann soll der status demensprechend gleich sein
      WHEN (SELECT COUNT(*) FROM ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_vereinbarung v WHERE v.status_abrechnung = 'freigegeben' AND v.gelan_pid_gelan = pers.pid_gelan AND v.auszahlungsjahr = abrg_vbg.auszahlungsjahr) > 0
      THEN 'freigegeben' 
      -- wenn es ein status_abrechnung "intern_verrechnet" gibt, dann soll der status demensprechend gleich sein
      WHEN (SELECT COUNT(*) FROM ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_vereinbarung v WHERE v.status_abrechnung = 'intern_verrechnet' AND v.gelan_pid_gelan = pers.pid_gelan AND v.auszahlungsjahr = abrg_vbg.auszahlungsjahr) > 0
      THEN 'intern_verrechnet' 
      -- wenn es ein status_abrechnung "ausbezahlt" gibt, dann soll der status demensprechend gleich sein
      WHEN (SELECT COUNT(*) FROM ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_vereinbarung v WHERE v.status_abrechnung = 'ausbezahlt' AND v.gelan_pid_gelan = pers.pid_gelan AND v.auszahlungsjahr = abrg_vbg.auszahlungsjahr) > 0
      THEN 'ausbezahlt' 
      -- ansonsten ist es nur noch 'ausbezahlt_an_dritte', dies wird mit Fallback abgefangen:
      ELSE MAX(abrg_vbg.status_abrechnung) 
   END AS status_abrechnung,
   -- wenn es eine status_abrechnung "freigegeben" gibt, dann soll es noch kein datum_abrechnung haben
   CASE 
     WHEN (SELECT COUNT(*) FROM ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_vereinbarung v WHERE v.status_abrechnung = 'freigegeben' AND v.gelan_pid_gelan = pers.pid_gelan AND v.auszahlungsjahr = abrg_vbg.auszahlungsjahr) > 0 
     THEN NULL
     -- ansonsten kann es das späteste datum nehmen
     ELSE MAX(abrg_vbg.datum_abrechnung) 
   END AS datum_abrechnung,
   abrg_vbg.auszahlungsjahr,
   'Migration' AS dateipfad_oder_url,
   COALESCE ( MAX(abrg_vbg.datum_abrechnung), now()::date ) AS erstellungsdatum,
   'Migration' AS operator_erstellung,
   FALSE AS migriert
FROM
  gelan_persons pers
  LEFT JOIN ${DB_Schema_MJPNL}.mjpnl_vereinbarung vbg
     ON pers.pid_gelan = vbg.gelan_pid_gelan
  LEFT JOIN ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_vereinbarung abrg_vbg
     ON vbg.vereinbarungs_nr = abrg_vbg.vereinbarungs_nr
  WHERE 
    abrg_vbg.gesamtbetrag IS NOT NULL
    -- berücksichtige nur diesjährige Leistungen
    AND abrg_vbg.auszahlungsjahr = ${AUSZAHLUNGSJAHR}::integer
  GROUP BY pers.pid_gelan, pers.iban, pers.kreditor_afin_solothurn, pers.name_vorname, pers.ortschaft, abrg_vbg.auszahlungsjahr
  ORDER BY pers.pid_gelan ASC;

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
   WHERE
   abrg_bew.auszahlungsjahr = ${AUSZAHLUNGSJAHR}::integer
   ORDER BY vbg.vereinbarungs_nr ASC, abrg_bew.auszahlungsjahr ASC
)
/* Update der Abrechnung per Vereinbarung über gemeinsame Attribute */
UPDATE
  ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_vereinbarung abrg_vbg 
    SET abrechnungperbewirtschafter = abrg_bew.t_id
  FROM abrg_per_bewirtschafter abrg_bew
    WHERE
       abrg_vbg.vereinbarungs_nr = abrg_bew.vereinbarungs_nr
       AND abrg_vbg.auszahlungsjahr = ${AUSZAHLUNGSJAHR}::integer
;
