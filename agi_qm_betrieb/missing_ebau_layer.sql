ATTACH ${connectionStringSimi} AS simidb (TYPE POSTGRES, READ_ONLY);

CREATE TEMP TABLE missingEbauLayer AS
WITH layer_list AS (
    SELECT UNNEST([
    'ch.so.agi.av.grundstuecke.rechtskraeftig.data', 
    'ch.so.agi.av.gebaeudeadressen.gebaeudeeingaenge.data',
    'ch.so.agi.av.grundbuchkreise.data',
    'ch.so.arp.nutzungsplanung.grundnutzung.data',
    'ch.so.alw.fruchtfolgeflaechen.data',
    'ch.so.afu.naturgefahren.synoptisches_gefahrengebiet.data',
    'ch.so.afu.altlasten.standorte.ebau.data_v2',
    'ch.so.afu.gewaesserschutz.zonen_areale.data_v2',
    'ch.so.ada.denkmalschutz.flaechenobjekt.data',
    'ch.so.ada.denkmalschutz.punktobjekt.data',
    'ch.so.ada.archaeologie.punktfundstellen.data',
    'ch.so.ada.archaeologie.flaechenfundstellen.data',
    'ch.so.arp.nutzungsplanung.erschliessungsplanung_linie.data',
    'ch.so.arp.nutzungsplanung.erschliessungsplanung_flaeche.data',
    'ch.so.arp.nutzungsplanung.ueberlagernd_punkt.data',
    'ch.so.arp.nutzungsplanung.ueberlagernd_linie.data',
    'ch.so.arp.nutzungsplanung.ueberlagernd_flaeche.data',
    'ch.so.agi.av.bodenbedeckung.data',
    'this.layer.must.appear'
    ]) AS layer
)
SELECT 
    l.layer AS layer_id
FROM 
    layer_list AS l
LEFT JOIN 
    simidb.simi.simiproduct_data_product AS p 
    ON l.layer = p.ident_part
WHERE 
    p.ident_part IS NULL;
;

COPY missingEbauLayer TO '/tmp/qmbetrieb/missing_ebau_layer.csv' (HEADER, DELIMITER ';');


