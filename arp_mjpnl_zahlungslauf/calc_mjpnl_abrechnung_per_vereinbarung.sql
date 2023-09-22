/* Zusammenzug Zahlungen per Vereinbarung und Datum der Auszahlung */
/* Entspricht arp_mjpnl_migration/mjpnl_postprocessing_abrechnung_per_vereinbarung.sql muss allerdings nur die diesjährigen Leistungen berücksichtigen */

INSERT INTO ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_vereinbarung 
  (t_basket, vereinbarungs_nr, gelan_pid_gelan, gelan_bewe_id, gb_nr, flurnamen, kultur_ids, gemeinde, flaeche, anzahl_baeume, betrag_flaeche, betrag_baeume, betrag_pauschal_regulaer, betrag_pauschal_einmalig_ausbezahlt, betrag_pauschal_einmalig_freigegeben, gesamtbetrag,
   auszahlungsjahr, status_abrechnung, datum_abrechnung, bewirtschaftabmachung_schnittzeitpunkt_1, bewirtschaftabmachung_messerbalkenmaehgeraet, bewirtschaftabmachung_herbstweide, vereinbarung, migriert)
WITH beurteilungs_metainfo_wiesen AS (
	SELECT vereinbarung, beurteilungsdatum, bewirtschaftabmachung_schnittzeitpunkt_1, bewirtschaftabmachung_messerbalkenmaehgeraet, bewirtschaftabmachung_herbstweide FROM ${DB_Schema_MJPNL}.mjpnl_beurteilung_wiese WHERE mit_bewirtschafter_besprochen
	UNION 
	SELECT vereinbarung, beurteilungsdatum, bewirtschaftabmachung_schnittzeitpunkt_1, bewirtschaftabmachung_messerbalkenmaehgeraet, bewirtschaftabmachung_herbstweide FROM ${DB_Schema_MJPNL}.mjpnl_beurteilung_wbl_wiese WHERE mit_bewirtschafter_besprochen
)
SELECT
  vbg.t_basket,
  vbg.vereinbarungs_nr,
  vbg.gelan_pid_gelan,
  vbg.gelan_bewe_id,
  array_to_string(vbg.gb_nr,',') AS gb_nr,
  array_to_string(vbg.flurname,',') AS flurnamen,
  array_to_string(vbg.kultur_id,',') AS kultur_ids,
  array_to_string(vbg.gemeinde,',') AS gemeinde,
  vbg.flaeche,
  COALESCE(SUM(lstg_stueck.anzahl_einheiten),0) AS anzahl_baeume,
  COALESCE(SUM(lstg_ha.betrag_total),0) AS betrag_flaeche,
  COALESCE(SUM(lstg_stueck.betrag_total),0) AS betrag_baeume,
  COALESCE(SUM(lstg_pauschal_reg.betrag_total),0) AS betrag_pauschal_regulaer,
  COALESCE(SUM(lstg_pauschal_einmalig_ausbez.betrag_total),0) AS betrag_pauschal_einmalig_ausbezahlt,
  COALESCE(SUM(lstg_pauschal_einmalig_freigeg.betrag_total),0) AS betrag_pauschal_einmalig_freigegeben,
  COALESCE(SUM(lstg.betrag_total),0) AS gesamtbetrag,
  lstg.auszahlungsjahr,
  -- wenn es ein status_abrechnung "in_bearbeitung" oder wenn nicht dann "freigegeben" gibt, dann soll der status demensprechend gleich sein
  CASE 
   WHEN (SELECT COUNT(*) FROM ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung l WHERE l.status_abrechnung = 'in_bearbeitung' AND l.vereinbarung = vbg.t_id AND l.auszahlungsjahr = lstg.auszahlungsjahr) > 0 
   THEN 'in_bearbeitung' 
   WHEN (SELECT COUNT(*) FROM ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung l WHERE l.status_abrechnung = 'freigegeben' AND l.vereinbarung = vbg.t_id AND l.auszahlungsjahr = lstg.auszahlungsjahr) > 0 
   THEN 'freigegeben' 
   -- ansonsten ist es für alle gleich ("ausbezahlt" oder "intern_verrechnet")
   ELSE MAX(lstg.status_abrechnung) 
  END AS status_abrechnung,
  -- wenn es ein status_abrechnung "in_bearbeitung" oder "freigegeben" gibt, dann soll es noch kein datum_abrechnung haben
  CASE 
   WHEN (SELECT COUNT(*) FROM ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung l WHERE l.status_abrechnung = 'freigegeben' AND l.vereinbarung = vbg.t_id AND l.auszahlungsjahr = lstg.auszahlungsjahr) > 0 
   OR (SELECT COUNT(*) FROM ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung l WHERE l.status_abrechnung = 'freigegeben' AND l.vereinbarung = vbg.t_id AND l.auszahlungsjahr = lstg.auszahlungsjahr) > 0 
   THEN NULL
   -- ansonsten kann es das späteste datum nehmen
   ELSE MAX(lstg.datum_abrechnung) 
  END AS datum_abrechnung,
  bw.bewirtschaftabmachung_schnittzeitpunkt_1,
  COALESCE(bw.bewirtschaftabmachung_messerbalkenmaehgeraet, FALSE) as bewirtschaftabmachung_messerbalkenmaehgeraet,
  COALESCE(bw.bewirtschaftabmachung_herbstweide, FALSE) as bewirtschaftabmachung_herbstweide,
  vbg.t_id AS vereinbarung,
  FALSE AS migriert
