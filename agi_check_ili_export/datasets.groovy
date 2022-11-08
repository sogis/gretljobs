buildscript {
    repositories {
        flatDir {
            dirs '/home/gradle/libs'
        }
    }
    dependencies {
        classpath fileTree(dir: '/home/gradle/libs', include: '*.jar')
    }
}

import ch.so.agi.gretl.api.Connector

def dbEdit = [dbUriEdit, dbUserEdit, dbPwdEdit]
//def dbSogis = [dbUriSogis, dbUserSogis, dbPwdSogis]
def dbPub = [dbUriPub, dbUserPub, dbPwdPub]

class Dataset {
    String models
    String dbschema
    Connector database
    String datasetId
    boolean isPublic
    String exportModel
    boolean configReadFromDb = true

    Dataset(String models, String dbschema, ArrayList database, String datasetId, boolean isPublic, String exportModel) {
        this.models = models
        this.dbschema = dbschema
        this.database = database
        this.datasetId = datasetId
        this.isPublic = isPublic
        this.exportModel = exportModel
    }

    Dataset(String models, String dbschema, ArrayList database, String datasetId, boolean isPublic) {
        this.models = models
        this.dbschema = dbschema
        this.database = database
        this.datasetId = datasetId
        this.isPublic = isPublic
    }

    Dataset(String models, String dbschema, ArrayList database, String datasetId) {
        this(models, dbschema, database, datasetId, false)
    }    
}

ext.datasets = []

// Edit-DB
// Nicht exportiert werden:
// - *_oereb: Werden bereits im ÖREB-Katasterprozess exportiert und in den gleichen Bucket hochgeladen.
// - agi_dm01avso24
// - agi_lro_auflage (temporär)
// - agi_plz_ortschaften
// - agi_swisstopo_gebaeudeadressen
// - alw_bund_hanglagen_allgemein: Kosten/Nutzen. Interessiert wohl wirklich niemand in INTERLIS.
// - alw_zonengrenzen: Externe und greifbare Daten (?)
// - arp_npl

