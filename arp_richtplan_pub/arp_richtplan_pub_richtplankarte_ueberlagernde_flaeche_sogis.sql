WITH documents_naturreservate AS (
    SELECT DISTINCT 
        bezeichnung, 
        typ, 
        rechtsstatus, 
        publiziertab, 
        rechtsvorschrift, 
        offiziellenr,
        reservate_reservat_dokument.reservat,
        CASE
            WHEN 
                reservate_dokument.typ = 'RRB'  
                AND 
                position('/opt/sogis_pic/documents/ch.so.arp.naturreservate/rrb/' IN reservate_dokument.dateipfad) != 0 
                AND 
                reservate_dokument.bezeichnung != ''
                AND 
                reservate_dokument.bezeichnung IS NOT NULL
                THEN 'https://geo.so.ch/docs/'
                                || split_part(reservate_dokument.dateipfad, '/documents/', 2)
            WHEN 
                reservate_dokument.typ = 'RRB' 
                AND 
                position('/opt/sogis_pic/documents/ch.so.arp.naturreservate/rrb/' IN reservate_dokument.dateipfad) != 0 
                AND 
                (
                    reservate_dokument.bezeichnung = ''
                    OR 
                    reservate_dokument.bezeichnung IS NULL
                )
                THEN 'https://geo.so.ch/docs/'
                                || split_part(reservate_dokument.dateipfad, '/documents/', 2)
                                
            WHEN 
                reservate_dokument.typ = 'RRB' 
                AND 
                position('opt/sogis_pic/daten_aktuell/arp/Zonenplaene/Zonenplaene_pdf/' IN reservate_dokument.dateipfad) != 0
                AND 
                reservate_dokument.bezeichnung != ''
                AND 
                reservate_dokument.bezeichnung IS NOT NULL
                THEN 'https://geo.so.ch/docs/ch.so.arp.zonenplaene/'
                                || split_part(reservate_dokument.dateipfad, '/Zonenplaene/', 2)
                                
            WHEN 
                reservate_dokument.typ = 'RRB'
                AND 
                position('opt/sogis_pic/daten_aktuell/arp/Zonenplaene/Zonenplaene_pdf/' IN reservate_dokument.dateipfad) != 0
                AND 
                (
                    reservate_dokument.bezeichnung = ''
                    OR 
                    reservate_dokument.bezeichnung IS NULL
                )
                THEN 'https://geo.so.ch/docs/ch.so.arp.zonenplaene/'
                                || split_part(reservate_dokument.dateipfad, '/Zonenplaene/', 2)
            WHEN 
                (
                    reservate_dokument.typ = 'Kommunale_Inventare'
                    OR
                    reservate_dokument.typ = 'Bericht'
                    OR
                    reservate_dokument.typ = 'Pflegekonzept'
                )
                AND 
                reservate_dokument.bezeichnung != ''
                AND 
                reservate_dokument.bezeichnung IS NOT NULL
                THEN 'https://geo.so.ch/docs/'
                                || split_part(reservate_dokument.dateipfad, '/documents/', 2)                              
            WHEN 
                (
                    reservate_dokument.typ = 'Kommunale_Inventare'
                    OR
                    reservate_dokument.typ = 'Bericht'
                    OR
                    reservate_dokument.typ = 'Pflegekonzept'
                )
                AND 
                (
                    reservate_dokument.bezeichnung = ''
                    OR 
                    reservate_dokument.bezeichnung IS NULL
                )
                THEN  'https://geo.so.ch/docs/'
                                || split_part(reservate_dokument.dateipfad, '/documents/', 2)
            WHEN 
                (
                    reservate_dokument.typ = 'Sonderbauvorschriften'
                    OR 
                    reservate_dokument.typ = 'Gestaltungsplan'
                )
                AND 
                reservate_dokument.bezeichnung != ''
                AND 
                reservate_dokument.bezeichnung IS NOT NULL
                THEN 'https://geo.so.ch/docs/ch.so.arp.zonenplaene/'
                                || split_part(reservate_dokument.dateipfad, '/Zonenplaene/', 2)                
            WHEN 
                (
                    reservate_dokument.typ = 'Sonderbauvorschriften'
                    OR 
                    reservate_dokument.typ = 'Gestaltungsplan'
                )
                AND 
                (
                    reservate_dokument.bezeichnung = ''
                    OR 
                    reservate_dokument.bezeichnung IS NULL
                )
                THEN 'https://geo.so.ch/docs/ch.so.arp.zonenplaene/'
                                || split_part(reservate_dokument.dateipfad, '/Zonenplaene/', 2)
            ELSE NULL 
        END AS dokumente
    FROM 
        arp_naturreservate.reservate_reservat_dokument
        LEFT JOIN arp_naturreservate.reservate_dokument
            ON reservate_dokument.t_id = reservate_reservat_dokument.dokument
    
    UNION
    
    SELECT 
        'Objektblatt' AS bezeichnung, 
        'Objektblatt' AS typ, 
        'laufendeAenderung' AS rechtsstatus, 
        NULL AS publiziertab, 
        FALSE AS rechtsvorschrift, 
        NULL AS offiziellenr,
        reservate_reservat.t_id,
        'https://geo.so.ch/api/v1/document/Naturreservate?feature=' || reservate_reservat.t_id
    FROM
        arp_naturreservate.reservate_reservat
        
    UNION
    
    SELECT 
        'Fotos' AS bezeichnung, 
        'Fotos' AS typ, 
        'laufendeAenderung' AS rechtsstatus, 
        NULL AS publiziertab, 
        FALSE AS rechtsvorschrift, 
        NULL AS offiziellenr,
        reservate_reservat.t_id,
        'http://faust.so.ch/suche_start.fau?prj=ARP&dm=FVARP02&rpos=3&ro_zeile_2=' || reservate_reservat.nummer
    FROM
        arp_naturreservate.reservate_reservat
),
documents_json_naturreservate AS (
    SELECT 
        array_to_json(array_agg(row_to_json(documents_naturreservate)))::text AS dokumente, 
        reservat
    FROM 
        documents_naturreservate
    GROUP BY 
        reservat
)


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

