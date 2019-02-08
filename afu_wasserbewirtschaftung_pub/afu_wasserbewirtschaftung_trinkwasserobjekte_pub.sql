(SELECT 
    'Kontrollschacht' AS trinkwasserobjektart,
    kontrollschacht.bezeichnung AS objektname, 
    kontrollschacht.vegas_id AS objektnummer,
    kontrollschacht.beschreibung AS technische_angabe,  
    kontrollschacht.bemerkung AS bemerkung,
    array_to_json(dokumente.dokumente) AS dokumente, 
    kontrollschacht.wkb_geometry AS geometrie
FROM 
    vegas.obj_kontrollschacht kontrollschacht
LEFT JOIN 
    (SELECT 
         array_agg('https://geo.so.ch/docs/ch.so.afu.grundwasserbewirtschaftung/'||y.vegas_id||'_'||x.dokument_id||'.'||x.dateiendung) AS dokumente, 
         y.vegas_id
     FROM 
         vegas.adm_dokument x, 
         vegas.adm_objekt_dokument y 
     WHERE x.dokument_id = y.dokument_id
     GROUP BY y.vegas_id) dokumente ON kontrollschacht.vegas_id = dokumente.vegas_id) 
UNION ALL 
(SELECT 
    'Sammelbrunnenstube' AS trinkwasserobjektart,
    sammelbrunnenstube.bezeichnung AS objektname, 
    sammelbrunnenstube.vegas_id AS objektnummer, 
    sammelbrunnenstube.beschreibung AS technische_angabe,
    sammelbrunnenstube.bemerkung AS bemerkung, 
    array_to_json(dokumente.dokumente) AS dokumente,
    sammelbrunnenstube.wkb_geometry AS geometrie
FROM 
    vegas.obj_sammelbrunnstube sammelbrunnenstube
LEFT JOIN 
    (SELECT 
         array_agg('https://geo.so.ch/docs/ch.so.afu.grundwasserbewirtschaftung/'||y.vegas_id||'_'||x.dokument_id||'.'||x.dateiendung) AS dokumente, 
         y.vegas_id
     FROM 
         vegas.adm_dokument x, 
         vegas.adm_objekt_dokument y 
     WHERE x.dokument_id = y.dokument_id
     GROUP BY y.vegas_id) dokumente ON sammelbrunnenstube.vegas_id = dokumente.vegas_id) 
UNION ALL 
(SELECT 
    'Quellwasserbehaelter' AS trinkwasserobjektart,
    quellwasserbehaelter.bezeichnung AS objektname, 
    quellwasserbehaelter.vegas_id AS objektnummer, 
    quellwasserbehaelter.beschreibung AS technische_angabe,
    quellwasserbehaelter.bemerkung AS bemerkung, 
    array_to_json(dokumente.dokumente) AS dokumente, 
    quellwasserbehaelter.wkb_geometry AS geometrie
FROM 
    vegas.obj_quellwasserbehaelter quellwasserbehaelter
LEFT JOIN 
    (SELECT 
         array_agg('https://geo.so.ch/docs/ch.so.afu.grundwasserbewirtschaftung/'||y.vegas_id||'_'||x.dokument_id||'.'||x.dateiendung) AS dokumente, 
         y.vegas_id
     FROM 
         vegas.adm_dokument x, 
         vegas.adm_objekt_dokument y 
     WHERE x.dokument_id = y.dokument_id
     GROUP BY y.vegas_id) dokumente ON Quellwasserbehaelter.vegas_id = dokumente.vegas_id) 
UNION ALL
(SELECT 
    'Netzmessstelle' AS trinkwasserobjektart,
    netzmessstelle.bezeichnung AS objektname, 
    netzmessstelle.vegas_id AS objektnummer, 
    netzmessstelle.beschreibung AS technische_angabe,
    netzmessstelle.bemerkung AS bemerkung, 
    array_to_json(dokumente.dokumente) AS dokumente, 
    netzmessstelle.wkb_geometry AS geometrie
FROM 
    vegas.obj_netzmessstelle netzmessstelle
LEFT JOIN 
    (SELECT 
         array_agg('https://geo.so.ch/docs/ch.so.afu.grundwasserbewirtschaftung/'||y.vegas_id||'_'||x.dokument_id||'.'||x.dateiendung) AS dokumente, 
         y.vegas_id
     FROM 
         vegas.adm_dokument x, 
         vegas.adm_objekt_dokument y 
     WHERE x.dokument_id = y.dokument_id
     GROUP BY y.vegas_id) dokumente ON netzmessstelle.vegas_id = dokumente.vegas_id) 
UNION ALL 
(SELECT 
    'Pumpwerk' AS trinkwasserobjektart,
    pumpwerk.bezeichnung AS objektname, 
    pumpwerk.vegas_id AS objektnummer, 
    pumpwerk.beschreibung AS technische_angabe,
    pumpwerk.bemerkung AS bemerkung, 
    array_to_json(dokumente.dokumente) AS dokumente, 
    pumpwerk.wkb_geometry AS geometrie
FROM 
    vegas.obj_pumpwerk pumpwerk
LEFT JOIN 
    (SELECT 
         array_agg('https://geo.so.ch/docs/ch.so.afu.grundwasserbewirtschaftung/'||y.vegas_id||'_'||x.dokument_id||'.'||x.dateiendung) AS dokumente, 
         y.vegas_id
     FROM 
         vegas.adm_dokument x, 
         vegas.adm_objekt_dokument y 
     WHERE x.dokument_id = y.dokument_id
     GROUP BY y.vegas_id) dokumente ON pumpwerk.vegas_id = dokumente.vegas_id)
UNION ALL 
(SELECT 
    'Reservoir' AS trinkwasserobjektart,
    reservoir.bezeichnung AS objektname, 
    reservoir.vegas_id AS objektnummer, 
    reservoir.beschreibung AS technische_angabe,
    reservoir.bemerkung AS bemerkung, 
    array_to_json(dokumente.dokumente) AS dokumente, 
    reservoir.wkb_geometry AS geometrie
FROM 
    vegas.obj_reservoir reservoir
LEFT JOIN 
    (SELECT 
         array_agg('https://geo.so.ch/docs/ch.so.afu.grundwasserbewirtschaftung/'||y.vegas_id||'_'||x.dokument_id||'.'||x.dateiendung) AS dokumente, 
         y.vegas_id
     FROM 
         vegas.adm_dokument x, 
         vegas.adm_objekt_dokument y 
     WHERE x.dokument_id = y.dokument_id
     GROUP BY y.vegas_id) dokumente ON reservoir.vegas_id = dokumente.vegas_id)