// datasets.add(new Dataset("SO_ADA_Denkmal_20191128", "ada_denkmalschutz", dbEdit, "ch.so.ada.denkmalschutz_edit"))
// datasets.add(new Dataset("SO_ALW_FFF_Uebersteuerung_20210528", "afu_abbaustellen_fff_v1", dbEdit, "ch.so.afu.abbaustellen_fff_edit"))
// datasets.add(new Dataset("SO_AFU_ABBAUSTELLEN_20210630", "afu_abbaustellen_v1", dbEdit, "ch.so.afu.abbaustellen_edit"))
// datasets.add(new Dataset("SO_AFU_Abwasserbauwerke_20220323", "afu_abwasserbauwerke_v1", dbEdit, "ch.so.afu.abwasserbauwerke_edit"))
// datasets.add(new Dataset("SO_AFU_ARA_Einzugsgebiete_20201016", "afu_ara_einzugsgebiete", dbEdit, "ch.so.afu.ara_einzugsgebiete_edit"))
// datasets.add(new Dataset("SO_AfU_BauGK_CCCCache_20180507", "afu_baugk_ccccache_v1", dbEdit, "ch.so.afu.baugk_ccccache_edit"))
// datasets.add(new Dataset("SO_AFU_Baugrundklassen_20201023", "afu_baugrundklassen_v1", dbEdit, "ch.so.afu.baugrundklassen_edit"))
// datasets.add(new Dataset("NABODAT_ErgebnisseBodenbelastung_Punktdaten_V1_1", "afu_bodendaten_nabodat_v1", dbEdit, "ch.so.afu.bodendaten_nabodat_edit"))
// datasets.add(new Dataset("SO_AFU_Nagra_Bohrtiefen_20190927", "afu_erdwaermesonden_nagra", dbEdit, "ch.so.afu.erdwaermesonden_nagra_edit"))
// datasets.add(new Dataset("SO_AFU_Erdwaermesonden_private_Quellen_20220719", "afu_erdwaermesonden_private_quellen_v1", dbEdit, "ch.so.afu.erdwaermesonden_private_quellen_edit"))
// datasets.add(new Dataset("SO_AfU_Erdwaermesonden_20200421", "afu_erdwaermesonden_v2", dbEdit, "ch.so.afu.erdwaermesonden_edit"))
// datasets.add(new Dataset("SO_AFU_Fischwanderhindernisse_20220630", "afu_fischwanderhindernisse_v1", dbEdit, "ch.so.afu.fischwanderhindernisse_edit"))
// datasets.add(new Dataset("SO_AfU_Gefahrenkartierung_20181129", "afu_gefahrenkartierung", dbEdit, "ch.so.afu.gefahrenkartierung_edit"))
// datasets.add(new Dataset("Hazard_Mapping_LV95_V1_2", "afu_gefahrenkartierung_mgdm", dbEdit, "ch.so.afu.gefahrenkartierung_mgdm"))
// datasets.add(new Dataset("SO_AFU_Geologie_20200831", "afu_geologie_v1", dbEdit, "ch.so.afu.geologie_edit"))
// datasets.add(new Dataset("SO_AFU_Geotope_20200312", "afu_geotope", dbEdit, "ch.so.afu.geotope_edit"))
// datasets.add(new Dataset("SO_AFU_Gewaesser_Revitalisierung_20220629", "afu_gewaesser_revitalisierung_v1", dbEdit, "ch.so.afu.gewaesser_revitalisierung_edit"))
// datasets.add(new Dataset("SO_AFU_Gewaesser_20220401", "afu_gewaesser_v1", dbEdit, "ch.so.afu.gewaesser_edit"))
// datasets.add(new Dataset("PlanerischerGewaesserschutz_LV95_V1_1", "afu_gewaesserschutz", dbEdit, "ch.so.afu.gewaesserschutz_edit"))
// datasets.add(new Dataset("SO_AFU_Hydro_Messstationen_20220706", "afu_hydro_messstationen_v1", dbEdit, "ch.so.afu.hydrologie.messstationen_edit"))
// datasets.add(new Dataset("SO_AFU_Hydrologische_Einzugsgebiete_20220628", "afu_hydrologische_einzugsgebiete_v1", dbEdit, "ch.so.afu.hydrologische_einzugsgebiete_edit"))
// datasets.add(new Dataset("SO_AFU_Igel_202000429", "afu_igel", dbEdit, "ch.so.afu.igel_edit"))
// datasets.add(new Dataset("SO_AFU_Immissionskarten_20220522", "afu_immissionskarten_luft_v1", dbEdit, "ch.so.afu.immissionskarten_luft_edit"))
// datasets.add(new Dataset("SO_AFU_Infoflora_20211008", "afu_infoflora", dbEdit, "ch.so.afu.infoflora_edit"))
// datasets.add(new Dataset("SO_AFU_Schadendienst_20220512", "afu_schadendienst_v1", dbEdit, "ch.so.afu.schadendienst_edit"))
// datasets.add(new Dataset("SO_AFU_Verzeichnis_schadstoffbelastete_Boeden_20200622", "afu_schadstoffbelastete_boeden", dbEdit, "ch.so.afu.schadstoffbelastete_boeden_edit"))
// datasets.add(new Dataset("SO_AFU_Stoerfallverordnung_20220711", "afu_stoerfallverordnung_v1", dbEdit, "ch.so.afu.stoerfallverordnung_edit"))
// datasets.add(new Dataset("SO_AfU_Luftreinhaltung_20191105", "afu_uplus_luft", dbEdit, "ch.so.afu.uplus_luft_edit"))
// datasets.add(new Dataset("SO_AfU_Tankanlage_20191105", "afu_uplus_tank", dbEdit, "ch.so.afu.uplus_tank_edit"))
// datasets.add(new Dataset("SO_AGEM_Fila_20190318", "agem_fila", dbEdit, "ch.so.agem.fila_edit"))
// datasets.add(new Dataset("DM08BaulinienSOLV95", "agi_av_baulinien_ng", dbEdit, "ch.so.agi.av_baulinien_edit"))
// datasets.add(new Dataset("SO_AGI_AVGB_abgleich_import_20210429", "agi_av_gb_abgleich_import", dbEdit, "ch.so.agi.av_gb_abgleich_edit"))
// datasets.add(new Dataset("SO_AGI_AV_GB_Administrative_Einteilungen_20180613", "agi_av_gb_admin_einteilung", dbEdit, "ch.so.agi.av_gb_admin_einteilung_edit"))
// datasets.add(new Dataset("SO_AGI_AV_KASO_abgleich_import_20210429", "agi_av_kaso_abgleich_import", dbEdit, "ch.so.agi.av_kaso_abgleich_edit"))
// datasets.add(new Dataset("SO_AGI_MOCheckSO_20200715", "agi_av_mocheckso", dbEdit, "ch.so.agi.av_mocheckso_edit"))
// datasets.add(new Dataset("GB2AV", "agi_gb2av", dbEdit, "ch.so.agi.gb2av_edit"))
// datasets.add(new Dataset("SO_AGI_GB2AV_Controlling_20201002", "agi_gb2av_controlling", dbEdit, "ch.so.agi.gb2av_controlling_edit"))
// datasets.add(new Dataset("SO_AGI_Inventar_Hoheitsgrenzen_20191129", "agi_inventar_hoheitsgrenzen", dbEdit, "ch.so.agi.inventar_hoheitsgrenzen_edit"))
// //datasets.add(new Dataset("SIA405_Abwasser_WI", "agi_leitungskataster_abw", dbEdit, "ch.so.agi.leitungskataster_abwasser_edit")) // Geht glaub wegen ili1 nicht. Ich teile ili2pg mit, dass ich ili2 exportiere.
// //datasets.add(new Dataset("SIA405_mit_Erweiterungen", "agi_leitungskataster_ele", dbEdit, "ch.so.agi.leitungskataster_elektro_edit")) // Kann wegen NaN-Coords nicht exportiert werden. ili2pg ist gefixed. NaN werden beim Umbau entfernt.
// //datasets.add(new Dataset("SIA405_Wasser_WI", "agi_leitungskataster_was", dbEdit, "ch.so.agi.leitungskataster_wasser_edit")) // Geht glaub wegen ili1 nicht. Ich teile ili2pg mit, dass ich ili2 exportiere.
// datasets.add(new Dataset("SO_ALW_Fruchtfolgeflaechen_Publikation_20220110", "alw_fruchtfolgeflaechen_v1", dbEdit, "ch.so.alw.fruchtfolgeflaechen_edit"))
// datasets.add(new Dataset("SO_ALW_GELAN_Hilfsgeometrien_20210426", "alw_gelan_hilfsgeometrien", dbEdit, "ch.so.alw.gelan_hilfsgeometrien_edit"))
// datasets.add(new Dataset("SO_ALW_Gewaesserraum_20210531", "alw_gewaesserraum_v1", dbEdit, "ch.so.alw.gewaesserraum_edit"))
// // Problemdatensatz. Weiss momentan gar nicht, ob wir den nicht eh geliefert bekommen.
// //datasets.add(new Dataset("SO_ALW_Landwirtschaft_Tierhaltung_20210426", "alw_landwirtschaft_tierhaltung_v1", dbEdit, "ch.so.alw_landwirtschaft_tierhaltung_edit"))
// datasets.add(new Dataset("SO_ALW_Strukturverbesserungen_20190912", "alw_strukturverbesserungen", dbEdit, "ch.so.alw.strukturverbesserungen_edit"))
// datasets.add(new Dataset("Strukturverbesserungen_LV95_V2", "alw_strukturverbesserungen_suissemelio", dbEdit, "ch.so.alw.strukturverbesserungen_suissemelio_edit"))
// datasets.add(new Dataset("SO_ALW_Tiergesundheit_Massnahmen_20210426", "alw_tiergesundheit_massnahmen", dbEdit, "ch.so.alw.tiergesundheit_massnahmen_edit"))
// datasets.add(new Dataset("SO_ALW_FFF_Uebersteuerung_20220404", "alw_uebersteuerung_fff_v2", dbEdit, "ch.so.alw.uebersteuerung_fff_edit"))
// datasets.add(new Dataset("SO_AMB_Notfalltreffpunkte_20180413", "amb_notfalltreffpunkte", dbEdit, "ch.so.amb.notfalltreffpunkte_edit"))
// datasets.add(new Dataset("SO_AMB_Sirenenplanung_20200831", "amb_sirenenplanung_v1", dbEdit, "ch.so.amb.sirenenplanung_edit"))
// datasets.add(new Dataset("SO_Agglomerationsprogramme_20200618", "arp_agglomerationsprogramme", dbEdit, "ch.so.arp.agglomerationsprogramme_edit"))
// datasets.add(new Dataset("SO_ARP_Auswertungen_Nutzungsplanung_20210126", "arp_auswertung_nutzungsplanung_v1", dbEdit, "ch.so.arp.auswertung_nutzungsplanung_edit"))
// datasets.add(new Dataset("SO_ARP_Baugis_20190612", "arp_baugis", dbEdit, "ch.so.arp.baugis_edit"))
// datasets.add(new Dataset("SO_ARP_Fledermausfundorte_20200728", "arp_fledermaus", dbEdit, "ch.so.arp.fledermausstandorte_edit"))
// // Problemdatensatz:
// //datasets.add(new Dataset("Laermempfindlichkeitsstufen_LV95_V1_1", "arp_laermempfindlichkeitsstufen_mgdm", dbEdit, "ch.so.arp.laermempfindlichkeitsstufen_mgdm"))
// datasets.add(new Dataset("SO_ARP_Mehrjahresprogramm_20200228", "arp_mehrjahresprogramm", dbEdit, "ch.so.arp.mehrjahresprogramm_edit"))
// datasets.add(new Dataset("SO_ARP_Naturreservate_20200609", "arp_naturreservate", dbEdit, "ch.so.arp.naturreservate_edit"))
// datasets.add(new Dataset("SO_ARP_Naturschutzobjekte_20210727", "arp_naturschutzobjekte_v1", dbEdit, "ch.so.arp.naturschutzobjekte_edit"))
// datasets.add(new Dataset("Nutzungsplanung_LV95_V1_1", "arp_npl_mgdm", dbEdit, "ch.so.arp.npl_mgdm"))
// datasets.add(new Dataset("SO_ARP_Nutzungsvereinbarung_20170512", "arp_nutzungsvereinbarung", dbEdit, "ch.so.arp.nutzungsvereinbarung_edit"))
// datasets.add(new Dataset("SO_ARP_Richtplan_20220630", "arp_richtplan_v1", dbEdit, "ch.so.arp.richtplan_edit"))
// datasets.add(new Dataset("Waldabstandslinien_LV95_V1_1", "arp_waldabstandslinien_mgdm", dbEdit, "ch.so.arp.waldabstandslinien_mgdm"))
// datasets.add(new Dataset("SO_ARP_Waldreservate_20220607", "arp_waldreservate_v1", dbEdit, "ch.so.arp.waldreservate_edit"))
// datasets.add(new Dataset("Wildruhezonen_LV95_V2_1", "arp_wildruhezonen_mgdm_v1", dbEdit, "ch.so.arp.wildruhezonen_mgdm"))
// datasets.add(new Dataset("SO_AVT_Kunstbauten_Publikation_20220207", "avt_kunstbauten_staging_v1", dbEdit, "ch.so.arp.kunstbauten_staging_edit"))
// datasets.add(new Dataset("SO_AVT_Oeffentlicher_Verkehr_20210205", "avt_oeffentlicher_verkehr", dbEdit, "ch.so.avt.oeffentlicher_verkehr_edit"))
// datasets.add(new Dataset("SO_AVT_Oev_Gueteklassen_20220120", "avt_oev_gueteklassen_staging_v1", dbEdit, "ch.so.avt.oev_gueteklassen_staging_edit"))
// datasets.add(new Dataset("SO_AVT_OevKov_20181107", "avt_oevkov_2018", dbEdit, "ch.so.avt.oevkov2018_edit")) 
// datasets.add(new Dataset("SO_AVT_OevKov_20190805", "avt_oevkov_2019", dbEdit, "ch.so.avt.oevkov2019_edit")) 
// datasets.add(new Dataset("SO_AVT_OevKov_20200420", "avt_oevkov_2020", dbEdit, "ch.so.avt.oevkov2020_edit")) 
// datasets.add(new Dataset("SO_AVT_OevKov_20210330", "avt_oevkov_2021", dbEdit, "ch.so.avt.oevkov2021_edit")) 
// datasets.add(new Dataset("SO_AVT_OevKov_20210330", "avt_oevkov_2022_v1", dbEdit, "ch.so.avt.oevkov2022_edit")) 
// datasets.add(new Dataset("SO_AVT_Strassenlaerm_20190806", "avt_strassenlaerm", dbEdit, "ch.so.avt.strassenlaerm_edit")) 
// datasets.add(new Dataset("SO_AVT_Verkehrszaehlstellen_20190206", "avt_verkehrszaehlstellen", dbEdit, "ch.so.avt.verkehrszaehlstellen_edit")) 
// datasets.add(new Dataset("SupplySecurity_RuledAreas_V1_2", "awa_stromversorgungssicherheit", dbEdit, "ch.so.awa.stromversorgungssicherheit_netzgebiete_edit"))  
// datasets.add(new Dataset("SO_Forstreviere_20170512", "awjf_forstreviere", dbEdit, "ch.so.awjf.forstreviere_edit")) 
// datasets.add(new Dataset("SO_AWJF_Gesuchsteller_20210202", "awjf_gesuchsteller", dbEdit, "ch.so.awjf.gesuchsteller_edit")) 
// datasets.add(new Dataset("SO_AWJF_Jagdreviere_Jagdbanngebiete_202000804", "awjf_jagdreviere_jagdbanngebiete_v1", dbEdit, "ch.so.awjf.jagdreviere_jagdbanngebiete_edit")) 
// datasets.add(new Dataset("SO_AWJF_Naturgefahrenhinweiskarte_20220125", "awjf_naturgefahrenhinweiskarte_v1", dbEdit, "ch.so.awjf.naturgefahrenhinweiskarte_edit")) 
// datasets.add(new Dataset("SO_AWJF_Nullflaechen_20220614", "awjf_nullflaechen_v1", dbEdit, "ch.so.awjf.nullflaechen_edit")) 
// datasets.add(new Dataset("SO_AWJF_Programm_Biodiversitaet_Wald_20220224", "awjf_programm_biodiversitaet_wald_v1", dbEdit, "ch.so.awjf.programm_biodiversitaet_edit")) 
// datasets.add(new Dataset("SO_AWJF_Schutzwald_20220617", "awjf_schutzwald_v1", dbEdit, "ch.so.awjf.schutzwald_edit")) 
// datasets.add(new Dataset("SO_AWJF_Seltene_Baumarten_20190211", "awjf_seltene_baeume", dbEdit, "ch.so.awjf.seltene_baeume_edit")) 
// datasets.add(new Dataset("SO_AWJF_Statische_Waldgrenzen_20191119", "awjf_statische_waldgrenze", dbEdit, "ch.so.awjf.statische_waldgrenze_edit")) 
// datasets.add(new Dataset("Waldgrenzen_LV95_V1_1", "awjf_statische_waldgrenzen_mgdm", dbEdit, "ch.so.awjf.statische_waldgrenzen_mgdm")) 
// datasets.add(new Dataset("SO_AWJF_Wald_Basensaettigung_20211021", "awjf_wald_basensaettigung_v1", dbEdit, "ch.so.awjf.wald_basensaettigung_edit")) 
// datasets.add(new Dataset("SO_AWJF_Wald_Oberhoehenbonitaet_20211027", "awjf_wald_oberhoehenbonitaet_v1", dbEdit, "ch.so.awjf.wald_oberhoehenbonitaet_edit")) 
// datasets.add(new Dataset("SO_AWJF_Waldpflege_Erfassung_20210202", "awjf_waldpflege_erfassung", dbEdit, "ch.so.awjf.waldpflege_erfassung_edit")) 
// datasets.add(new Dataset("SO_AWJF_Waldpflege_Kontrolle_20210202", "awjf_waldpflege_kontrolle", dbEdit, "ch.so.awjf.waldpflege_kontrolle_edit")) 
// datasets.add(new Dataset("SO_AWJF_Waldstandorte_20211027", "awjf_waldstandorte_v1", dbEdit, "ch.so.awjf.waldstandorte_edit")) 
// datasets.add(new Dataset("SO_AWJF_Waldwanderwege_202000804", "awjf_waldwanderwege", dbEdit, "ch.so.awjf.waldwanderwege_edit")) 
// datasets.add(new Dataset("SO_AWJF_Wegsanierungen_20170629", "awjf_wegsanierungen_v1", dbEdit, "ch.so.awjf.wegsanierungen_edit")) 
// datasets.add(new Dataset("SO_AWJF_Wildtierkorridore_20210831", "awjf_wildtierkorridore_v1", dbEdit, "ch.so.awjf.wildtierkorridore_edit")) 
// datasets.add(new Dataset("SO_KSTA_Landwert_20210202", "ksta_landwerte", dbEdit, "ch.so.ksta.landwerte_edit")) // Identisch mit Pub-Modell und -Inhalt.
// datasets.add(new Dataset("SO_SGV_Erschliessung_ausserhalb_Bauzone_20190611", "sgv_erschliessungen", dbEdit, "ch.so.sgv.erschliessungen_edit")) 


