-- Vergleich der Zusammenzüge verschiedener Tabellen:
-- * arp_auswertung_nutzungsplanung_pub_v1.auswrtngtzngsznen_grundnutzungszone_aggregiert_pro_gemeinde
-- * arp_auswertung_nutzungsplanung_pub_v1.bauzonenstatistik_bebauungsstand_mit_zonen_ohne_lsgrenzen
-- * arp_auswertung_nutzungsplanung_pub_v1.bauzonenstatistik_bebauungsstand_mit_zonen_und_lsgrenzen
-- * arp_auswertung_nutzungsplanung_pub_v1.bauzonenstatistik_liegenschaft_nach_bebauungsstand
-- * arp_auswertung_nutzungsplanung_pub_v1.bauzonenstatistik_gines
-- * arp_auswertung_nutzungsplanung_pub_v1.bauzonenstatistik_bebauungsstand_pro_gemeinde

WITH nutzzon_ausw AS (
-- Flächen direkt aus Bauzonenauswertung
SELECT
        bfs_nr,
        gemeindename,
        Round(SUM(flaeche_zone_aggregiert) / 10000,2) AS summe_bauzonenflaeche
	FROM arp_auswertung_nutzungsplanung_pub_v1.auswrtngtzngsznen_grundnutzungszone_aggregiert_pro_gemeinde
	  WHERE
	    grundnutzung_typ_kt NOT IN ('N160_Gruen_und_Freihaltezone_innerhalb_Bauzone','N161_kommunale_Uferschutzzone_innerhalb_Bauzone','N169_weitere_eingeschraenkte_Bauzonen','N180_Verkehrszone_Strasse','N181_Verkehrszone_Bahnareal','N182_Verkehrszone_Flugplatzareal','N189_weitere_Verkehrszonen')
		AND substring(grundnutzung_typ_kt FROM 2 for 3)::integer < 200
	GROUP BY bfs_nr, gemeindename
	ORDER BY bfs_nr ASC
),
-- Zusammenzuege mit Zonen- ohne Liegenschaftsgrenzen
bebau_mit_zonen_ohne_lsgrenzen AS (
SELECT
        bfs_nr,
        Round(SUM(flaeche)::NUMERIC / 10000,2) AS summe_bauzonenflaeche
	FROM arp_auswertung_nutzungsplanung_pub_v1.bauzonenstatistik_bebauungsstand_mit_zonen_ohne_lsgrenzen
	  GROUP BY bfs_nr
	  ORDER BY bfs_nr ASC
),
-- Zusammenzuege mit Zonen- und Liegenschaftsgrenzen
bebau_mit_zonen_und_lsgrenzen AS (
SELECT
        bfs_nr,
        Round(SUM(flaeche)::NUMERIC / 10000,2) AS summe_bauzonenflaeche
	FROM arp_auswertung_nutzungsplanung_pub_v1.bauzonenstatistik_bebauungsstand_mit_zonen_und_lsgrenzen
	GROUP BY bfs_nr
	ORDER BY bfs_nr ASC
),
-- Zusammenzuege aus Liegenschaften nach Bebauungsstand
lie_nach_bebauung AS (
SELECT
        bfs_nr,
        Round(SUM(flaeche_beschnitten)::NUMERIC / 10000,2) AS summe_bauzonenflaeche
    FROM arp_auswertung_nutzungsplanung_pub_v1.bauzonenstatistik_liegenschaft_nach_bebauungsstand
	GROUP BY bfs_nr
	ORDER BY bfs_nr ASC
),
gines AS (
SELECT 
    bfs_nr,
    (n110_wohnzone_1_g_bebaut + n110_wohnzone_1_g_unbebaut + n111_wohnzone_2_g_bebaut + n111_wohnzone_2_g_unbebaut +
     n112_wohnzone_3_g_bebaut + n112_wohnzone_3_g_unbebaut + n113_wohnzone_4_g_bebaut + n113_wohnzone_4_g_unbebaut + n114_wohnzone_5_g_bebaut + n114_wohnzone_5_g_unbebaut + n115_wohnzone_6_g_bebaut +
     n115_wohnzone_6_g_unbebaut + n116_wohnzone_7_g_und_groesser_bebaut + n116_wohnzone_7_g_und_groesser_unbebaut + n117_zone_fuer_terrassenhaeuser_terrassensiedlung_bebaut +
     n117_zone_fuer_terrassenhaeuser_terrassensiedlung_unbebaut + n120_gewerbezone_ohne_wohnen_bebaut + n120_gewerbezone_ohne_wohnen_unbebaut + n121_industriezone_bebaut +
     n121_industriezone_unbebaut + n122_arbeitszone_bebaut + n122_arbeitszone_unbebaut + n130_gewerbezone_mit_wohnen_mischzone_bebaut +
     n130_gewerbezone_mit_wohnen_mischzone_unbebaut + n131_gewerbezone_mit_wohnen_mischzone_2_g_bebaut + n131_gewerbezone_mit_wohnen_mischzone_2_g_unbebaut +
     n132_gewerbezone_mit_wohnen_mischzone_3_g_bebaut + n132_gewerbezone_mit_wohnen_mischzone_3_g_unbebaut + n133_gewerbezone_mit_wohnen_mischzone_4_g_und_groesser_bbaut +
     n133_gewerbezone_mit_wohnen_mischzone_4_g_und_groessr_nbbaut + n134_zone_fuer_publikumsintensive_anlagen_bebaut + n134_zone_fuer_publikumsintensive_anlagen_unbebaut +
     n140_kernzone_bebaut + n140_kernzone_unbebaut + n141_zentrumszone_bebaut + n141_zentrumszone_unbebaut + n142_erhaltungszone_bebaut + n142_erhaltungszone_unbebaut +
     n150_zone_fuer_oeffentliche_bauten_bebaut + n150_zone_fuer_oeffentliche_bauten_unbebaut + n151_zone_fuer_oeffentliche_anlagen_bebaut +
     n151_zone_fuer_oeffentliche_anlagen_unbebaut + n162_landwirtschaftliche_kernzone_bebaut + n162_landwirtschaftliche_kernzone_unbebaut + n163_weilerzone_bebaut +
     n163_weilerzone_unbebaut + n170_zone_fuer_freizeit_und_erholung_bebaut + n170_zone_fuer_freizeit_und_erholung_unbebaut + n190_spezialzone_bebaut + n190_spezialzone_unbebaut)
     AS summe_bauzonenflaeche
  FROM arp_auswertung_nutzungsplanung_pub_v1.bauzonenstatistik_gines
),
-- Gemeinden-Zusammenzug
gem_zz AS (
SELECT bbgem.bfs_nr,
      Round(SUM(bebaut_mit_zonen_ohne_lsgrenzen + unbebaut_mit_zonen_ohne_lsgrenzen)::NUMERIC / 10000,2) AS bauzonenflaeche_ohne_gem,
      Round(SUM(bebaut_mit_zonen_und_lsgrenzen + unbebaut_mit_zonen_und_lsgrenzen)::NUMERIC / 10000,2) AS bauzonenflaeche_mit_gem,
      Round(SUM(bebaut_aus_liegenschaftszuteilung + unbebaut_aus_liegenschaftszuteilung)::NUMERIC / 10000,2) AS bauzonenflaeche_liegenschaft_gem
    FROM arp_auswertung_nutzungsplanung_pub_v1.bauzonenstatistik_bebauungsstand_pro_gemeinde bbgem
      WHERE
        bbgem.grundnutzung_typ_kt NOT IN ('N160_Gruen_und_Freihaltezone_innerhalb_Bauzone','N161_kommunale_Uferschutzzone_innerhalb_Bauzone','N169_weitere_eingeschraenkte_Bauzonen','N180_Verkehrszone_Strasse','N181_Verkehrszone_Bahnareal','N182_Verkehrszone_Flugplatzareal','N189_weitere_Verkehrszonen')
            AND substring(grundnutzung_typ_kt FROM 2 for 3)::integer < 200
    GROUP BY bbgem.bfs_nr, bbgem.gemeindename
    ORDER BY bfs_nr
)
-- Zusammenbauen aller Abfragen
SELECT
  nz.bfs_nr,
  nz.gemeindename,
  nz.summe_bauzonenflaeche AS bauzonenflaeche,
  bo.summe_bauzonenflaeche AS bauzonenflaeche_ohne,
  gz.bauzonenflaeche_ohne_gem,
  bm.summe_bauzonenflaeche AS bauzonenflaeche_mit,
  gz.bauzonenflaeche_mit_gem,
  li.summe_bauzonenflaeche AS bauzonenflaeche_liegenschaft,
  gz.bauzonenflaeche_liegenschaft_gem,
  gin.summe_bauzonenflaeche AS bauzonenflaeche_gines_ha
 FROM nutzzon_ausw nz
   LEFT JOIN bebau_mit_zonen_ohne_lsgrenzen bo
     ON nz.bfs_nr = bo.bfs_nr
   LEFT JOIN bebau_mit_zonen_und_lsgrenzen bm
     ON nz.bfs_nr = bm.bfs_nr
   LEFT JOIN lie_nach_bebauung li
     ON nz.bfs_nr = li.bfs_nr
   LEFT JOIN gines gin
     ON nz.bfs_nr = gin.bfs_nr
   LEFT JOIN gem_zz gz
     ON nz.bfs_nr = gz.bfs_nr
;
