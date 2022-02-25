-- Komplettes Leeren der Tabelle
DELETE
  FROM ${DB_Schema_AuswNPL}.bauzonenstatistik_bebauungsstand_pro_gemeinde;

-- Aggregation der Kombination Gemeinde und Zonentyp, ohne Berechnung der Prozentwerte (wird in separatem Schritt berechnet)
INSERT INTO
  ${DB_Schema_AuswNPL}.bauzonenstatistik_bebauungsstand_pro_gemeinde
  (bfs_nr, gemeindename, grundnutzung_typ_kt, bebaut_mit_zonen_ohne_lsgrenzen, unbebaut_mit_zonen_ohne_lsgrenzen, bebaut_mit_zonen_und_lsgrenzen,
   unbebaut_mit_zonen_und_lsgrenzen, bebaut_aus_liegenschaftszuteilung, unbebaut_aus_liegenschaftszuteilung, bebaut_mit_zonen_ohne_lsgrenzen_proz,
   unbebaut_mit_zonen_ohne_lsgrenzen_proz, bebaut_mit_zonen_und_lsgrenzen_proz, unbebaut_mit_zonen_und_lsgrenzen_proz, bebaut_aus_liegenschaftszuteilung_proz,
   unbebaut_aus_liegenschaftszuteilung_proz)

SELECT
  ol.bfs_nr,
  ol.gemeindename,
  ol.grundnutzung_typ_kt,
  COALESCE((SELECT SUM(flaeche) FROM ${DB_Schema_AuswNPL}.bauzonenstatistik_bebauungsstand_mit_zonen_ohne_lsgrenzen WHERE bfs_nr = ol.bfs_nr AND bebauungsstand = 'bebaut' AND grundnutzung_typ_kt = ol.grundnutzung_typ_kt),0) AS bebaut_mit_zonen_ohne_lsgrenzen,
  COALESCE((SELECT SUM(flaeche) FROM ${DB_Schema_AuswNPL}.bauzonenstatistik_bebauungsstand_mit_zonen_ohne_lsgrenzen WHERE bfs_nr = ol.bfs_nr AND bebauungsstand = 'unbebaut' AND grundnutzung_typ_kt = ol.grundnutzung_typ_kt),0) AS unbebaut_mit_zonen_ohne_lsgrenzen,
  COALESCE((SELECT SUM(flaeche) FROM ${DB_Schema_AuswNPL}.bauzonenstatistik_bebauungsstand_mit_zonen_und_lsgrenzen WHERE bfs_nr = ol.bfs_nr AND bebauungsstand = 'bebaut' AND grundnutzung_typ_kt = ol.grundnutzung_typ_kt),0) AS bebaut_mit_zonen_und_lsgrenzen,
  COALESCE((SELECT SUM(flaeche) FROM ${DB_Schema_AuswNPL}.bauzonenstatistik_bebauungsstand_mit_zonen_und_lsgrenzen WHERE bfs_nr = ol.bfs_nr AND bebauungsstand = 'unbebaut' AND grundnutzung_typ_kt = ol.grundnutzung_typ_kt),0) AS unbebaut_mit_zonen_und_lsgrenzen,
  COALESCE((SELECT SUM(flaeche_beschnitten) FROM ${DB_Schema_AuswNPL}.bauzonenstatistik_liegenschaft_nach_bebauungsstand WHERE bfs_nr = ol.bfs_nr AND bebauungsstand IN ('bebaut','teilweise_bebaut') AND grundnutzung_typ_kt = ol.grundnutzung_typ_kt),0) AS bebaut_aus_liegenschaftszuteilung,
  COALESCE((SELECT SUM(flaeche_beschnitten) FROM ${DB_Schema_AuswNPL}.bauzonenstatistik_liegenschaft_nach_bebauungsstand WHERE bfs_nr = ol.bfs_nr AND bebauungsstand = 'unbebaut' AND grundnutzung_typ_kt = ol.grundnutzung_typ_kt),0) AS unbebaut_aus_liegenschaftszuteilung,
  0 AS bebaut_mit_zonen_ohne_lsgrenzen_proz,
  0 AS unbebaut_mit_zonen_ohne_lsgrenzen_proz,
  0 AS bebaut_mit_zonen_und_lsgrenzen_proz,
  0 AS unbebaut_mit_zonen_und_lsgrenzen_proz,
  0 AS bebaut_aus_liegenschaftszuteilung_proz,
  0 AS unbebaut_aus_liegenschaftszuteilung_proz
FROM ${DB_Schema_AuswNPL}.bauzonenstatistik_bebauungsstand_mit_zonen_ohne_lsgrenzen ol
GROUP BY ol.bfs_nr, ol.gemeindename, ol.grundnutzung_typ_kt
ORDER BY ol.bfs_nr, ol.grundnutzung_typ_kt
;

-- separate Aktualisierung nur der Prozentwerte
UPDATE
  ${DB_Schema_AuswNPL}.bauzonenstatistik_bebauungsstand_pro_gemeinde
  SET
    bebaut_mit_zonen_ohne_lsgrenzen_proz = Round(bebaut_mit_zonen_ohne_lsgrenzen::numeric / (bebaut_mit_zonen_ohne_lsgrenzen::numeric + unbebaut_mit_zonen_ohne_lsgrenzen::numeric) * 100),
    unbebaut_mit_zonen_ohne_lsgrenzen_proz = Round(unbebaut_mit_zonen_ohne_lsgrenzen::numeric / (bebaut_mit_zonen_ohne_lsgrenzen::numeric + unbebaut_mit_zonen_ohne_lsgrenzen::numeric) * 100),
    bebaut_mit_zonen_und_lsgrenzen_proz = Round(bebaut_mit_zonen_und_lsgrenzen::numeric / (bebaut_mit_zonen_und_lsgrenzen::numeric + unbebaut_mit_zonen_und_lsgrenzen::numeric) * 100),
    unbebaut_mit_zonen_und_lsgrenzen_proz = Round(unbebaut_mit_zonen_und_lsgrenzen::numeric / (bebaut_mit_zonen_und_lsgrenzen::numeric + unbebaut_mit_zonen_und_lsgrenzen::numeric) * 100),
    bebaut_aus_liegenschaftszuteilung_proz = Round(bebaut_aus_liegenschaftszuteilung::numeric / (bebaut_aus_liegenschaftszuteilung::numeric + unbebaut_aus_liegenschaftszuteilung::numeric) * 100),
    unbebaut_aus_liegenschaftszuteilung_proz = Round(unbebaut_aus_liegenschaftszuteilung::numeric / (bebaut_aus_liegenschaftszuteilung::numeric + unbebaut_aus_liegenschaftszuteilung::numeric) * 100)
;