// SOGIS-DB
// Die paar Modelle scheinen nicht auf die Schnelle exportierbar zu sein. Macht uns zu einem späteren Zeitpunkt vielleicht noch Bauchweh.

// Pub-DB
// Nicht exportiert werden:
// - agi_lidar_pub: Temporär
// - alw_bund_hanglagen_allgemein: Kosten/Nutzen. Interessiert wohl niemanden. Externe Ursprungsdaten.

datasets.add(new Dataset("SO_ADA_Denkmal_Pub_20211011", "ada_denkmalschutz_pub", dbPub, "ch.so.ada.denkmalschutz", true)) 
datasets.add(new Dataset("SO_AFU_ABBAUSTELLEN_Publikation_20210630", "afu_abbaustellen_pub_v1", dbPub, "ch.so.afu.abbaustellen")) 
datasets.add(new Dataset("SO_AFU_Abwasserbauwerke_Publikation_20220323", "afu_abwasserbauwerke_pub_v1", dbPub, "ch.so.afu.abwasserbauwerke", true)) 
datasets.add(new Dataset("SO_AFU_ARA_Einzugsgebiete_20201016", "afu_ara_einzugsgebiete_pub", dbPub, "ch.so.afu.ara_einzugsgebiete", true)) 
datasets.add(new Dataset("SO_AfU_BauGK_CCCCache_20180507", "afu_baugk_ccccache", dbPub, "ch.so.afu.baugk_ccccache")) 
datasets.add(new Dataset("SO_AFU_Baugrundklassen_Publikation_20201023", "afu_baugrundklassen_pub_v1", dbPub, "ch.so.afu.baugrundklassen", true)) 

