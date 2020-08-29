class Metadata {
    String datasetId
    String epsgCode
    String resolutionScope
    String publishingDate
    String lastEditingDate
    String title
    String shortDiscription
    String keywords
    String servicer
    String technicalContact
    String furtherInformation
    String furtherMetadata
    String knownWMS
    List<String> files 
}


ext.metadata = [:]

metadata["ch.so.agi.av_gb_administrative_einteilungen"] = 
    new Metadata ( 
        datasetId: "ch.so.agi.av_gb_administrative_einteilungen",
        epsgCode: "2056",
        resolutionScope: "500",
        publishingDate: "2020-08-29",
        lastEditingDate: "2020-08-29",
        title: "Administrative Einteilungen der amtlichen Vermessung und des Grundbuchs.",
        shortDiscription: "Administrative Einteilungen der amtlichen Vermessung (Nummerierungsbereiche, Adressen der Nachführungsgeometer, ...) und des Grundbuchs (Grundbuchkreise, Adressen der Grundbuchämter, ...).",
        keywords: "Amtliche Vermessung,Grundbuch,Grundbuchamt,Nachführungsgeometer,Geometer,AGI,AS",
        servicer: "https://agi.so.ch",
        technicalContact: "mailto:agi@bd.so.ch",
        furtherInformation: "http://geo.so.ch/models/AGI/SO_AGI_AV_GB_Administrative_Einteilungen_Publikation_20180822.uml",
        furtherMetadata: "http://www.geolion.zh.ch/geodatensatz/1484",
        knownWMS: "https://geo.so.ch/ows/somap?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetMap&FORMAT=image%2Fpng&TRANSPARENT=true&LAYERS=ch.so.agi.av.fixpunkte&STYLES=&SRS=EPSG%3A2056&CRS=EPSG%3A2056&TILED=false&DPI=96&OPACITIES=255&t=633&WIDTH=1544&HEIGHT=907&BBOX=2576618.3333333335%2C1214252.2916666667%2C2658321.6666666665%2C1262247.7083333333",
        files: ["xtf","gpkg","shp"]
    )

metadata["ch.so.arp.naturreservate"] =
    new Metadata ( 
        datasetId: "ch.so.arp.naturreservate",
        epsgCode: "2056",
        resolutionScope: "500",
        publishingDate: "2020-08-29",
        lastEditingDate: "2020-08-29",
        title: "Kantonale Naturreservate sind durch den Regierungsrat oder einen Gemeinderat unter Schutz gestellte Gebiete.",
        shortDiscription: "Kantonale Naturreservate sind durch den Regierungsrat oder einen Gemeinderat unter Schutz gestellte Gebiete. (Schutzverfügung oder Nutzungsplan). Sie haben die Erhaltung und Aufwertung von Lebensräumen (Biotopen) für Lebensgemeinschaften besonders schützenswerter Tiere, Pflanzen und Pilze und die Bewahrung bedeutender Landschaftsformen, zum Beispiel Schluchten, zum Ziel.",
        keywords: "Naturreservat,Schutzverfügung,Nutzungsplan,Biotop,schützenswert,ARP",
        servicer: "https://agi.so.ch",
        technicalContact: "mailto:agi@bd.so.ch",
        furtherInformation: "http://geo.so.ch/models/ARP/SO_ARP_Naturreservate_Publikation_20200609.uml",
        furtherMetadata: "http://www.geolion.zh.ch/geodatensatz/1484",
        knownWMS: "https://geo.so.ch/ows/somap?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetMap&FORMAT=image%2Fpng&TRANSPARENT=true&LAYERS=ch.so.arp.naturreservate.teilgebiete%2Cch.so.arp.naturreservate.reservate&STYLES=&SRS=EPSG%3A2056&CRS=EPSG%3A2056&TILED=false&DPI=96&OPACITIES=255%2C255&t=292&WIDTH=1544&HEIGHT=907&BBOX=2576618.3333333335%2C1214252.2916666667%2C2658321",
        files: ["xtf","gpkg","shp"]
    )

metadata["ch.so.awjf.forstreviere"] =
    new Metadata ( 
        datasetId: "ch.so.awjf.forstreviere",
        epsgCode: "2056",
        resolutionScope: "500",
        publishingDate: "2020-08-29",
        lastEditingDate: "2020-08-29",
        title: "Kantonale Forstreviere und Forstkreise.",
        shortDiscription: "Die Forstreviere bestehen aus Waldungen einer oder mehrerer politischen Gemeinden. Die Frostkreise bilden den kantonalen Forstdienst ab.",
        keywords: "Naturreservat,Schutzverfügung,Nutzungsplan,Biotop,schützenswert,ARP",
        servicer: "https://agi.so.ch",
        technicalContact: "mailto:agi@bd.so.ch",
        furtherInformation: "http://geo.so.ch/models/AWJF/SO_Forstreviere_Publikation_20170428.uml",
        furtherMetadata: "http://www.geolion.zh.ch/geodatensatz/1484",
        knownWMS: "https://geo.so.ch/ows/somap?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetMap&FORMAT=image%2Fpng&TRANSPARENT=true&LAYERS=ch.so.arp.naturreservate.teilgebiete%2Cch.so.arp.naturreservate.reservate&STYLES=&SRS=EPSG%3A2056&CRS=EPSG%3A2056&TILED=false&DPI=96&OPACITIES=255%2C255&t=292&WIDTH=1544&HEIGHT=907&BBOX=2576618.3333333335%2C1214252.2916666667%2C2658321",
        files: ["xtf","gpkg","shp"]
    )

metadata["ch.so.alw.infoflora"] =
    new Metadata ( 
        datasetId: "ch.so.alw.infoflora",
        epsgCode: "2056",
        resolutionScope: "500",
        publishingDate: "2020-08-29",
        lastEditingDate: "2020-08-29",
        title: "Invasive Neophyten.",
        shortDiscription: "In Infoflora (www.infoflora.ch) erfassten Bestände von invasiven Neophyten, welche prioritär zu bekämpfen sind. Und weitere Arten.",
        keywords: "Naturreservat,Schutzverfügung,Nutzungsplan,Biotop,schützenswert,ARP",
        servicer: "https://agi.so.ch",
        technicalContact: "mailto:agi@bd.so.ch",
        furtherInformation: "http://geo.so.ch/models/ALW/SO_ALW_Infoflora_Publikation_20191028.ili",
        furtherMetadata: "http://www.geolion.zh.ch/geodatensatz/1484",
        knownWMS: "https://geo.so.ch/ows/somap?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetMap&FORMAT=image%2Fpng&TRANSPARENT=true&LAYERS=ch.so.alw.neophyten_infoflora.weitere_wichtige_arten%2Cch.so.alw.neophyten_infoflora.prioritaere_arten&STYLES=&SRS=EPSG%3A2056&CRS=EPSG%3A2056&TILED=false&DPI=96&OPACITIES=255%2C255&t=411&WIDTH=1544&HEIGHT=907&BBOX=2576618.3333333335%2C1214252.2916666667%2C2658321.6666666665%2C1262247.7083333333",
        files: ["xtf","gpkg","shp"]
    )