/*kantonales_Naturreservat*/
SELECT
    uuid_generate_v4() AS t_ili_tid,
    CAST(reservate_reservat.nummer AS varchar) AS nummer,
    'kantonales_Naturreservat' AS objekttyp,
    NULL AS weitere_Informationen,
    reservate_reservat.reservatsname as objektname,
    'Ausgangslage' AS abstimmungskategorie,
    NULL AS bedeutung,
    'rechtsgueltig' AS planungsstand,
    'bestehend' AS status,
    ST_Multi(ST_Union(ST_SnapToGrid(reservate_teilgebiet.geometrie, 0.001))) AS geometrie,
    documents_json_naturreservate.dokumente AS dokumente,
    string_agg(DISTINCT hoheitsgrenzen_gemeindegrenze.gemeindename, ', ' ORDER BY hoheitsgrenzen_gemeindegrenze.gemeindename) AS gemeindenamen
FROM
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze,
    arp_naturreservate.reservate_reservat
    LEFT JOIN arp_naturreservate.reservate_teilgebiet
        ON reservate_teilgebiet.reservat = reservate_reservat.t_id
    LEFT JOIN documents_json_naturreservate
        ON documents_json_naturreservate.reservat = reservate_reservat.t_id
WHERE 
    ST_Intersects(reservate_teilgebiet.geometrie, hoheitsgrenzen_gemeindegrenze.geometrie) = TRUE
GROUP BY 
    reservate_reservat.t_id,
    documents_json_naturreservate.dokumente
       
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
    'bestehend' AS status,
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
GROUP BY
    ogc_fid
;
