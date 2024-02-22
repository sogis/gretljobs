INSERT INTO ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung (
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
    migriert,
    abrechnungpervereinbarung
)
WITH alle_beurteilungen AS (
  -- alle beurteilungen
  SELECT mit_bewirtschafter_besprochen, vereinbarung
  FROM ${DB_Schema_MJPNL}.mjpnl_beurteilung_alr_buntbrache
  UNION
  SELECT mit_bewirtschafter_besprochen, vereinbarung
  FROM ${DB_Schema_MJPNL}.mjpnl_beurteilung_alr_saum
  UNION
  SELECT mit_bewirtschafter_besprochen, vereinbarung
  FROM ${DB_Schema_MJPNL}.mjpnl_beurteilung_hecke
  UNION
  SELECT mit_bewirtschafter_besprochen, vereinbarung
  FROM ${DB_Schema_MJPNL}.mjpnl_beurteilung_hostet
  UNION
  SELECT mit_bewirtschafter_besprochen, vereinbarung
  FROM ${DB_Schema_MJPNL}.mjpnl_beurteilung_obl
  UNION
  SELECT mit_bewirtschafter_besprochen, vereinbarung
  FROM ${DB_Schema_MJPNL}.mjpnl_beurteilung_wbl_weide
  UNION
  SELECT mit_bewirtschafter_besprochen, vereinbarung
  FROM ${DB_Schema_MJPNL}.mjpnl_beurteilung_wbl_wiese
  UNION
  SELECT mit_bewirtschafter_besprochen, vereinbarung
  FROM ${DB_Schema_MJPNL}.mjpnl_beurteilung_weide_ln
  UNION
  SELECT mit_bewirtschafter_besprochen, vereinbarung
  FROM ${DB_Schema_MJPNL}.mjpnl_beurteilung_weide_soeg
  UNION
  SELECT mit_bewirtschafter_besprochen, vereinbarung
  FROM ${DB_Schema_MJPNL}.mjpnl_beurteilung_wiese
),
relevante_vereinbarungen AS (
  -- alle aktiven vereinbarungen mit nur unbesprochener oder gar keiner beurteilung
  SELECT * 
  FROM ${DB_Schema_MJPNL}.mjpnl_vereinbarung vbg
  WHERE vbg.status_vereinbarung = 'aktiv' AND vbg.bewe_id_geprueft IS TRUE
  AND vbg.t_id NOT IN (SELECT vereinbarung FROM alle_beurteilungen WHERE mit_bewirtschafter_besprochen IS TRUE)
)
-- alle letztjährigen leistungen der vereinbarungen mit nur unbesprochener oder gar keiner beurteilung
SELECT 
    l.t_basket, 
    l.vereinbarung, 
    l.leistung_beschrieb, 
    l.abgeltungsart,
    l.betrag_per_einheit,
    l.anzahl_einheiten,
    l.betrag_total,
    ${AUSZAHLUNGSJAHR}::integer AS auszahlungsjahr,
    CASE
        WHEN rel_vbg.kantonsintern THEN 'intern_verrechnet'
        ELSE 'freigegeben'
    END AS status_abrechnung,
    'Übernommen aus '||${AUSZAHLUNGSJAHR}::integer-1||' '||COALESCE(l.bemerkung,'') as bemerkung,
    FALSE AS migriert,
    l.abrechnungpervereinbarung
FROM ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung l
INNER JOIN relevante_vereinbarungen rel_vbg
ON l.vereinbarung = rel_vbg.t_id
WHERE l.auszahlungsjahr = ${AUSZAHLUNGSJAHR}-1 AND einmalig IS NOT TRUE AND l.status_abrechnung = 'ausbezahlt'
-- falls wir im Migrationsjahr sind, dann sollen keine Leistungen vom Vorjahr kopiert werden
AND ${AUSZAHLUNGSJAHR} != 2023;