datasets.add(new Dataset("SO_AFU_Bodenprofilstandorte_Publikation_20210129", "afu_bodendaten_nabodat_pub", dbPub, "ch.so.afu.bodendaten_nabodat"))
datasets.add(new Dataset("SO_AFU_Bodendaten_schadstoffuntersuchung_Publikation_20200928", "afu_bodendaten_schadstoffuntersuchung_pub", dbPub, "ch.so.afu.bodendaten_schadstoffuntersuchung", true)) 
datasets.add(new Dataset("SO_AFU_Ekat_Publikation_20190222", "afu_ekat2015_pub", dbPub, "ch.so.afu.ekat2015", true)) 
datasets.add(new Dataset("SO_AFU_Nagra_Bohrtiefen_20190927", "afu_erdwaermesonden_nagra_pub", dbPub, "ch.so.afu.erdwaermesonden_nagra")) 
datasets.add(new Dataset("SO_AFU_Erdwaermesonden_private_Quellen_Publikation_20220719", "afu_erdwaermesonden_private_quellen_pub_v1", dbPub, "ch.so.afu.private_quellen")) 
datasets.add(new Dataset("SO_AfU_Erdwaermesonden_Publikation_20200113", "afu_erdwaermesonden_pub", dbPub, "ch.so.afu.erdwaermesonden", true)) 
datasets.add(new Dataset("SO_AFU_Fischwanderhindernisse_Publikation_20220630", "afu_fischwanderhindernisse_pub_v1", dbPub, "ch.so.afu.fischwanderhindernisse", true)) 
datasets.add(new Dataset("SO_AfU_Gefahrenkartierung_20181129", "afu_gefahrenkartierung_pub", dbPub, "ch.so.afu.gefahrenkartierung")) 

