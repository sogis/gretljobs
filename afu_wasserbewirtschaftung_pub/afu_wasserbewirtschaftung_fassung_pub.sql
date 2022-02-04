(SELECT 
     'Sodbrunnen' AS fassungstyp, 
     sodbrunnen.menge AS konzessionsmenge, 
     sodbrunnen.schutzzone, 
     CASE 
         WHEN sodbrunnen.nutzungsart = 3 
         THEN 'privat'
         WHEN sodbrunnen.nutzungsart = 2 
         THEN 'privat_oeffentliches_Interesse'
         WHEN sodbrunnen.nutzungsart = 1 
         THEN 'oeffentlich'
     END AS nutzungstyp, 
     CASE 
         WHEN sodbrunnen.verwendung = 1 
         THEN 'Trinkwasser' 
         WHEN sodbrunnen.verwendung = 2 
         THEN 'Brauchwasser'
         WHEN sodbrunnen.verwendung = 3
         THEN 'Notbrunnen'
     END AS verwendungszweck,
     'Sodbrunnen' AS objekttyp_anzeige,
     sodbrunnen.bezeichnung AS objektname, 
     sodbrunnen.mobj_id AS objektnummer,
     sodbrunnen.beschreibung AS technische_angabe,
     sodbrunnen.bemerkung AS bemerkung,
     array_to_json(dokumente.dokumente) AS dokumente, 
     wkb_geometry AS geometrie
 FROM (SELECT * FROM vegas.obj_objekt_v where objekttyp_id = 6 AND archive=0) sodbrunnen
 LEFT JOIN 
     (SELECT 
          array_agg('https://geo.so.ch/docs/ch.so.afu.grundwasserbewirtschaftung/'||y.vegas_id||'_'||x.dokument_id||'.'||x.dateiendung) AS dokumente, 
          y.vegas_id
      FROM 
          vegas.adm_dokument x, 
          vegas.adm_objekt_dokument y 
      WHERE x.dokument_id = y.dokument_id
      GROUP BY y.vegas_id) dokumente ON sodbrunnen.vegas_id = dokumente.vegas_id)
UNION ALL 
(SELECT 
     'Horizontalfilterbrunnen' AS fassungstyp, 
     horizontalfilterbrunnen.menge AS konzessionsmenge, 
     horizontalfilterbrunnen.schutzzone, 
     CASE 
         WHEN horizontalfilterbrunnen.nutzungsart = 3 
         THEN 'privat'
         WHEN horizontalfilterbrunnen.nutzungsart = 2 
         THEN 'privat_oeffentliches_Interesse'
         WHEN horizontalfilterbrunnen.nutzungsart = 1 
         THEN 'oeffentlich'
     END AS nutzungstyp, 
     CASE 
         WHEN horizontalfilterbrunnen.verwendung = 1 
         THEN 'Trinkwasser' 
         WHEN horizontalfilterbrunnen.verwendung = 2 
         THEN 'Brauchwasser'
         WHEN horizontalfilterbrunnen.verwendung = 3
         THEN 'Notbrunnen'
     END AS verwendungszweck,
     CASE 
         WHEN horizontalfilterbrunnen.nutzungsart = 3 
         THEN 'Horizontalfilterbrunnen mit privater Nutzung'
         WHEN horizontalfilterbrunnen.nutzungsart = 2 
         THEN 'Horizontalfilterbrunnen mit privater Nutzung von öffentlichem Interesse'
         WHEN horizontalfilterbrunnen.nutzungsart = 1 
         THEN 'Horizontalfilterbrunnen für die öffentliche Wasserversorgung' 
         WHEN horizontalfilterbrunnen.nutzungsart IS NULL OR horizontalfilterbrunnen.nutzungsart > 3 
         THEN 'Horizontalfilterbrunnen'
     END AS objekttyp_anzeige,
     horizontalfilterbrunnen.bezeichnung AS objektname, 
     horizontalfilterbrunnen.mobj_id AS objektnummer,
     horizontalfilterbrunnen.beschreibung AS technische_angabe,
     horizontalfilterbrunnen.bemerkung AS bemerkung,
     array_to_json(dokumente.dokumente) AS dokumente, 
     wkb_geometry AS geometrie
 FROM (SELECT * FROM vegas.obj_objekt_v where objekttyp_id = 7 AND subtyp = 2 AND archive=0) horizontalfilterbrunnen
 LEFT JOIN 
     (SELECT 
          array_agg('https://geo.so.ch/docs/ch.so.afu.grundwasserbewirtschaftung/'||y.vegas_id||'_'||x.dokument_id||'.'||x.dateiendung) AS dokumente,
          y.vegas_id
      FROM 
          vegas.adm_dokument x, 
          vegas.adm_objekt_dokument y 
      WHERE x.dokument_id = y.dokument_id
      GROUP BY y.vegas_id) dokumente ON horizontalfilterbrunnen.vegas_id = dokumente.vegas_id)
