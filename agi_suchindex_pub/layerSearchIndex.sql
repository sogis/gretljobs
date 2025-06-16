SELECT
    trim('" ' FROM (string_to_array(trim('[]' FROM id), ','))[2]) AS identifier,
    display AS anzeige,
    REPLACE(REPLACE(dset_children, '"ident":','"dataproduct_id":'),'"subclass":','"type":') AS unter_ebenen, --TODO: CHANGE IN solr VIEW, NOT here
    facet AS layertyp,
    dset_info as hat_beschreibung,
    lower(search_1_stem) as suchbegriffe_p1,
    lower(search_2_stem) as suchbegriffe_p2,
    lower(search_3_stem) as suchbegriffe_p3
FROM simi.solr_layer_base_v
;
