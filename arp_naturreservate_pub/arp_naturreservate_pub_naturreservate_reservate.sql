WITH documents AS (
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
                THEN 'https://geo.so.ch/docs/'
                                || split_part(reservate_dokument.dateipfad, '/documents/', 2)
            WHEN 
                reservate_dokument.typ = 'RRB' 
                AND 
                position('/opt/sogis_pic/documents/ch.so.arp.naturreservate/rrb/' IN reservate_dokument.dateipfad) != 0 
                AND 
                reservate_dokument.bezeichnung = ''
                THEN 'https://geo.so.ch/docs/'
                                || split_part(reservate_dokument.dateipfad, '/documents/', 2)
                                
            WHEN 
                reservate_dokument.typ = 'RRB' 
                AND 
                position('opt/sogis_pic/daten_aktuell/arp/Zonenplaene/Zonenplaene_pdf/' IN reservate_dokument.dateipfad) != 0
                AND 
                reservate_dokument.bezeichnung != '' 
                THEN 'https://geo.so.ch/docs/ch.so.arp.zonenplaene/'
                                || split_part(reservate_dokument.dateipfad, '/Zonenplaene/', 2)
                                
            WHEN 
                reservate_dokument.typ = 'RRB'
                AND 
                position('opt/sogis_pic/daten_aktuell/arp/Zonenplaene/Zonenplaene_pdf/' IN reservate_dokument.dateipfad) != 0
                AND 
                reservate_dokument.bezeichnung = ''
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
                reservate_dokument.bezeichnung = ''
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
                THEN 'https://geo.so.ch/docs/ch.so.arp.zonenplaene/'
                                || split_part(reservate_dokument.dateipfad, '/Zonenplaene/', 2)                
            WHEN 
                (
                    reservate_dokument.typ = 'Sonderbauvorschriften'
                    OR 
                    reservate_dokument.typ = 'Gestaltungsplan'
                )
                AND 
                reservate_dokument.bezeichnung = ''
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
        'https://geo.so.ch/api/v1/document/?template=Naturreservate&feature=' || reservate_reservat.t_id
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
    
), documents_json AS (
    SELECT 
        array_to_json(array_agg(row_to_json(documents)))::text AS dokumente, 
        reservat
    FROM 
        documents
    GROUP BY 
        reservat
)


SELECT
    reservate_reservat.t_id,
    reservate_reservat.nummer,
    reservate_reservat.nsi_nummer,
    reservate_reservat.reservatsname as aname,
    reservate_reservat.beschreibung,
    ST_Area(ST_Union(reservate_teilgebiet.geometrie))/10000 AS flaeche,
    string_agg(DISTINCT reservate_teilgebiet.teilgebietsname, ', ' ORDER BY reservate_teilgebiet.teilgebietsname) AS teilgebietsnamen,
    string_agg(DISTINCT hoheitsgrenzen_gemeindegrenze.gemeindename, ', ' ORDER BY hoheitsgrenzen_gemeindegrenze.gemeindename) AS gemeinden,
    documents_json.dokumente AS dokumente,
    string_agg(
        DISTINCT
            CASE
                WHEN reservate_zustaendiger.zustaendigername IS NOT NULL
                    AND reservate_zustaendiger.organisation IS NOT NULL
                    THEN reservate_zustaendiger.zustaendigername || ' (' || reservate_zustaendiger.organisation || ')'
                WHEN reservate_zustaendiger.zustaendigername IS NOT NULL AND reservate_zustaendiger.organisation IS NULL
                    THEN reservate_zustaendiger.zustaendigername
                WHEN reservate_zustaendiger.zustaendigername IS NULL AND reservate_zustaendiger.organisation IS NOT NULL
                    THEN reservate_zustaendiger.organisation
                ELSE NULL 
            END
    , ', ') AS zustaendiger,
    ST_Multi(ST_Union(reservate_teilgebiet.geometrie)) AS geometrie
    
FROM
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze,
    arp_naturreservate.reservate_reservat
    LEFT JOIN arp_naturreservate.reservate_teilgebiet
        ON reservate_teilgebiet.reservat = reservate_reservat.t_id
    LEFT JOIN documents_json
        ON documents_json.reservat = reservate_reservat.t_id
    LEFT JOIN arp_naturreservate.reservate_reservat_zustaendiger
        ON reservate_reservat_zustaendiger.reservat = reservate_reservat.t_id
    LEFT JOIN arp_naturreservate.reservate_zustaendiger
        ON reservate_zustaendiger.t_id = reservate_reservat_zustaendiger.zustaendiger
WHERE 
    ST_Intersects(reservate_teilgebiet.geometrie, hoheitsgrenzen_gemeindegrenze.geometrie) = TRUE
GROUP BY 
    reservate_reservat.t_id,
    documents_json.dokumente
;