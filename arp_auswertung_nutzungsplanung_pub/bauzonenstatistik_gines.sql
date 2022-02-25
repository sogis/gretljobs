-- Zusammenzug bebaute und unbebaute Parzellen nach Gemeinde, Zonentyp und bebauungsstatus
-- abgeleitet von Tabelle arp_auswertung_nutzungsplanung_pub_v1.bauzonenstatistik_bebauungsstand_pro_gemeinde

DELETE FROM arp_auswertung_nutzungsplanung_pub_v1.bauzonenstatistik_gines;

INSERT INTO
  arp_auswertung_nutzungsplanung_pub_v1.bauzonenstatistik_gines 
    (bfs_nr, gemeindename, n110_wohnzone_1_g_bebaut, n110_wohnzone_1_g_unbebaut, n111_wohnzone_2_g_bebaut, n111_wohnzone_2_g_unbebaut,
     n112_wohnzone_3_g_bebaut, n112_wohnzone_3_g_unbebaut, n113_wohnzone_4_g_bebaut, n113_wohnzone_4_g_unbebaut, n114_wohnzone_5_g_bebaut, n114_wohnzone_5_g_unbebaut, n115_wohnzone_6_g_bebaut,
     n115_wohnzone_6_g_unbebaut, n116_wohnzone_7_g_und_groesser_bebaut, n116_wohnzone_7_g_und_groesser_unbebaut, n117_zone_fuer_terrassenhaeuser_terrassensiedlung_bebaut,
     n117_zone_fuer_terrassenhaeuser_terrassensiedlung_unbebaut, n120_gewerbezone_ohne_wohnen_bebaut, n120_gewerbezone_ohne_wohnen_unbebaut, n121_industriezone_bebaut,
     n121_industriezone_unbebaut, n122_arbeitszone_bebaut, n122_arbeitszone_unbebaut, n130_gewerbezone_mit_wohnen_mischzone_bebaut,
     n130_gewerbezone_mit_wohnen_mischzone_unbebaut, n131_gewerbezone_mit_wohnen_mischzone_2_g_bebaut, n131_gewerbezone_mit_wohnen_mischzone_2_g_unbebaut,
     n132_gewerbezone_mit_wohnen_mischzone_3_g_bebaut, n132_gewerbezone_mit_wohnen_mischzone_3_g_unbebaut, n133_gewerbezone_mit_wohnen_mischzone_4_g_und_groesser_bbaut,
     n133_gewerbezone_mit_wohnen_mischzone_4_g_und_groessr_nbbaut, n134_zone_fuer_publikumsintensive_anlagen_bebaut, n134_zone_fuer_publikumsintensive_anlagen_unbebaut,
     n140_kernzone_bebaut, n140_kernzone_unbebaut, n141_zentrumszone_bebaut, n141_zentrumszone_unbebaut, n142_erhaltungszone_bebaut, n142_erhaltungszone_unbebaut,
     n150_zone_fuer_oeffentliche_bauten_bebaut, n150_zone_fuer_oeffentliche_bauten_unbebaut, n151_zone_fuer_oeffentliche_anlagen_bebaut,
     n151_zone_fuer_oeffentliche_anlagen_unbebaut, n162_landwirtschaftliche_kernzone_bebaut, n162_landwirtschaftliche_kernzone_unbebaut, n163_weilerzone_bebaut,
     n163_weilerzone_unbebaut, n170_zone_fuer_freizeit_und_erholung_bebaut, n170_zone_fuer_freizeit_und_erholung_unbebaut, n180_verkehrszone_strasse_bebaut,
     n180_verkehrszone_strasse_unbebaut, n190_spezialzone_bebaut, n190_spezialzone_unbebaut, n430_reservezone_wohnzone_mischzone_kernzone_zentrumszone,
     n431_reservezone_arbeiten, n432_reservezone_oe_ba, n439_reservezone, n320_gewaesser
    )

