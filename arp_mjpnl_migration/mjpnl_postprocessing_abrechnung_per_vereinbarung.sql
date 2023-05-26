/* Zusammenzug Zahlungen per Vereinbarung und Datum der Auszahlung */

INSERT INTO ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_vereinbarung 
  (t_basket, vereinbarungs_nr, flurnamen, gemeinde, flaeche, gesamtbetrag,
   auszahlungsjahr, status_abrechnung, datum_abrechnung, abrechnungperbewirtschafter, vereinbarung)
SELECT
  5 AS t_basket,
  vbg.vereinbarungs_nr,
  array_to_string(vbg.flurname,', ') AS flurnamen,
  array_to_string(vbg.gemeinde,', ') AS gemeinde,
  vbg.flaeche,
  CASE WHEN SUM(lstg.betrag_total) THEN SUM(lstg.betrag_total)
  ELSE 0
  END AS gesamtbetrag,
  lstg.auszahlungsjahr,
  lstg.status_abrechnung,
  lstg.datum_abrechnung,
  9999999 AS abrechnungperbewirtschafter,
  vbg.t_id AS vereinbarung
FROM
  ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung lstg
  LEFT JOIN ${DB_Schema_MJPNL}.mjpnl_vereinbarung vbg
     ON lstg.vereinbarung = vbg.t_id
  WHERE
    lstg.vereinbarung != 9999999
    AND vbg.t_id IS NOT NULL
  GROUP BY vbg.t_id, vbg.vereinbarungs_nr, vbg.flurname, vbg.gemeinde, vbg.flaeche,
           lstg.auszahlungsjahr, lstg.status_abrechnung, lstg.datum_abrechnung
  ORDER BY  vbg.vereinbarungs_nr, lstg.datum_abrechnung ASC
  ;
  
/* fkey update abrechnung_per_leistung zu abrechung_per_vereinbarung */  
UPDATE arp_mjpnl_v1.mjpnl_abrechnung_per_leistung abr_lstg
SET abrechnungpervereinbarung=abr_vbg.t_id
FROM
   arp_mjpnl_v1.mjpnl_vereinbarung vbg,
   arp_mjpnl_v1.mjpnl_abrechnung_per_vereinbarung abr_vbg
WHERE 
   abr_lstg.vereinbarung != 9999999
   AND vbg.t_id = abr_lstg.vereinbarung 
   AND vbg.vereinbarungs_nr = abr_vbg.vereinbarungs_nr
   AND abr_vbg.status_abrechnung = abr_lstg.status_abrechnung
   AND abr_vbg.datum_abrechnung = abr_lstg.datum_abrechnung
;
