/* Zusammenzug Zahlungen per Vereinbarung und Datum der Auszahlung */

INSERT INTO ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_vereinbarung 
  (t_basket, vereinbarungs_nr, gelan_pid_gelan, gelan_bewe_id, gb_nr, flurnamen, gemeinde, flaeche, anzahl_baeume, betrag_flaeche, betrag_baeume, betrag_pauschal, gesamtbetrag,
   auszahlungsjahr, status_abrechnung, datum_abrechnung, bewirtschaftabmachung_schnittzeitpunkt_1, bewirtschaftabmachung_messerbalkenmaehgeraet, bewirtschaftabmachung_herbstweide,abrechnungperbewirtschafter, vereinbarung, migriert)
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
  lstg.status_abrechnung,
  lstg.datum_abrechnung,
  bw.bewirtschaftabmachung_schnittzeitpunkt_1,
  COALESCE(bw.bewirtschaftabmachung_messerbalkenmaehgeraet, FALSE) as bewirtschaftabmachung_messerbalkenmaehgeraet,
  COALESCE(bw.bewirtschaftabmachung_herbstweide, FALSE) as bewirtschaftabmachung_herbstweide,
  9999999 AS abrechnungperbewirtschafter,
  vbg.t_id AS vereinbarung,
  TRUE AS migriert
FROM
  ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung lstg
  LEFT JOIN ${DB_Schema_MJPNL}.mjpnl_vereinbarung vbg
     ON lstg.vereinbarung = vbg.t_id
  -- technically there could be multiple beurteilungen, but in this migration case it's only one. And only for wiese (no entries in wbl_wiese).
  LEFT JOIN ${DB_Schema_MJPNL}.mjpnl_beurteilung_wiese bw
     ON lstg.vereinbarung = bw.vereinbarung
  LEFT JOIN ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung lstg_stueck
     ON lstg_stueck.t_id = lstg.t_id AND lstg_stueck.abgeltungsart = 'per_stueck'
  LEFT JOIN ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung lstg_ha
     ON lstg_ha.t_id = lstg.t_id AND lstg_ha.abgeltungsart = 'per_ha'
  LEFT JOIN ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung lstg_pauschal
     ON lstg_pauschal.t_id = lstg.t_id AND lstg_pauschal.abgeltungsart = 'pauschal'
  WHERE
    lstg.vereinbarung != 9999999
    AND vbg.t_id IS NOT NULL
  GROUP BY vbg.t_id, vbg.vereinbarungs_nr, vbg.gelan_bewe_id, vbg.gb_nr, vbg.flurname, vbg.gemeinde, vbg.flaeche,
           lstg.auszahlungsjahr, lstg.status_abrechnung, lstg.datum_abrechnung, 
           bw.bewirtschaftabmachung_schnittzeitpunkt_1, bw.bewirtschaftabmachung_messerbalkenmaehgeraet, bw.bewirtschaftabmachung_herbstweide
  ORDER BY  vbg.vereinbarungs_nr, lstg.datum_abrechnung ASC
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
   AND abr_vbg.status_abrechnung = abr_lstg.status_abrechnung
   AND ( abr_vbg.datum_abrechnung = abr_lstg.datum_abrechnung OR (abr_lstg.datum_abrechnung IS NULL AND abr_vbg.datum_abrechnung IS NULL ) )
;