UNION ALL 
(SELECT 
     'Vertikalfilterbrunnen' AS fassungstyp, 
     vertikalfilterbrunnen.menge AS konzessionsmenge, 
     vertikalfilterbrunnen.schutzzone, 
     CASE 
         WHEN vertikalfilterbrunnen.nutzungsart = 3 
         THEN 'privat'
         WHEN vertikalfilterbrunnen.nutzungsart = 2 
         THEN 'privat_oeffentliches_Interesse'
         WHEN vertikalfilterbrunnen.nutzungsart = 1 
         THEN 'oeffentlich'
     END AS nutzungstyp, 
     CASE 
         WHEN vertikalfilterbrunnen.verwendung = 1 
         THEN 'Trinkwasser' 
         WHEN vertikalfilterbrunnen.verwendung = 2 
         THEN 'Brauchwasser'
         WHEN vertikalfilterbrunnen.verwendung = 3
         THEN 'Notbrunnen'
     END AS verwendungszweck,
     CASE 
         WHEN vertikalfilterbrunnen.nutzungsart = 3 
         THEN 'Vertikalfilterbrunnen mit privater Nutzung'
         WHEN vertikalfilterbrunnen.nutzungsart = 2 
         THEN 'Vertikalfilterbrunnen mit privater Nutzung von öffentlichem Interesse'
         WHEN vertikalfilterbrunnen.nutzungsart = 1 
         THEN 'Vertikalfilterbrunnen für die öffentliche Wasserversorgung' 
         WHEN vertikalfilterbrunnen.nutzungsart IS NULL OR vertikalfilterbrunnen.nutzungsart > 3 
         THEN 'Vertikalfilterbrunnen'
     END AS objekttyp_anzeige,
     vertikalfilterbrunnen.bezeichnung AS objektname, 
     vertikalfilterbrunnen.mobj_id AS objektnummer,
     vertikalfilterbrunnen.beschreibung AS technische_angabe,
     vertikalfilterbrunnen.bemerkung AS bemerkung,
     array_to_json(dokumente.dokumente) AS dokumente, 
     wkb_geometry AS geometrie
 FROM (SELECT * FROM vegas.obj_objekt_v where objekttyp_id = 7 AND subtyp = 1 AND archive=0) vertikalfilterbrunnen
 LEFT JOIN 
     (SELECT 
          array_agg('https://geo.so.ch/docs/ch.so.afu.grundwasserbewirtschaftung/'||y.vegas_id||'_'||x.dokument_id||'.'||x.dateiendung) AS dokumente,
          y.vegas_id
      FROM 
          vegas.adm_dokument x, 
          vegas.adm_objekt_dokument y 
      WHERE x.dokument_id = y.dokument_id
      GROUP BY y.vegas_id) dokumente ON vertikalfilterbrunnen.vegas_id = dokumente.vegas_id)
