(SELECT 
    'weitere_einbauten' AS objektart, 
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
    'versickerungsschacht' AS objektart, 
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
UNION ALL 
    (SELECT 
        'piezometer.Bohrung' AS objektart, 
        bohrung.bezeichnung AS objektname, 
        bohrung.vegas_id AS objektnummer,
        bohrung.beschreibung AS technische_angabe,
        bohrung.bemerkung AS bemerkung,
        dokumente.dokumente AS dokumente, 
        wkb_geometry AS geometrie
    FROM 
        (SELECT * FROM vegas.obj_bohrung WHERE piezometer IS TRUE AND "archive" = 0) bohrung 
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
         ) dokumente ON bohrung.vegas_id = dokumente.vegas_id )
UNION ALL 
    (SELECT 
        'piezometer.gerammt' AS objektart, 
        gerammt.bezeichnung AS objektname, 
        gerammt.vegas_id AS objektnummer,
        gerammt.beschreibung AS technische_angabe,
        gerammt.bemerkung AS bemerkung,
        dokumente.dokumente AS dokumente, 
        wkb_geometry AS geometrie
    FROM 
        (SELECT * FROM vegas.obj_objekt_v WHERE objekttyp_id = 35 AND "archive" = 0) gerammt
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
         ) dokumente ON gerammt.vegas_id = dokumente.vegas_id )
UNION ALL 
    (SELECT 
        'sondierung.Bohrung' AS objektart, 
        sondierung.bezeichnung AS objektname, 
        sondierung.vegas_id AS objektnummer,
        sondierung.beschreibung AS technische_angabe,
        sondierung.bemerkung AS bemerkung,
        dokumente.dokumente AS dokumente, 
        wkb_geometry AS geometrie
    FROM 
        (SELECT * FROM vegas.obj_bohrung WHERE piezometer IS FALSE AND "archive" = 0) sondierung 
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
         ) dokumente ON sondierung.vegas_id = dokumente.vegas_id )
UNION ALL 
    (SELECT 
        'sondierung.Baggerschlitz' AS objektart, 
        baggerschlitz.bezeichnung AS objektname, 
        baggerschlitz.vegas_id AS objektnummer,
        baggerschlitz.beschreibung AS technische_angabe,
        baggerschlitz.bemerkung AS bemerkung,
        dokumente.dokumente AS dokumente, 
        wkb_geometry AS geometrie
    FROM 
        (SELECT * FROM vegas.obj_objekt_v WHERE objekttyp_id = 21 AND "archive" = 0) baggerschlitz
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
         ) dokumente ON baggerschlitz.vegas_id = dokumente.vegas_id )
UNION ALL 
    (SELECT 
        'limnigraf' AS objektart, 
        limnigraf.bezeichnung AS objektname, 
        limnigraf.vegas_id AS objektnummer,
        limnigraf.beschreibung AS technische_angabe,
        limnigraf.bemerkung AS bemerkung,
        dokumente.dokumente AS dokumente, 
        wkb_geometry AS geometrie
    FROM 
        (SELECT * FROM vegas.obj_messstation WHERE objekttyp_id = 22 AND limnigraf IS TRUE AND "archive" = 0) limnigraf
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
         ) dokumente ON limnigraf.vegas_id = dokumente.vegas_id );
