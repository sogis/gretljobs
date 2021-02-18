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
def dbSogis = [dbUriSogis, dbUserSogis, dbPwdSogis]
def dbPub = [dbUriPub, dbUserPub, dbPwdPub]

class Dataset {
    String models
    String dbschema
    Connector database
    String datasetId
    boolean version3

    Dataset(String models, String dbschema, ArrayList database, String datasetId, boolean version3) {
        this.models = models
        this.dbschema = dbschema
        this.database = database
        this.datasetId = datasetId
        this.version3 = version3
    }

    Dataset(String models, String dbschema, ArrayList database, String datasetId) {
        this(models, dbschema, database, datasetId, false)
    }    
}

ext.datasets = []

// Edit-DB
datasets.add(new Dataset("SO_ADA_Denkmal_20191128", "ada_denkmalschutz", dbEdit, "ch.so.ada.denkmalschutz_edit"))
datasets.add(new Dataset("SO_AfU_Erdwaermesonden_20190204", "afu_erdwaermesonden", dbEdit, "ch.so.afu.erdwaermesonden_edit", true))
datasets.add(new Dataset("SO_AFU_Nagra_Bohrtiefen_20190927", "afu_erdwaermesonden_nagra", dbEdit, "ch.so.afu.erdwaermesonden_nagra_edit", true))
datasets.add(new Dataset("SO_AfU_Erdwaermesonden_20200421", "afu_erdwaermesonden_v2", dbEdit, "ch.so.afu.erdwaermesonden_v2_edit"))
datasets.add(new Dataset("SO_AfU_Gefahrenkartierung_20181129", "afu_gefahrenkartierung", dbEdit, "ch.so.afu.gefahrenkartierung_edit", true))
datasets.add(new Dataset("Hazard_Mapping_LV95_V1_2", "afu_gefahrenkartierung_mgdm", dbEdit, "ch.so.afu.gefahrenkartierung_mgdm", true))
datasets.add(new Dataset("SO_AFU_Geotope_20200312", "afu_geotope", dbEdit, "ch.so.afu.geotope_edit"))
datasets.add(new Dataset("PlanerischerGewaesserschutz_LV95_V1_1", "afu_gewaesserschutz", dbEdit, "ch.so.afu.gewaesserschutz_edit"))
datasets.add(new Dataset("SO_AFU_Igel_202000429", "afu_igel", dbEdit, "ch.so.afu.igel_edit"))
datasets.add(new Dataset("SO_AFU_Verzeichnis_schadstoffbelastete_Boeden_20200622", "afu_schadstoffbelastete_boeden", dbEdit, "ch.so.afu.schadstoffbelastete_boeden_edit"))
datasets.add(new Dataset("SO_AfU_Luftreinhaltung_20191105", "afu_uplus_luft", dbEdit, "ch.so.afu.uplus_luft_edit"))
datasets.add(new Dataset("SO_AfU_Tankanlage_20191105", "afu_uplus_tank", dbEdit, "ch.so.afu.uplus_tank_edit"))
datasets.add(new Dataset("SO_AGEM_Fila_20190318", "agem_fila", dbEdit, "ch.so.agem.fila_edit"))
datasets.add(new Dataset("SO_AGI_AV_GB_Administrative_Einteilungen_20180613", "agi_av_gb_admin_einteilung", dbEdit, "ch.so.agi.av_gb_admin_einteilung_edit"))
datasets.add(new Dataset("SO_AGI_MOCheckSO_20200715", "agi_av_mocheckso", dbEdit, "ch.so.agi.av_mocheckso_edit"))
datasets.add(new Dataset("SO_AGI_GB2AV_Controlling_20201002", "agi_gb2av_controlling", dbEdit, "ch.so.agi.gb2av_controlling_edit"))
datasets.add(new Dataset("SO_AGI_Inventar_Hoheitsgrenzen_20191129", "agi_inventar_hoheitsgrenzen", dbEdit, "ch.so.agi.inventar_hoheitsgrenzen_edit"))
datasets.add(new Dataset("SO_ALW_Infoflora_20190912", "alw_infoflora", dbEdit, "ch.so.alw.infoflora_edit"))
datasets.add(new Dataset("SO_Agglomerationsprogramme_20200618", "arp_agglomerationsprogramme", dbEdit, "ch.so.arp.agglomerationsprogramme_edit"))
datasets.add(new Dataset("SO_ARP_Baugis_20190612", "arp_baugis", dbEdit, "ch.so.arp.baugis_edit", true))
datasets.add(new Dataset("SO_ARP_Fledermausfundorte_20200728", "arp_fledermaus", dbEdit, "ch.so.arp.fledermausstandorte_edit"))
datasets.add(new Dataset("SO_ARP_Mehrjahresprogramm_20200228", "arp_mehrjahresprogramm", dbEdit, "ch.so.arp.mehrjahresprogramm_edit"))
datasets.add(new Dataset("SO_ARP_Naturreservate_20200609", "arp_naturreservate", dbEdit, "ch.so.arp.naturreservate_edit"))
datasets.add(new Dataset("SO_ARP_Nutzungsvereinbarung_20170512", "arp_nutzungsvereinbarung", dbEdit, "ch.so.arp.nutzungsvereinbarung_edit"))
datasets.add(new Dataset("SO_ARP_Richtplan_20210210", "arp_richtplan", dbEdit, "ch.so.arp.richtplan_edit"))
datasets.add(new Dataset("SO_AVT_OevKov_20181107", "avt_oevkov_2018", dbEdit, "ch.so.avt.oevkov2018_edit", true)) 
datasets.add(new Dataset("SO_AVT_OevKov_20190805", "avt_oevkov_2019", dbEdit, "ch.so.avt.oevkov2019_edit", true)) 
datasets.add(new Dataset("SO_AVT_OevKov_20200420", "avt_oevkov_2020", dbEdit, "ch.so.avt.oevkov2020_edit")) 
datasets.add(new Dataset("SO_AVT_Verkehrszaehlstellen_20190206", "avt_verkehrszaehlstellen", dbEdit, "ch.so.avt.verkehrszaehlstellen_edit")) 
datasets.add(new Dataset("SO_AWJF_Foerderprogramm_Biodiversitaet_20200526", "awjf_foerderprogramm_biodiversitaet", dbEdit, "ch.so.awjf.foerderprogramm_biodiversitaet_edit")) 
datasets.add(new Dataset("SO_Forstreviere_20170512", "awjf_forstreviere", dbEdit, "ch.so.awjf.forstreviere_edit")) 
datasets.add(new Dataset("SO_AWJF_Gesuchsteller_20201012", "awjf_gesuchsteller", dbEdit, "ch.so.awjf.gesuchsteller_edit")) 
datasets.add(new Dataset("SO_AWJF_Jagdreviere_Jagdbanngebiete_202000804", "awjf_jagdreviere_jagdbanngebiete", dbEdit, "ch.so.awjf.jagdreviere_jagdbanngebiete_edit")) 
datasets.add(new Dataset("SO_AWJF_Seltene_Baumarten_20190211", "awjf_seltene_baeume", dbEdit, "ch.so.awjf.seltene_baeume_edit", true)) 
datasets.add(new Dataset("SO_AWJF_Statische_Waldgrenzen_20191119", "awjf_statische_waldgrenze", dbEdit, "ch.so.awjf.statische_waldgrenze_edit")) 
datasets.add(new Dataset("SO_AWJF_Waldpflege_Erfassung_20200127", "awjf_waldpflege_erfassung", dbEdit, "ch.so.awjf.waldpflege_erfassung_edit")) 
datasets.add(new Dataset("SO_AWJF_Waldpflege_Kontrolle_20200127", "awjf_waldpflege_kontrolle", dbEdit, "ch.so.awjf.waldpflege_kontrolle_edit")) 
datasets.add(new Dataset("SO_AWJF_Waldwanderwege_202000804", "awjf_waldwanderwege", dbEdit, "ch.so.awjf.waldwanderwege_edit")) 
datasets.add(new Dataset("SO_SGV_Erschliessung_ausserhalb_Bauzone_20190611", "sgv_erschliessungen", dbEdit, "ch.so.sgv.erschliessungen_edit", true)) 
/*
*/