FROM
  -- Werte der einzelnen Leistungen
  ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung lstg
  -- Werte der Vereinbarung
  LEFT JOIN ${DB_Schema_MJPNL}.mjpnl_vereinbarung vbg
     ON lstg.vereinbarung = vbg.t_id
  -- Werte der Beurteilung Wiese
  LEFT JOIN beurteilungs_metainfo_wiesen bw
     ON lstg.vereinbarung = bw.vereinbarung
     -- berücksichtige nur die neusten (sofern mehrere existieren)
     AND bw.beurteilungsdatum = (SELECT MAX(beurteilungsdatum) FROM beurteilungs_metainfo_wiesen b WHERE b.vereinbarung = lstg.vereinbarung)
  LEFT JOIN ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung lstg_stueck
     ON lstg_stueck.t_id = lstg.t_id AND lstg_stueck.abgeltungsart = 'per_stueck'
  LEFT JOIN ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung lstg_ha
     ON lstg_ha.t_id = lstg.t_id AND lstg_ha.abgeltungsart = 'per_ha'
  LEFT JOIN ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung lstg_pauschal_reg
     ON lstg_pauschal_reg.t_id = lstg.t_id AND lstg_pauschal_reg.abgeltungsart = 'pauschal' AND lstg_pauschal_reg.einmalig IS NOT TRUE
  LEFT JOIN ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung lstg_pauschal_einmalig_ausbez
     ON lstg_pauschal_einmalig_ausbez.t_id = lstg.t_id AND lstg_pauschal_einmalig_ausbez.abgeltungsart = 'pauschal' AND lstg_pauschal_einmalig_ausbez.einmalig IS TRUE AND lstg_pauschal_einmalig_ausbez.status_abrechnung = 'ausbezahlt'
  LEFT JOIN ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung lstg_pauschal_einmalig_freigeg
     ON lstg_pauschal_einmalig_freigeg.t_id = lstg.t_id AND lstg_pauschal_einmalig_freigeg.abgeltungsart = 'pauschal' AND lstg_pauschal_einmalig_freigeg.einmalig IS TRUE AND lstg_pauschal_einmalig_freigeg.status_abrechnung = 'freigegeben'
  WHERE
    vbg.t_id IS NOT NULL AND vbg.status_vereinbarung = 'aktiv' AND vbg.bewe_id_geprueft IS TRUE
    -- berücksichtige nur relevante status (in_bearbeitung wird berücksichtigt, aber der Status wird übernommen)
    AND lstg.status_abrechnung != 'abgeltungslos'
    -- berücksichtige nur diesjährige Leistungen
    AND lstg.auszahlungsjahr = ${AUSZAHLUNGSJAHR}::integer
  GROUP BY vbg.t_id, vbg.vereinbarungs_nr, vbg.gelan_bewe_id, vbg.gb_nr, vbg.flurname, vbg.kultur_id, vbg.gemeinde, vbg.flaeche,
           lstg.auszahlungsjahr, bw.bewirtschaftabmachung_schnittzeitpunkt_1, bw.bewirtschaftabmachung_messerbalkenmaehgeraet, bw.bewirtschaftabmachung_herbstweide
  ORDER BY  vbg.vereinbarungs_nr ASC
  ;
  
/* fkey update abrechnung_per_leistung zu abrechung_per_vereinbarung */  
UPDATE ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung abr_lstg
SET abrechnungpervereinbarung=abr_vbg.t_id
FROM
   ${DB_Schema_MJPNL}.mjpnl_vereinbarung vbg,
   ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_vereinbarung abr_vbg
WHERE 
    vbg.t_id = abr_lstg.vereinbarung 
   AND vbg.vereinbarungs_nr = abr_vbg.vereinbarungs_nr
   AND abr_lstg.auszahlungsjahr = ${AUSZAHLUNGSJAHR}::integer
   AND abr_vbg.auszahlungsjahr = ${AUSZAHLUNGSJAHR}::integer
;