WITH 
gg AS (
 SELECT
    gg.bfs_gemeindenummer AS bfs_nr,
    gg.gemeindename,
    COALESCE(Round((SUM(ST_Area(grunutz.geometrie)) FILTER (WHERE grunutz.typ_kt='N430_Reservezone_Wohnzone_Mischzone_Kernzone_Zentrumszone'))::numeric / 10000,2),0) AS n430_reservezone_wohnzone_mischzone_kernzone_zentrumszone,
    COALESCE(Round((SUM(ST_Area(grunutz.geometrie)) FILTER (WHERE grunutz.typ_kt='N431_Reservezone_Arbeiten'))::numeric / 10000,2),0) AS n431_reservezone_arbeiten,
    COALESCE(Round((SUM(ST_Area(grunutz.geometrie)) FILTER (WHERE grunutz.typ_kt='N432_Reservezone_OeBA'))::numeric / 10000,2),0) AS n432_reservezone_oe_ba,
    COALESCE(Round((SUM(ST_Area(grunutz.geometrie)) FILTER (WHERE grunutz.typ_kt='N439_Reservezone'))::numeric / 10000,2),0) AS n439_reservezone,
    COALESCE(Round((SUM(ST_Area(grunutz.geometrie)) FILTER (WHERE grunutz.typ_kt='N320_Gewaesser'))::numeric / 10000,2),0) AS n320_gewaesser
  FROM agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze gg
   LEFT JOIN arp_npl_pub.nutzungsplanung_grundnutzung grunutz
    ON grunutz.bfs_nr = gg.bfs_gemeindenummer
       -- Gewaesser und Reservezonen
      AND grunutz.typ_kt IN ('N320_Gewaesser','N430_Reservezone_Wohnzone_Mischzone_Kernzone_Zentrumszone','N431_Reservezone_Arbeiten','N432_Reservezone_OeBA','N439_Reservezone') 
      GROUP BY gg.bfs_gemeindenummer, gg.gemeindename
      ORDER BY gg.bfs_gemeindenummer ASC
)
-- finales Resultat, einzelne Zonen in Spalten, Gemeinden in Zeilen
SELECT 
  gg.bfs_nr,
  gg.gemeindename,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N110_Wohnzone_1_G' AND ls.bebauungsstand IN ('bebaut','teilweise_bebaut')))::numeric / 10000,2),0) AS n110_wohnzone_1_g_bebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N110_Wohnzone_1_G' AND ls.bebauungsstand = 'unbebaut'))::numeric / 10000,2),0) AS n110_wohnzone_1_g_unbebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N111_Wohnzone_2_G' AND ls.bebauungsstand IN ('bebaut','teilweise_bebaut')))::numeric / 10000,2),0) AS n111_wohnzone_2_g_bebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N111_Wohnzone_2_G' AND ls.bebauungsstand = 'unbebaut'))::numeric / 10000,2),0) AS n111_wohnzone_2_g_unbebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N112_Wohnzone_3_G' AND ls.bebauungsstand IN ('bebaut','teilweise_bebaut')))::numeric / 10000,2),0) AS n112_wohnzone_3_g_bebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N112_Wohnzone_3_G' AND ls.bebauungsstand = 'unbebaut'))::numeric / 10000,2),0) AS n112_wohnzone_3_g_unbebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N113_Wohnzone_4_G' AND ls.bebauungsstand IN ('bebaut','teilweise_bebaut')))::numeric / 10000,2),0) AS n113_wohnzone_4_g_bebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N113_Wohnzone_4_G' AND ls.bebauungsstand = 'unbebaut'))::numeric / 10000,2),0) AS n113_wohnzone_4_g_unbebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N114_Wohnzone_5_G' AND ls.bebauungsstand IN ('bebaut','teilweise_bebaut')))::numeric / 10000,2),0) AS n114_wohnzone_5_g_bebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N114_Wohnzone_5_G' AND ls.bebauungsstand = 'unbebaut'))::numeric / 10000,2),0) AS n114_wohnzone_5_g_unbebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N115_Wohnzone_6_G' AND ls.bebauungsstand IN ('bebaut','teilweise_bebaut')))::numeric / 10000,2),0) AS n115_wohnzone_6_g_bebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N115_Wohnzone_6_G' AND ls.bebauungsstand = 'unbebaut'))::numeric / 10000,2),0) AS n115_wohnzone_6_g_unbebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N116_Wohnzone_7_G_und_groesser' AND ls.bebauungsstand IN ('bebaut','teilweise_bebaut')))::numeric / 10000,2),0) AS n116_wohnzone_7_g_und_groesser_bebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N116_Wohnzone_7_G_und_groesser' AND ls.bebauungsstand = 'unbebaut'))::numeric / 10000,2),0) AS n116_wohnzone_7_g_und_groesser_unbebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N117_Zone_fuer_Terrassenhaeuser_Terrassensiedlung' AND ls.bebauungsstand IN ('bebaut','teilweise_bebaut')))::numeric / 10000,2),0) AS n117_zone_fuer_terrassenhaeuser_terrassensiedlung_bebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N117_Zone_fuer_Terrassenhaeuser_Terrassensiedlung' AND ls.bebauungsstand = 'unbebaut'))::numeric / 10000,2),0) AS n117_zone_fuer_terrassenhaeuser_terrassensiedlung_unbebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N120_Gewerbezone_ohne_Wohnen' AND ls.bebauungsstand IN ('bebaut','teilweise_bebaut')))::numeric / 10000,2),0) AS n120_gewerbezone_ohne_wohnen_bebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N120_Gewerbezone_ohne_Wohnen' AND ls.bebauungsstand = 'unbebaut'))::numeric / 10000,2),0) AS n120_gewerbezone_ohne_wohnen_unbebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N121_Industriezone' AND ls.bebauungsstand IN ('bebaut','teilweise_bebaut')))::numeric / 10000,2),0) AS n121_industriezone_bebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N121_Industriezone' AND ls.bebauungsstand = 'unbebaut'))::numeric / 10000,2),0) AS n121_industriezone_unbebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N122_Arbeitszone' AND ls.bebauungsstand IN ('bebaut','teilweise_bebaut')))::numeric / 10000,2),0) AS n122_arbeitszone_bebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N122_Arbeitszone' AND ls.bebauungsstand = 'unbebaut'))::numeric / 10000,2),0) AS n122_arbeitszone_unbebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N130_Gewerbezone_mit_Wohnen_Mischzone' AND ls.bebauungsstand IN ('bebaut','teilweise_bebaut')))::numeric / 10000,2),0) AS n130_gewerbezone_mit_wohnen_mischzone_bebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N130_Gewerbezone_mit_Wohnen_Mischzone' AND ls.bebauungsstand = 'unbebaut'))::numeric / 10000,2),0) AS n130_gewerbezone_mit_wohnen_mischzone_unbebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N131_Gewerbezone_mit_Wohnen_Mischzone_2_G' AND ls.bebauungsstand IN ('bebaut','teilweise_bebaut')))::numeric / 10000,2),0) AS n131_gewerbezone_mit_wohnen_mischzone_2_g_bebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N131_Gewerbezone_mit_Wohnen_Mischzone_2_G' AND ls.bebauungsstand = 'unbebaut'))::numeric / 10000,2),0) AS n131_gewerbezone_mit_wohnen_mischzone_2_g_unbebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N132_Gewerbezone_mit_Wohnen_Mischzone_3_G' AND ls.bebauungsstand IN ('bebaut','teilweise_bebaut')))::numeric / 10000,2),0) AS n132_gewerbezone_mit_wohnen_mischzone_3_g_bebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N132_Gewerbezone_mit_Wohnen_Mischzone_3_G' AND ls.bebauungsstand = 'unbebaut'))::numeric / 10000,2),0) AS n132_gewerbezone_mit_wohnen_mischzone_3_g_unbebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N133_Gewerbezone_mit_Wohnen_Mischzone_4_G_und_groesser' AND ls.bebauungsstand IN ('bebaut','teilweise_bebaut')))::numeric / 10000,2),0) AS n133_gewerbezone_mit_wohnen_mischzone_4_g_und_groesser_bbaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N133_Gewerbezone_mit_Wohnen_Mischzone_4_G_und_groesser' AND ls.bebauungsstand = 'unbebaut'))::numeric / 10000,2),0) AS n133_gewerbezone_mit_wohnen_mischzone_4_g_und_groessr_nbbaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N134_Zone_fuer_publikumsintensive_Anlagen' AND ls.bebauungsstand IN ('bebaut','teilweise_bebaut')))::numeric / 10000,2),0) AS n134_zone_fuer_publikumsintensive_anlagen_bebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N134_Zone_fuer_publikumsintensive_Anlagen' AND ls.bebauungsstand = 'unbebaut'))::numeric / 10000,2),0) AS n134_zone_fuer_publikumsintensive_anlagen_unbebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N140_Kernzone' AND ls.bebauungsstand IN ('bebaut','teilweise_bebaut')))::numeric / 10000,2),0) AS n140_kernzone_bebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N140_Kernzone' AND ls.bebauungsstand = 'unbebaut'))::numeric / 10000,2),0) AS n140_kernzone_unbebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N141_Zentrumszone' AND ls.bebauungsstand IN ('bebaut','teilweise_bebaut')))::numeric / 10000,2),0) AS n141_zentrumszone_bebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N141_Zentrumszone' AND ls.bebauungsstand = 'unbebaut'))::numeric / 10000,2),0) AS n141_zentrumszone_unbebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N142_Erhaltungszone' AND ls.bebauungsstand IN ('bebaut','teilweise_bebaut')))::numeric / 10000,2),0) AS n142_erhaltungszone_bebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N142_Erhaltungszone' AND ls.bebauungsstand = 'unbebaut'))::numeric / 10000,2),0) AS n142_erhaltungszone_unbebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N150_Zone_fuer_oeffentliche_Bauten' AND ls.bebauungsstand IN ('bebaut','teilweise_bebaut')))::numeric / 10000,2),0) AS n150_zone_fuer_oeffentliche_bauten_bebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N150_Zone_fuer_oeffentliche_Bauten' AND ls.bebauungsstand = 'unbebaut'))::numeric / 10000,2),0) AS n150_zone_fuer_oeffentliche_bauten_unbebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N151_Zone_fuer_oeffentliche_Anlagen' AND ls.bebauungsstand IN ('bebaut','teilweise_bebaut')))::numeric / 10000,2),0) AS n151_zone_fuer_oeffentliche_anlagen_bebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N151_Zone_fuer_oeffentliche_Anlagen' AND ls.bebauungsstand = 'unbebaut'))::numeric / 10000,2),0) AS n151_zone_fuer_oeffentliche_anlagen_unbebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N162_Landwirtschaftliche_Kernzone' AND ls.bebauungsstand IN ('bebaut','teilweise_bebaut')))::numeric / 10000,2),0) AS n162_landwirtschaftliche_kernzone_bebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N162_Landwirtschaftliche_Kernzone' AND ls.bebauungsstand = 'unbebaut'))::numeric / 10000,2),0) AS n162_landwirtschaftliche_kernzone_unbebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N163_Weilerzone' AND ls.bebauungsstand IN ('bebaut','teilweise_bebaut')))::numeric / 10000,2),0) AS n163_weilerzone_bebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N163_Weilerzone' AND ls.bebauungsstand = 'unbebaut'))::numeric / 10000,2),0) AS n163_weilerzone_unbebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N170_Zone_fuer_Freizeit_und_Erholung' AND ls.bebauungsstand IN ('bebaut','teilweise_bebaut')))::numeric / 10000,2),0) AS n170_zone_fuer_freizeit_und_erholung_bebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N170_Zone_fuer_Freizeit_und_Erholung' AND ls.bebauungsstand = 'unbebaut'))::numeric / 10000,2),0) AS n170_zone_fuer_freizeit_und_erholung_unbebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N180_Verkehrszone_Strasse' AND ls.bebauungsstand IN ('bebaut','teilweise_bebaut')))::numeric / 10000,2),0) AS n180_verkehrszone_strasse_bebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N180_Verkehrszone_Strasse' AND ls.bebauungsstand = 'unbebaut'))::numeric / 10000,2),0) AS n180_verkehrszone_strasse_unbebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N190_Spezialzone' AND ls.bebauungsstand IN ('bebaut','teilweise_bebaut')))::numeric / 10000,2),0) AS n190_spezialzone_bebaut,
  COALESCE(Round((SUM(ls.flaeche_beschnitten) FILTER (WHERE ls.grundnutzung_typ_kt = 'N190_Spezialzone' AND ls.bebauungsstand = 'unbebaut'))::numeric / 10000,2),0) AS n190_spezialzone_unbebaut,
  gg.n430_reservezone_wohnzone_mischzone_kernzone_zentrumszone,
  gg.n431_reservezone_arbeiten,
  gg.n432_reservezone_oe_ba,
  gg.n439_reservezone,
  gg.n320_gewaesser
FROM
  gg
  LEFT JOIN arp_auswertung_nutzungsplanung_pub_v1.bauzonenstatistik_liegenschaft_nach_bebauungsstand ls
    ON ls.bfs_nr = gg.bfs_nr
  GROUP BY gg.bfs_nr, gg.gemeindename, gg.n430_reservezone_wohnzone_mischzone_kernzone_zentrumszone, gg.n431_reservezone_arbeiten,
    gg.n432_reservezone_oe_ba, gg.n439_reservezone, gg.n320_gewaesser
  ORDER BY gg.bfs_nr 
 ;