// SOGIS-DB
// Die paar Modelle scheinen nicht auf die Schnelle exportierbar zu sein. Macht uns zu einem späteren Zeitpunkt vielleicht noch Bauchweh.

// Pub-DB
datasets.add(new Dataset("SO_ADA_Denkmal_Pub_20200527", "ada_denkmalschutz_pub", dbPub, "ch.so.ada.denkmalschutz")) 
datasets.add(new Dataset("SO_AfU_BauGK_CCCCache_20180507", "afu_baugk_ccccache", dbPub, "ch.so.afu.baugk_ccccache", true)) 
//datasets.add(new Dataset("SO_AFU_Bodenprofilstandorte_Publikation_20200713", "afu_bodendaten_nabodat_pub", dbPub, "ch.so.afu.bodendaten_nabodat")) // Falsches Json -> Ticket gemacht
datasets.add(new Dataset("SO_AFU_Bodendaten_schadstoffuntersuchung_Publikation_20200928", "afu_bodendaten_schadstoffuntersuchung_pub", dbPub, "ch.so.afu.bodendaten_schadstoffuntersuchung")) 
datasets.add(new Dataset("SO_AFU_Ekat_Publikation_20190222", "afu_ekat2015_pub", dbPub, "ch.so.afu.ekat2015", true)) 
datasets.add(new Dataset("SO_AFU_Nagra_Bohrtiefen_20190927", "afu_erdwaermesonden_nagra_pub", dbPub, "ch.so.afu.erdwaermesonden_nagra", true)) 
datasets.add(new Dataset("SO_AfU_Erdwaermesonden_Publikation_20200113", "afu_erdwaermesonden_pub", dbPub, "ch.so.afu.erdwaermesonden")) 
datasets.add(new Dataset("SO_AfU_Gefahrenkartierung_20181129", "afu_gefahrenkartierung_pub", dbPub, "ch.so.afu.gefahrenkartierung", true)) 
datasets.add(new Dataset("SO_AFU_Geotope_Publikation_20200623", "afu_geotope_pub", dbPub, "ch.so.afu.geotope")) 
//datasets.add(new Dataset("SO_AfU_Gewaesserschutz_Publikation_20200115", "afu_gewaesserschutz_pub", dbPub, "ch.so.afu.gewaesserschutz")) // Falsches Json -> Ticket gemacht
datasets.add(new Dataset("SO_AFU_Igel_Publikation_20200429", "afu_igel_pub", dbPub, "ch.so.afu.igel")) 
//datasets.add(new Dataset("SO_AFU_Verzeichnis_schadstoffbelastete_Boeden_Publikation_20200701", "afu_schadstoffbelastete_boeden_pub", dbPub, "ch.so.afu.schadstoffbelastete_boeden")) // Falsches Json -> Ticket gemacht
datasets.add(new Dataset("SO_AGEM_Fila_Publikation_20190318", "agem_fila_pub", dbPub, "ch.so.agem.fila"))
datasets.add(new Dataset("SO_AGI_AV_GB_Administrative_Einteilungen_Publikation_20180822", "agi_av_gb_admin_einteilung_pub", dbPub, "ch.so.agi.av_gb_administrative_einteilungen"))
datasets.add(new Dataset("IliVErrors", "agi_av_validierung_pub", dbPub, "ch.so.agi.av_validierung"))
datasets.add(new Dataset("SO_AGI_GB2AV_Controlling_20201002", "agi_gb2av_controlling_pub", dbPub, "ch.so.agi.gb2av_controlling"))
datasets.add(new Dataset("SO_AGI_Grundbuchplan_20190930", "agi_grundbuchplan_pub", dbPub, "ch.so.agi.grundbuchplan")) 
datasets.add(new Dataset("SO_Hoheitsgrenzen_Publikation_20170626", "agi_hoheitsgrenzen_pub", dbPub, "ch.so.agi.hoheitsgrenzen"))
datasets.add(new Dataset("SO_AGI_Inventar_Hoheitsgrenzen_Publikation_20191129", "agi_inventar_hoheitsgrenzen_pub", dbPub, "ch.so.agi.inventar_hoheitsgrenzen"))
datasets.add(new Dataset("SO_AGI_Lidarprodukte_Publikation_20180202", "agi_lidar_pub", dbPub, "ch.so.agi.lidar_idx"))
datasets.add(new Dataset("SO_AGI_MOpublic_20190424", "agi_mopublic_pub", dbPub, "ch.so.agi.mopublic")) 
datasets.add(new Dataset("SO_AGI_PLZ_Ortschaften_Publikation_20180406", "agi_plz_ortschaften_pub", dbPub, "ch.so.agi.plz_ortschaften")) 
datasets.add(new Dataset("SO_AGI_swissBOUNDARIES3D_Publikation_20171026", "agi_swissboundaries3d_pub", dbPub, "ch.so.agi.swissboundaries3d")) 
datasets.add(new Dataset("SO_ALW_Infoflora_Publikation_20191028", "alw_infoflora_pub", dbPub, "ch.so.alw.infoflora"))
datasets.add(new Dataset("SO_AMB_Notfalltreffpunkte_Publikation_20180822", "amb_notfalltreffpunkte_pub", dbPub, "ch.so.amb_notfalltreffpunkte")) 
datasets.add(new Dataset("SO_AMB_Zivilschutz_Adressen_Export_20201013", "amb_zivilschutz_adressen_staging_pub", dbPub, "ch.so.amb.zivilschutz_adressen")) 
datasets.add(new Dataset("SO_Agglomerationsprogramme_Publikation_20200813", "arp_agglomerationsprogramme_pub", dbPub, "ch.so.arp.agglomerationsprogramme")) 
datasets.add(new Dataset("SO_Agglomerationsprogramme_Publikation_20180620", "arp_aggloprogramme_pub", dbPub, "ch.so.arp.aggloprogramme")) 
datasets.add(new Dataset("SO_ARP_Fledermausfundorte_Publikation_20200806", "arp_fledermaus_pub", dbPub, "ch.so.arp.fledermausfundorte")) 
datasets.add(new Dataset("SO_ARP_Naturreservate_Publikation_20200609", "arp_naturreservate_pub", dbPub, "ch.so.arp.naturreservate")) 
datasets.add(new Dataset("SO_Nutzungsplanung_Publikation_20190909", "arp_npl_pub", dbPub, "ch.so.arp.nutzungsplanung")) 
datasets.add(new Dataset("SO_ARP_Nutzungsvereinbarung_Publikation_20170223", "arp_nutzungsvereinbarung_pub", dbPub, "ch.so.arp.nutzungsvereinbarung", true)) 
datasets.add(new Dataset("SO_ARP_Richtplan_Publikation_20210210", "arp_richtplan_pub", dbPub, "ch.so.arp.richtplan", true)) 
datasets.add(new Dataset("SO_AVT_Groblaermkataster_20190709", "avt_groblaermkataster_pub", dbPub, "ch.so.avt.groblaermkataster")) 
datasets.add(new Dataset("SO_AVT_Kantonsstrassen_Publikation_20200707", "avt_kantonsstrassen_pub", dbPub, "ch.so.avt.kantonsstrassen")) 
datasets.add(new Dataset("SO_AVT_Strassenlaerm_Publikation_20190802", "avt_strassenlaerm_pub", dbPub, "ch.so.avt.strassenlaerm")) 
datasets.add(new Dataset("SO_AVT_Verkehrszaehlstellen_Publikation_20190206", "avt_verkehrszaehlstellen_pub", dbPub, "ch.so.avt.verkehrszaehlstellen")) 
datasets.add(new Dataset("SO_AWJF_Foerderprogramm_Biodiversitaet_Publikation_20200330", "awjf_foerderprogramm_biodiversitaet_pub", dbPub, "ch.so.awjf.foerderprogramm_biodiversitaet")) 
datasets.add(new Dataset("SO_Forstreviere_Publikation_20170428", "awjf_forstreviere_pub", dbPub, "ch.so.awjf.forstreviere")) 
datasets.add(new Dataset("SO_AWJF_Jagdreviere_Jagdbanngebiete_Publikation_202000804", "awjf_jagdreviere_jagdbanngebiete_pub", dbPub, "ch.so.awjf.jagdreviere_jagdbanngebiete")) 
datasets.add(new Dataset("SO_AWJF_Seltene_Baumarten_Publikation_20191015", "awjf_seltene_baeume_pub", dbPub, "ch.so.awjf.seltene_baeume", true)) 
datasets.add(new Dataset("SO_AWJF_Statische_Waldgrenzen_Publikation_20191119", "awjf_statische_waldgrenze_pub", dbPub, "ch.so.awjf.statische_waldgrenzen")) 
datasets.add(new Dataset("SO_AWJF_Waldpflege_Erfassung_20200127", "awjf_waldpflege_kontrolle_pub", dbPub, "ch.so.awjf.waldpflege_kontrolle")) 
datasets.add(new Dataset("SO_AWJF_Waldwanderwege_202000804", "awjf_waldwanderwege_pub", dbPub, "ch.so.awjf.waldwanderwege")) 
datasets.add(new Dataset("SO_AWJF_Wegsanierungen_Publikation_20170629", "awjf_wegsanierungen_pub", dbPub, "ch.so.awjf.wegsanierungen")) 
/*
*/



