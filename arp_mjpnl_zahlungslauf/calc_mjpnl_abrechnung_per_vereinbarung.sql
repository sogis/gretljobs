/* Zusammenzug Zahlungen per Vereinbarung und Datum der Auszahlung */
/* Entspricht arp_mjpnl_migration/mjpnl_postprocessing_abrechnung_per_vereinbarung.sql muss allerdings nur die diesjährigen Leistungen berücksichtigen */

INSERT INTO ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_vereinbarung 
  (t_basket, vereinbarungs_nr, gelan_pid_gelan, gelan_bewe_id, gb_nr, flurnamen, gemeinde, flaeche, anzahl_baeume, betrag_flaeche, betrag_baeume, betrag_pauschal, gesamtbetrag,
   auszahlungsjahr, status_abrechnung, datum_abrechnung, bewirtschaftabmachung_schnittzeitpunkt_1, bewirtschaftabmachung_messerbalkenmaehgeraet, bewirtschaftabmachung_herbstweide,abrechnungperbewirtschafter, vereinbarung, migriert)
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
  array_to_string(vbg.gemeinde,',') AS gemeinde,
  vbg.flaeche,
  COALESCE(SUM(lstg_stueck.anzahl_einheiten),0) AS anzahl_baeume,
  COALESCE(SUM(lstg_ha.betrag_total),0) AS betrag_flaeche,
  COALESCE(SUM(lstg_stueck.betrag_total),0) AS betrag_baeume,
  COALESCE(SUM(lstg_pauschal.betrag_total),0) AS betrag_pauschal,
  COALESCE(SUM(lstg.betrag_total),0) AS gesamtbetrag,
  lstg.auszahlungsjahr,
  -- wenn es ein status_abrechnung "freigegeben" gibt, dann soll der status "freigegeben" sein
  CASE WHEN (SELECT COUNT(*) FROM ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung l WHERE l.status_abrechnung = 'freigegeben' AND l.vereinbarung = vbg.t_id) > 0 
   THEN 'freigegeben' 
   -- ansonsten ist es für alle gleich ("ausbezahlt" oder "intern_verrechnet")
   ELSE MAX(lstg.status_abrechnung) 
  END AS status_abrechnung,
  -- wenn es ein status_abrechnung "freigegeben" gibt, dann soll es noch kein datum_abrechnung haben
  CASE WHEN (SELECT COUNT(*) FROM ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung l WHERE l.status_abrechnung = 'freigegeben' AND l.vereinbarung = vbg.t_id) > 0 
   THEN NULL
   -- ansonsten kann es das späteste datum nehmen
   ELSE MAX(lstg.datum_abrechnung) 
  END AS datum_abrechnung,
  bw.bewirtschaftabmachung_schnittzeitpunkt_1,
  COALESCE(bw.bewirtschaftabmachung_messerbalkenmaehgeraet, FALSE) as bewirtschaftabmachung_messerbalkenmaehgeraet,
  COALESCE(bw.bewirtschaftabmachung_herbstweide, FALSE) as bewirtschaftabmachung_herbstweide,
  9999999 AS abrechnungperbewirtschafter,
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
  LEFT JOIN ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung lstg_pauschal
     ON lstg_pauschal.t_id = lstg.t_id AND lstg_pauschal.abgeltungsart = 'pauschal'
  WHERE
    vbg.t_id IS NOT NULL
    -- berücksichtige nur relevante status
    AND lstg.status_abrechnung NOT IN ('in_bearbeitung', 'abgeltungslos')
    -- berücksichtige nur diesjährige Leistungen
    AND lstg.auszahlungsjahr = date_part('year', now())::integer;
  GROUP BY vbg.t_id, vbg.vereinbarungs_nr, vbg.gelan_bewe_id, vbg.gb_nr, vbg.flurname, vbg.gemeinde, vbg.flaeche,
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
   abr_lstg.vereinbarung != 9999999
   AND vbg.t_id = abr_lstg.vereinbarung 
   AND vbg.vereinbarungs_nr = abr_vbg.vereinbarungs_nr
   AND abr_lstg.auszahlungsjahr = date_part('year', now())::integer
   AND abr_vbg.auszahlungsjahr = date_part('year', now())::integer
;

