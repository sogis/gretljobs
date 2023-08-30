INSERT INTO arp_mjpnl_v1.mjpnl_abrechnung_per_leistung (
    t_basket,
    vereinbarung,
    leistung_beschrieb,
    abgeltungsart,
    betrag_per_einheit,
    anzahl_einheiten,
    betrag_total,
    auszahlungsjahr,
    status_abrechnung,
    bemerkung,
    abrechnungpervereinbarung
)
WITH alle_beurteilungen AS (
  -- alle beurteilungen
  SELECT mit_bewirtschafter_besprochen, vereinbarung
  FROM arp_mjpnl_v1.mjpnl_beurteilung_alr_buntbrache
  UNION
  SELECT mit_bewirtschafter_besprochen, vereinbarung
  FROM arp_mjpnl_v1.mjpnl_beurteilung_alr_saum
  UNION
  SELECT mit_bewirtschafter_besprochen, vereinbarung
  FROM arp_mjpnl_v1.mjpnl_beurteilung_hecke
  UNION
  SELECT mit_bewirtschafter_besprochen, vereinbarung
  FROM arp_mjpnl_v1.mjpnl_beurteilung_hostet
  UNION
  SELECT mit_bewirtschafter_besprochen, vereinbarung
  FROM arp_mjpnl_v1.mjpnl_beurteilung_obl
  UNION
  SELECT mit_bewirtschafter_besprochen, vereinbarung
  FROM arp_mjpnl_v1.mjpnl_beurteilung_wbl_weide
  UNION
  SELECT mit_bewirtschafter_besprochen, vereinbarung
  FROM arp_mjpnl_v1.mjpnl_beurteilung_wbl_wiese
  UNION
  SELECT mit_bewirtschafter_besprochen, vereinbarung
  FROM arp_mjpnl_v1.mjpnl_beurteilung_weide_ln
  UNION
  SELECT mit_bewirtschafter_besprochen, vereinbarung
  FROM arp_mjpnl_v1.mjpnl_beurteilung_weide_soeg
  UNION
  SELECT mit_bewirtschafter_besprochen, vereinbarung
  FROM arp_mjpnl_v1.mjpnl_beurteilung_wiese
),
relevante_vereinbarungen AS (
  -- alle vereinbarungen mit unbesprochener oder keiner beurteilung
  SELECT * 
  FROM arp_mjpnl_v1.mjpnl_vereinbarung vbg
  LEFT JOIN alle_beurteilungen be
  ON be.vereinbarung = vbg.t_id
  WHERE vbg.status_vereinbarung = 'aktiv'
  AND be.mit_bewirtschafter_besprochen IS NOT TRUE
)
-- alle letztjährigen leistungen der  vereinbarungen mit unbesprochener oder keiner beurteilung
SELECT 
    l.t_basket, 
    l.vereinbarung, 
    l.leistung_beschrieb, 
    l.abgeltungsart,
    l.betrag_per_einheit,
    l.anzahl_einheiten,
    l.betrag_total,
    2024::integer AS auszahlungsjahr,
    'freigegeben' AS status_abrechnung,
    'Migriert aus '||2024::integer-1||' '||COALESCE(l.bemerkung,'') as bemerkung,
    l.abrechnungpervereinbarung
FROM arp_mjpnl_v1.mjpnl_abrechnung_per_leistung l
INNER JOIN relevante_vereinbarungen rel_vbg
ON l.vereinbarung = rel_vbg.t_id
WHERE l.auszahlungsjahr = 2024-1 AND einmalig IS NOT TRUE AND l.status_abrechnung = 'ausbezahlt'; 