datasets.add(new Dataset("SO_AFU_Geologie_20200831", "afu_geologie_pub_v1", dbPub, "ch.so.afu.geologie", true)) 
datasets.add(new Dataset("SO_AFU_Geotope_Publikation_20200623", "afu_geotope_pub", dbPub, "ch.so.afu.geotope")) 
datasets.add(new Dataset("SO_AFU_Gewaesser_Gewaessereigenschaften_Publikation_20220427", "afu_gewaesser_gewaessereigenschaften_pub_v1", dbPub, "ch.so.afu.gewaesser_gewaessereigenschaften", true)) 
datasets.add(new Dataset("SO_AFU_Gewaesser_Oekomorphologie_Publikation_20220426", "afu_gewaesser_oekomorphologie_pub_v1", dbPub, "ch.so.afu.gewaesser_oekmorphologie", true)) 
datasets.add(new Dataset("SO_AFU_Gewaesser_Revitalisierung_20220629", "afu_gewaesser_revitalisierung_pub_v1", dbPub, "ch.so.afu.gewaesser_revitalisierung", true)) 
// Kann nicht in GeoPackage importiert werden, weil das Modell nicht gefunden wird:
// datasets.add(new Dataset("SO_AfU_Gewaesserschutz_Publikation_20210303", "afu_gewaesserschutz_pub", dbPub, "ch.so.afu.gewaesserschutz", true))
datasets.add(new Dataset("SO_AFU_Hydro_Messstationen_Publikation_20220707", "afu_hydro_messstationen_pub_v1", dbPub, "ch.so.afu.hydrologie.messstationen")) 
datasets.add(new Dataset("SO_AFU_Hydrologische_Einzugsgebiete_20220628", "afu_hydrologische_einzugsgebiete_pub_v1", dbPub, "ch.so.afu.hydrologische_einzugsgebiete")) 
datasets.add(new Dataset("SO_AFU_Igel_Publikation_20211116", "afu_igel_pub_v1", dbPub, "ch.so.afu.igel")) 
datasets.add(new Dataset("SO_AFU_Immissionskarten_20220522", "afu_immissionskarten_luft_pub_v1", dbPub, "ch.so.afu.immissionskarten_luft")) 

