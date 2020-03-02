/* Grundwasserschutzzone_areal*/
SELECT
    uuid_generate_v4() AS t_ili_tid,
    NULL AS objektnummer,
    'Grundwasserschutzzone_areal' AS objekttyp,
    "zone" AS weitere_Informationen,
    NULL AS objektname,
    'Ausgangslage' AS abstimmungskategorie,
    NULL AS bedeutung,
    'rechtsgueltig' AS planungsstand,
    'bestehend' AS status,
    ST_Union(ST_SnapToGrid(wkb_geometry, 0.001)) AS geometrie,
    NULL AS dokumente,
    string_agg(DISTINCT hoheitsgrenzen_gemeindegrenze.gemeindename, ', ' ORDER BY hoheitsgrenzen_gemeindegrenze.gemeindename) AS gemeindenamen
FROM
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze,
    public.aww_gszoar
WHERE
    "archive" = 0
    AND
    ST_Intersects(aww_gszoar.wkb_geometry, hoheitsgrenzen_gemeindegrenze.geometrie) = TRUE
GROUP BY 
    "zone"
       
UNION ALL   
     
  /*Fruchtfolgeflaeche*/
SELECT
    uuid_generate_v4() AS t_ili_tid,
    NULL AS objektnummer,
    'Fruchtfolgeflaeche' AS objekttyp,
    NULL AS weitere_Informationen,
    NULL AS objektname,
    'Ausgangslage' AS abstimmungskategorie,
    NULL AS bedeutung,
    'rechtsgueltig' AS planungsstand,
    'bestehend' AS status,
    ST_Multi(ST_SnapToGrid(wkb_geometry, 0.001)) AS geometrie,
    NULL AS dokumente,
    string_agg(DISTINCT hoheitsgrenzen_gemeindegrenze.gemeindename, ', ' ORDER BY hoheitsgrenzen_gemeindegrenze.gemeindename) AS gemeindenamen
FROM
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze,
    alw_grundlagen.fruchtfolgeflaechen_tab
WHERE
    "archive" = 0
    AND
    ST_Intersects(fruchtfolgeflaechen_tab.wkb_geometry, hoheitsgrenzen_gemeindegrenze.geometrie) = TRUE
    AND
    ST_Multi(ST_SnapToGrid(wkb_geometry, 0.001)) IS NOT NULL
GROUP BY
    ogc_fid  
    
UNION ALL  
    
 /*Abbaustelle*/
SELECT
    uuid_generate_v4() AS t_ili_tid,
    akten_nr_t AS objektnummer,
    CASE 
        WHEN mat = 1
            THEN 'Abbaustelle.Kies'
        WHEN mat = 2
            THEN 'Abbaustelle.Kalkstein'
        WHEN mat = 3
            THEN 'Abbaustelle.Ton'
    END AS objekttyp,
    NULL AS weitere_Informationen,
    name AS objektname,
    'Ausgangslage' AS abstimmungskategorie,
    NULL AS bedeutung,
    'rechtsgueltig' AS planungsstand,
    CASE 
        WHEN rip_darstellung = 1
            THEN 'Ausgangslage'
        WHEN rip_darstellung = 2
            THEN 'Erweiterung'
        WHEN rip_darstellung = 3
            THEN 'neu'
        END AS status,
    ST_Multi(ST_SnapToGrid(wkb_geometry, 0.001)) AS geometrie,
    NULL AS dokumente,
    string_agg(hoheitsgrenzen_gemeindegrenze.gemeindename, ', ') AS gemeindenamen
FROM
    abbaustellen.abbaustellen,
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze
WHERE
    ST_DWithin(abbaustellen.wkb_geometry, hoheitsgrenzen_gemeindegrenze.geometrie, 0)
AND
    ST_Intersects(abbaustellen.wkb_geometry, hoheitsgrenzen_gemeindegrenze.geometrie)
AND
    "archive" = 0
AND
    mat IN (1, 2, 3)
AND
    rip_darstellung IN (1, 2, 3)
GROUP BY
    ogc_fid
;
