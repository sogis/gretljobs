(SELECT 
        'Niederschlagsmessstation' AS hydrometrieobjekt,
        oberflaechenhydrometrie.betreiber AS besitzer, 
        'Niederschlagsmessstation' AS objekttyp_anzeige, 
        oberflaechenhydrometrie.bezeichnung AS objektname, 
        oberflaechenhydrometrie.mobj_id AS objektnummer,
        oberflaechenhydrometrie.beschreibung AS technische_angabe,
        oberflaechenhydrometrie.bemerkung AS bemerkung,
        array_to_json(dokumente.dokumente) AS dokumente, 
        wkb_geometry AS geometrie
    FROM 
        (SELECT * FROM vegas.obj_messstation WHERE objekttyp_id = 22 AND gewaesserart = 6 AND "archive" = 0) oberflaechenhydrometrie
    LEFT JOIN 
        (SELECT 
             array_agg('https://geo.so.ch/docs/ch.so.afu.grundwasserbewirtschaftung/'||y.vegas_id||'_'||x.dokument_id||'.'||x.dateiendung) AS dokumente, 
             y.vegas_id
         FROM 
             vegas.adm_dokument x, 
             vegas.adm_objekt_dokument y 
         WHERE 
             x.dokument_id = y.dokument_id
         GROUP BY 
             y.vegas_id
     ) dokumente ON oberflaechenhydrometrie.vegas_id = dokumente.vegas_id 
 )
UNION ALL 
(SELECT 
        'Oberflaechengewaessermessstation' AS hydrometrieobjekt,
        oberflaechenhydrometrie.betreiber AS besitzer,
        'Oberflächengewässer-Messstelle' AS objekttyp_anzeige, 
        oberflaechenhydrometrie.bezeichnung AS objektname, 
        oberflaechenhydrometrie.mobj_id AS objektnummer,
        oberflaechenhydrometrie.beschreibung AS technische_angabe,
        oberflaechenhydrometrie.bemerkung AS bemerkung,
        array_to_json(dokumente.dokumente) AS dokumente, 
        wkb_geometry AS geometrie
    FROM 
        (SELECT * FROM vegas.obj_messstation WHERE objekttyp_id = 22 AND gewaesserart IN (1,2,3,4) AND limnigraf = 'f' AND "archive" = 0) oberflaechenhydrometrie
    LEFT JOIN 
        (SELECT 
             array_agg('https://geo.so.ch/docs/ch.so.afu.grundwasserbewirtschaftung/'||y.vegas_id||'_'||x.dokument_id||'.'||x.dateiendung) AS dokumente, 
             y.vegas_id
         FROM 
             vegas.adm_dokument x, 
             vegas.adm_objekt_dokument y 
         WHERE 
             x.dokument_id = y.dokument_id
         GROUP BY 
             y.vegas_id
    ) dokumente ON oberflaechenhydrometrie.vegas_id = dokumente.vegas_id 
)
;