datasets.add(new Dataset("SO_AFU_Infoflora_Publikation_20211013", "afu_infoflora_pub", dbPub, "ch.so.afu.infoflora"))
datasets.add(new Dataset("SO_AFU_Schadendienst_20220512", "afu_schadendienst_pub_v1", dbPub, "ch.so.afu.schadendienst"))
datasets.add(new Dataset("SO_AFU_Verzeichnis_schadstoffbelastete_Boeden_Publikation_20200701", "afu_schadstoffbelastete_boeden_pub", dbPub, "ch.so.afu.schadstoffbelastete_boeden", true)) 
datasets.add(new Dataset("SO_AFU_Stoerfallverordnung_Publikation_20220711", "afu_stoerfallverordnung_pub_v1", dbPub, "ch.so.afu.stoerfallverordnung")) 
datasets.add(new Dataset("SO_AfU_Wasserbewirtschaftung_Publikation_20220202", "afu_wasserbewirtschaftung_pub_v1", dbPub, "ch.so.afu.wasserbewirtschaftung", true))
datasets.add(new Dataset("SO_AGEM_Fila_Publikation_20190318", "agem_fila_pub", dbPub, "ch.so.agem.fila"))
datasets.add(new Dataset("SO_AGI_AV_GB_Administrative_Einteilungen_Publikation_20180822", "agi_av_gb_admin_einteilung_pub", dbPub, "ch.so.agi.av_gb_administrative_einteilungen", true))
datasets.add(new Dataset("IliVErrors", "agi_av_validierung_pub", dbPub, "ch.so.agi.av_validierung"))
datasets.add(new Dataset("SO_AGI_GB2AV_Controlling_20201002", "agi_gb2av_controlling_pub", dbPub, "ch.so.agi.gb2av_controlling"))
// Kann mit aktuellem Compiler nicht exportiert werden, weil in der DB alte, falsche Fremdmodelle (CHBase Administration) vorhanden sind.
// datasets.add(new Dataset("SO_AGI_Grundbuchplan_20190930", "agi_grundbuchplan_pub", dbPub, "ch.so.agi.grundbuchplan")) 
datasets.add(new Dataset("SO_AGI_Hoehenkurven_3D_Publikation_20210115", "agi_hoehenkurven_2014_ab_100m_pub_v1", dbPub, "ch.so.agi.hoehenkurven_2014_ab_100m")) 
datasets.add(new Dataset("SO_Hoheitsgrenzen_Publikation_20170626", "agi_hoheitsgrenzen_pub", dbPub, "ch.so.agi.hoheitsgrenzen", true))
datasets.add(new Dataset("SO_AGI_Inventar_Hoheitsgrenzen_Publikation_20191129", "agi_inventar_hoheitsgrenzen_pub", dbPub, "ch.so.agi.inventar_hoheitsgrenzen", true))

