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
),
documents_richtplan AS (
    SELECT DISTINCT
        richtplankarte_dokument.t_id,
        richtplankarte_dokument.t_ili_tid,
        richtplankarte_dokument.titel,
        richtplankarte_dokument.publiziertAb,
        richtplankarte_dokument.bemerkung,
        richtplankarte_ueberlagernde_flaeche.t_id AS ueberlagernde_flaeche_id,
        CASE
            WHEN position('/opt/sogis_pic/documents/ch.so.arp.richtplan/' IN richtplankarte_dokument.dateipfad) != 0
                THEN 'https://geo.so.ch/docs/' || split_part(richtplankarte_dokument.dateipfad, '/documents/', 2)
            WHEN position('opt/sogis_pic/daten_aktuell/arp/Zonenplaene/Zonenplaene_pdf/' IN richtplankarte_dokument.dateipfad) != 0
                THEN 'https://geo.so.ch/docs/ch.so.arp.zonenplaene/' || split_part(richtplankarte_dokument.dateipfad, '/Zonenplaene/', 2)
            WHEN position('G:\documents\' IN richtplankarte_dokument.dateipfad) != 0    
                THEN replace(richtplankarte_dokument.dateipfad, 'G:\documents\', 'https://geo.so.ch/docs/')
        END AS dokument
    FROM 
        arp_richtplan_v1.richtplankarte_ueberlagernde_flaeche_dokument
        LEFT JOIN arp_richtplan_v1.richtplankarte_dokument
            ON richtplankarte_dokument.t_id = richtplankarte_ueberlagernde_flaeche_dokument.dokument
        RIGHT JOIN arp_richtplan_v1.richtplankarte_ueberlagernde_flaeche
            ON richtplankarte_ueberlagernde_flaeche_dokument.ueberlagernde_flaeche = richtplankarte_ueberlagernde_flaeche.t_id
    WHERE
        (titel, dateipfad) IS NOT NULL
),
documents_json_richtplan AS (
    SELECT 
        array_to_json(
            array_agg(
                row_to_json((
                    SELECT
                        docs
                    FROM 
                        (
                            SELECT
                                t_id,
                                t_ili_tid,
                                titel,
                                publiziertAb,
                                bemerkung,
                                dokument
                        ) docs
                ))
            )
        ) AS dokumente,
        ueberlagernde_flaeche_id
    FROM 
        documents_richtplan
    GROUP BY 
        ueberlagernde_flaeche_id
),
betroffene_gemeinden AS (
    SELECT
        richtplankarte_ueberlagernde_flaeche.t_id,
       string_agg(DISTINCT hoheitsgrenzen_gemeindegrenze.gemeindename, ', ' ORDER BY hoheitsgrenzen_gemeindegrenze.gemeindename) AS gemeindenamen
    FROM
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze,
        arp_richtplan_v1.richtplankarte_ueberlagernde_flaeche
    WHERE
        ST_Intersects(richtplankarte_ueberlagernde_flaeche.geometrie, hoheitsgrenzen_gemeindegrenze.geometrie) = TRUE
    GROUP BY
        richtplankarte_ueberlagernde_flaeche.t_id
)

/* Deponie
 * Windenergie,
 * Naturpark,
 * kantonales_Vorranggeiet,
 * Sondernutzungsgebiet,
 * Witischutzzone,
 * kantonale_Uferschutzzone,
 * Juraschutzzone (alt aus Richtplan),
 * Entwicklungsgebiet_Arbeiten,
 * Siedlungstrennguertel,
 * BLN-Gebiet
 */
SELECT
    richtplankarte_ueberlagernde_flaeche.t_ili_tid,
    richtplankarte_ueberlagernde_flaeche.objektnummer,
    richtplankarte_ueberlagernde_flaeche.objekttyp,
    richtplankarte_ueberlagernde_flaeche.weitere_Informationen,
    richtplankarte_ueberlagernde_flaeche.objektname,
    richtplankarte_ueberlagernde_flaeche.abstimmungskategorie,
    richtplankarte_ueberlagernde_flaeche.bedeutung,
    richtplankarte_ueberlagernde_flaeche.planungsstand,
    richtplankarte_ueberlagernde_flaeche.astatus,
    richtplankarte_ueberlagernde_flaeche.geometrie,
    documents_json_richtplan.dokumente::text,
    betroffene_gemeinden.gemeindenamen
FROM
    arp_richtplan_v1.richtplankarte_ueberlagernde_flaeche
    LEFT JOIN documents_json_richtplan
        ON documents_json_richtplan.ueberlagernde_flaeche_id = richtplankarte_ueberlagernde_flaeche.t_id
    LEFT JOIN betroffene_gemeinden
        ON betroffene_gemeinden.t_id = richtplankarte_ueberlagernde_flaeche.t_id
WHERE
    richtplankarte_ueberlagernde_flaeche.planungsstand IN ('rechtsgueltig', 'in_Auflage')

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
    'bestehend' AS astatus,
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

/* Grundwasserschutzzone_areal*/
SELECT
    uuid_generate_v4() AS t_ili_tid,
    NULL AS nummer,
    'Grundwasserschutzzone_areal' AS objekttyp,
    "typ" AS weitere_Informationen,
    NULL AS objektname,
    'Ausgangslage' AS abstimmungskategorie,
    NULL AS bedeutung,
    'rechtsgueltig' AS planungsstand,
    'bestehend' AS astatus,
    schutzzone.geometrie AS geometrie,
    NULL AS dokumente,
    string_agg(DISTINCT gemeindegrenze.gemeindename, ', ' ORDER BY gemeindegrenze.gemeindename) AS gemeindenamen
FROM
    (
        -- Grundwasserschutzzonen
        SELECT
            'Zone' AS typ,
            ST_Union(ST_SnapToGrid(gwszone.geometrie, 0.001)) AS geometrie
        FROM
            afu_gewaesserschutz.gwszonen_gwszone AS gwszone
            LEFT JOIN afu_gewaesserschutz.gwszonen_status AS status
            ON gwszone.astatus = status.t_id
        WHERE
            rechtsstatus = 'inKraft'
        
        UNION ALL
         
        -- Grundwasserschutzareale
        SELECT
            'Areal' AS typ,
            ST_Union(ST_SnapToGrid(gwsareal.geometrie, 0.001)) AS geometrie
        FROM
            afu_gewaesserschutz.gwszonen_gwsareal AS gwsareal
            LEFT JOIN afu_gewaesserschutz.gwszonen_status AS status
            ON gwsareal.astatus = status.t_id
        WHERE
            rechtsstatus = 'inKraft'
        AND
            typ = 'Areal'
    ) AS schutzzone,
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS gemeindegrenze
WHERE
    ST_Intersects(schutzzone.geometrie, gemeindegrenze.geometrie) = TRUE
GROUP BY 
    schutzzone.geometrie,
    schutzzone.typ
;
