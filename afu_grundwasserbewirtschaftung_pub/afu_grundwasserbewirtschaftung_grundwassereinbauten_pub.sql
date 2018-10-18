(SELECT 
    'weitere_einbauten' AS grundwassereinbauobjektart, 
    weitere_einbauten.bezeichnung AS objektname, 
    weitere_einbauten.vegas_id AS objektnummer, 
    weitere_einbauten.beschreibung AS technische_angabe, 
    weitere_einbauten.bemerkung AS bemerkung, 
    dokumente.dokumente AS dokumente, 
    wkb_geometry AS geometrie
FROM 
    (SELECT * FROM vegas.obj_objekt_v where objekttyp_id = 25 AND ARCHIVE = 0) weitere_einbauten
LEFT JOIN 
    (SELECT 
         array_agg(x.bezeichnung) AS dokumente, 
         y.vegas_id
     FROM 
         vegas.adm_dokument x, 
         vegas.adm_objekt_dokument y 
     WHERE 
         x.dokument_id = y.dokument_id
     GROUP BY 
         y.vegas_id
     ) dokumente ON weitere_einbauten.vegas_id = dokumente.vegas_id )
UNION ALL 
(SELECT 
    'versickerungsschacht' AS grundwassereinbauobjektart, 
    versickerungsschacht.bezeichnung AS objektname, 
    versickerungsschacht.vegas_id AS objektnummer, 
    versickerungsschacht.beschreibung AS technische_angabe, 
    versickerungsschacht.bemerkung AS bemerkung, 
    dokumente.dokumente AS dokumente, 
    wkb_geometry AS geometrie
FROM 
    (SELECT * FROM vegas.obj_objekt_v where (objekttyp_id = 18) AND (schachttyp = 2) AND ARCHIVE = 0) versickerungsschacht
LEFT JOIN 
    (SELECT 
         array_agg(x.bezeichnung) AS dokumente, 
         y.vegas_id
     FROM 
         vegas.adm_dokument x, 
         vegas.adm_objekt_dokument y 
     WHERE 
         x.dokument_id = y.dokument_id
     GROUP BY 
         y.vegas_id
     ) dokumente ON versickerungsschacht.vegas_id = dokumente.vegas_id )
 

-- HIER wUERDE NOCH DIE GRUNDWASERBEOBACHTUNG KOMMEN (WAS AUCH IMMER DAS IST...)