datasets.add(new Dataset("SO_AGI_Lidarprodukte_Publikation_20220420", "agi_lidarprodukte_pub_v1", dbPub, "ch.so.agi.lidarprodukte"))
// Kann mit aktuellem Compiler nicht exportiert werden, Schema muss neu angelegt werden.
// datasets.add(new Dataset("SO_AGI_MOpublic_20190424", "agi_mopublic_pub", dbPub, "ch.so.agi.mopublic")) 
datasets.add(new Dataset("SO_AGI_PLZ_Ortschaften_Publikation_20180406", "agi_plz_ortschaften_pub", dbPub, "ch.so.agi.plz_ortschaften")) 
datasets.add(new Dataset("SO_AGI_swissBOUNDARIES3D_Publikation_20171026", "agi_swissboundaries3d_pub", dbPub, "ch.so.agi.swissboundaries3d")) 
datasets.add(new Dataset("SO_AGS_Religionsgemeinschaften_Publikation_20220427", "ags_religionsgemeinschaften_pub_v1", dbPub, "ch.so.ags.religionsgemeinschaften", true)) 
// Fruchtfolgeflächen werden aus der Pub explizit im Pub-Gretljob exportiert und hochgeladen.
//datasets.add(new Dataset("SO_ALW_Fruchtfolgeflaechen_Publikation_20220110", "alw_fruchtfolgeflaechen_pub_v1", dbPub, "ch.so.alw.fruchtfolgeflaechen")) 
datasets.add(new Dataset("SO_ALW_Gewaesserraum_20210531", "alw_gewaesserraum_pub_v1", dbPub, "ch.so.alw.gewaesserraum")) 
datasets.add(new Dataset("SO_ALW_Landwirtschaft_Tierhaltung_Publikation_restricted_20211019", "alw_landwirtschaft_tierhaltung_pub_v1", dbPub, "ch.so.alw.landwirtschaft_tierhaltung_restricted")) 
datasets.add(new Dataset("SO_ALW_Landwirtschaft_Tierhaltung_Publikation_restricted_20211019", "alw_landwirtschaft_tierhaltung_pub_v1", dbPub, "ch.so.alw.landwirtschaft_tierhaltung", true, "SO_ALW_Landwirtschaft_Tierhaltung_Publikation_20211019")) 
datasets.add(new Dataset("SO_ALW_Strukturverbesserungen_Publikation_20190905", "alw_strukturverbesserungen_pub", dbPub, "ch.so.alw.strukturverbesserungen", true)) 
datasets.add(new Dataset("SO_ALW_Tiergesundheit_Massnahmen_20210426", "alw_tiergesundheit_massnahmen_pub", dbPub, "ch.so.alw.tiergesundheit_massnahmen", true)) 
datasets.add(new Dataset("SO_ALW_Landwirtschaftliche_Zonengrenzen_Publikation_20200630", "alw_zonengrenzen_pub", dbPub, "ch.so.alw.zonengrenzen")) 
datasets.add(new Dataset("SO_AMB_Notfalltreffpunkte_Publikation_20180822", "amb_notfalltreffpunkte_pub", dbPub, "ch.so.amb.notfalltreffpunkte", true)) 

datasets.add(new Dataset("SO_AMB_Sirenenplanung_20200831", "amb_sirenenplanung_pub_v1", dbPub, "ch.so.amb.sirenenplanung")) 
datasets.add(new Dataset("SO_AMB_Zivilschutz_Adressen_Export_20201013", "amb_zivilschutz_adressen_staging_pub", dbPub, "ch.so.amb.zivilschutz_adressen")) 
datasets.add(new Dataset("SO_Agglomerationsprogramme_Publikation_20200813", "arp_agglomerationsprogramme_pub", dbPub, "ch.so.arp.agglomerationsprogramme", true)) 
datasets.add(new Dataset("SO_ARP_Auswertungen_Nutzungsplanung_Publikation_20210126", "arp_auswertung_nutzungsplanung_pub_v1", dbPub, "ch.so.arp.auswertung_nutzungplanung")) 
datasets.add(new Dataset("SO_ARP_Bauzonengrenzen_20210120", "arp_bauzonengrenzen_pub", dbPub, "ch.so.arp.bauzonengrenzen", true)) 
// Kann mit aktuellem Compiler nicht exportiert werden, weil in der DB alte, falsche Fremdmodelle (CHBase Administration) vorhanden sind.
// datasets.add(new Dataset("SO_ARP_Fledermausfundorte_Publikation_20200806", "arp_fledermaus_pub", dbPub, "ch.so.arp.fledermausfundorte")) 
datasets.add(new Dataset("SO_ARP_Naturreservate_Publikation_20200609", "arp_naturreservate_pub", dbPub, "ch.so.arp.naturreservate")) 
datasets.add(new Dataset("SO_ARP_Naturschutzobjekte_Publikation_20210727", "arp_naturschutzobjekte_pub_v1", dbPub, "ch.so.arp.naturschutzobjekte", true)) 
datasets.add(new Dataset("SO_ARP_Nutzungsplanung_Publikation_20201005", "arp_nutzungsplanung_pub_v1", dbPub, "ch.so.arp.nutzungsplanung", true)) 
datasets.add(new Dataset("SO_ARP_Nutzungsvereinbarung_Publikation_20170223", "arp_nutzungsvereinbarung_pub", dbPub, "ch.so.arp.nutzungsvereinbarung")) 
// Datensatz muss zuerst neu publiziert werden mit ST_ReducePrecision. Das geht aber momentan nicht, weil der Umbau noch ein altes Schema referenziert.
// datasets.add(new Dataset("SO_ARP_Richtplan_Publikation_20220630", "arp_richtplan_pub_v1", dbPub, "ch.so.arp.richtplan", true)) 

datasets.add(new Dataset("SO_AVT_Groblaermkataster_20190709", "avt_groblaermkataster_pub", dbPub, "ch.so.avt.groblaermkataster", true)) 
datasets.add(new Dataset("SO_AVT_Kantonsstrassen_Publikation_20200707", "avt_kantonsstrassen_pub", dbPub, "ch.so.avt.kantonsstrassen", true)) 
datasets.add(new Dataset("SO_AVT_Kunstbauten_Publikation_20220207", "avt_kunstbauten_pub_v1", dbPub, "ch.so.avt.kunstbauten", true)) 
datasets.add(new Dataset("SO_AVT_Oeffentlicher_Verkehr_20210205", "avt_oeffentlicher_verkehr_pub", dbPub, "ch.so.avt.oeffentlicher_verkehr", true)) 
datasets.add(new Dataset("SO_AVT_Oev_Gueteklassen_20220120", "avt_oev_gueteklassen_pub_v1", dbPub, "ch.so.avt.oev_gueteklassen", true)) 
// Kann mit aktuellem Compiler nicht exportiert werden, weil in der DB alte, falsche Fremdmodelle (CHBase Administration) vorhanden sind.
// datasets.add(new Dataset("SO_AVT_Strassenlaerm_Publikation_20190802", "avt_strassenlaerm_pub", dbPub, "ch.so.avt.strassenlaerm", true)) 
datasets.add(new Dataset("SO_AVT_Verkehrszaehlstellen_Publikation_20190206", "avt_verkehrszaehlstellen_pub", dbPub, "ch.so.avt.verkehrszaehlstellen", true)) 
datasets.add(new Dataset("SO_AWA_Stromversorgungssicherheit_Publikation_20210629", "awa_stromversorgungssicherheit_pub", dbPub, "ch.so.awa.stromversorgungssicherheit", true)) 
datasets.add(new Dataset("SO_Forstreviere_Publikation_20170428", "awjf_forstreviere_pub", dbPub, "ch.so.awjf.forstreviere", true)) 
datasets.add(new Dataset("SO_AWJF_Gewaesser_Fischerei_Publikation_20220429", "awjf_gewaesser_fischerei_pub_v1", dbPub, "ch.so.awjf.gewaesser_fischerei", true)) 
datasets.add(new Dataset("SO_AWJF_Jagdreviere_Jagdbanngebiete_Publikation_202000804", "awjf_jagdreviere_jagdbanngebiete_pub_v1", dbPub, "ch.so.awjf.jagdreviere_jagdbanngebiete", true)) 
datasets.add(new Dataset("SO_AWJF_Naturgefahrenhinweiskarte_Publikation_20220125", "awjf_naturgefahrenhinweiskarte_pub_v1", dbPub, "ch.so.awjf.naturgefahrenhinweiskarte", true)) 
datasets.add(new Dataset("SO_AWJF_Programm_Biodiversitaet_Wald_Publikation_20220224", "awjf_programm_biodiversitaet_wald_pub_v1", dbPub, "ch.so.awjf.programm_biodiversitaet")) 

datasets.add(new Dataset("SO_AWJF_Schutzwald_Publikation_20220617", "awjf_schutzwald_pub_v1", dbPub, "ch.so.awjf.schutzwald")) 
datasets.add(new Dataset("SO_AWJF_Seltene_Baumarten_Publikation_20191015", "awjf_seltene_baeume_pub", dbPub, "ch.so.awjf.seltene_baeume", true)) 
datasets.add(new Dataset("SO_AWJF_Statische_Waldgrenzen_Publikation_20191119", "awjf_statische_waldgrenze_pub_v1", dbPub, "ch.so.awjf.statische_waldgrenzen", true)) 
datasets.add(new Dataset("SO_AWJF_Wald_Oberhoehenbonitaet_20211027", "awjf_wald_oberhoehenbonitaet_pub_v1", dbPub, "ch.so.awjf.wald_oberhoehenbonitaet", true)) 
datasets.add(new Dataset("SO_AWJF_Waldpflege_Erfassung_20210202", "awjf_waldpflege_kontrolle_pub", dbPub, "ch.so.awjf.waldpflege_kontrolle")) 
datasets.add(new Dataset("SO_AWJF_Waldstandorte_Publikation_20211027", "awjf_waldstandorte_pub_v1", dbPub, "ch.so.awjf.waldstandorte", true)) 
// Falsches, unsichtbares Zeichen in den Daten. XML ist nicht valide.
datasets.add(new Dataset("SO_AWJF_Waldwanderwege_202000804", "awjf_waldwanderwege_pub", dbPub, "ch.so.awjf.waldwanderwege", true)) 
datasets.add(new Dataset("SO_AWJF_Wegsanierungen_Publikation_20170629", "awjf_wegsanierungen_pub", dbPub, "ch.so.awjf.wegsanierungen")) 
datasets.add(new Dataset("SO_AWJF_Wildtierkorridore_20210831", "awjf_wildtierkorridore_pub_v1", dbPub, "ch.so.awjf.wildtierkorridore", true)) 
datasets.add(new Dataset("SO_KSTA_Landwert_20210202", "ksta_landwerte_pub", dbPub, "ch.so.ksta.landwerte"))
