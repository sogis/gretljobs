WITH documents AS (
    SELECT DISTINCT 
        bezeichnung, 
        typ, 
        reservate_dokument.rechtsstatus, 
        reservate_dokument.publiziertab, 
        rechtsvorschrift, 
        offiziellenr,
        reservate_reservat_dokument.reservat,
        reservate_teilgebiet.t_id AS teilgebiet_id,
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
                position('opt/sogis_pic/daten_aktuell/apr/Zonenplaene/Zonenplaene_pdf/' IN reservate_dokument.dateipfad) != 0
                AND 
                reservate_dokument.bezeichnung != ''
                AND 
                reservate_dokument.bezeichnung IS NOT NULL
                THEN 'https://geo.so.ch/docs/ch.so.arp.zonenplaene/'
                                || split_part(reservate_dokument.dateipfad, '/Zonenplaene/', 2)
                                
            WHEN 
                reservate_dokument.typ = 'RRB'
                AND 
                position('opt/sogis_pic/daten_aktuell/apr/Zonenplaene/Zonenplaene_pdf/' IN reservate_dokument.dateipfad) != 0
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
        RIGHT JOIN arp_naturreservate.reservate_teilgebiet
            ON reservate_reservat_dokument.reservat= reservate_teilgebiet.reservat
    
    UNION
    
    SELECT 
        'Pflanzenliste' AS bezeichnung, 
        'Pflanzenliste' AS typ, 
        'laufendeAenderung' AS rechtsstatus, 
        NULL AS publiziertab, 
        FALSE AS rechtsvorschrift, 
        NULL AS offiziellenr,
        reservate_teilgebiet.reservat,
        reservate_teilgebiet.t_id,
        'https://geo.so.ch/api/v1/document/Pflanzenliste?feature=' || reservate_teilgebiet.t_id,
	einzelschutz
    FROM
        arp_naturreservate.reservate_teilgebiet
    WHERE 
        t_id IN (SELECT DISTINCT teilgebiet FROM arp_naturreservate.reservate_teilgebiet_pflanze)
        
    UNION
    
    SELECT 
        'Objektblatt' AS bezeichnung, 
        'Objektblatt' AS typ, 
        'laufendeAenderung' AS rechtsstatus, 
        NULL AS publiziertab, 
        FALSE AS rechtsvorschrift, 
        NULL AS offiziellenr,
        reservate_reservat.t_id,
        reservate_teilgebiet.t_id,
        'https://geo.so.ch/api/v1/document/Naturreservate?feature=' || reservate_reservat.t_id,
	einzelschutz
    FROM
        arp_naturreservate.reservate_reservat
        RIGHT JOIN arp_naturreservate.reservate_teilgebiet
            ON reservate_reservat.t_id = reservate_teilgebiet.reservat
        
    UNION
    
    SELECT 
        'Fotos' AS bezeichnung, 
        'Fotos' AS typ, 
        'laufendeAenderung' AS rechtsstatus, 
        NULL AS publiziertab, 
        FALSE AS rechtsvorschrift, 
        NULL AS offiziellenr,
        reservate_reservat.t_id,
        reservate_teilgebiet.t_id,
        'http://faust.so.ch/suche_start.fau?prj=ARP&dm=FVARP02&rpos=3&ro_zeile_2=' || reservate_reservat.nummer,
	einzelschutz
    FROM
        arp_naturreservate.reservate_reservat
        RIGHT JOIN arp_naturreservate.reservate_teilgebiet
            ON reservate_reservat.t_id = reservate_teilgebiet.reservat
    
), documents_json AS (
    SELECT 
        array_to_json(array_agg(row_to_json(documents)))::text AS dokumente, 
        teilgebiet_id
    FROM 
        documents
    GROUP BY 
        teilgebiet_id
), mjpnatur AS (
    SELECT 
        reservate_teilgebiet.t_id,
        string_agg(DISTINCT flaechen_geom.vereinbarungsnummer, ', ' ORDER BY flaechen_geom.vereinbarungsnummer) AS vereinbarungsflaechen,
        string_agg(DISTINCT 
            CASE
                WHEN 
                    personen.aname IS NOT NULL 
                    AND 
                    personen.aname != '' 
                    AND 
                    personen.vorname IS NOT NULL 
                    AND 
                    personen.vorname != ''
                        THEN personen.aname || ', ' || personen.vorname
                WHEN 
                    (
                        personen.aname IS NULL 
                        OR 
                        personen.aname = ''
                    ) 
                    AND 
                    personen.vorname IS NOT NULL 
                    AND 
                    personen.vorname != ''
                        THEN personen.vorname
                WHEN 
                    personen.aname IS NOT NULL 
                    AND 
                    personen.aname != '' 
                    AND 
                    (
                        personen.vorname IS NULL 
                        OR 
                        personen.vorname = ''
                    )
                        THEN personen.aname
                ELSE NULL 
            END
            , '; ') AS bewirtschafter
    FROM 
        arp_naturreservate.reservate_teilgebiet,
        arp_mehrjahresprogramm.mehrjahresprgramm_vereinbarungensflaechen flaechen_geom 
        LEFT JOIN arp_mehrjahresprogramm.mehrjahresprgramm_person personen
            ON personen.personenid = flaechen_geom.personenid
    WHERE 
        ST_Intersects(reservate_teilgebiet.geometrie, flaechen_geom.geometrie) = TRUE
    GROUP BY 
        reservate_teilgebiet.t_id
)



SELECT
    reservate_teilgebiet.t_id,
    reservate_teilgebiet.teilgebietsname AS aname,
    reservate_teilgebiet.beschreibung,
    ST_Area(reservate_teilgebiet.geometrie)/10000 AS flaeche,
    string_agg(DISTINCT hoheitsgrenzen_gemeindegrenze.gemeindename, ', ' ORDER BY hoheitsgrenzen_gemeindegrenze.gemeindename) AS gemeinden,
    documents_json.dokumente AS dokumente,
    string_agg(DISTINCT liegen.nummer || '(' || liegen.t_datasetname|| ')', ', ' ORDER BY liegen.nummer || '(' || liegen.t_datasetname || ')') AS parzellennummern,
    reservate_reservat.nummer AS reservatsnummer,
    reservate_reservat.reservatsname AS reservatsname,
    reservate_teilgebiet.einzelschutz,
    mjpnatur.vereinbarungsflaechen,
    mjpnatur.bewirtschafter,
    reservate_teilgebiet.geometrie,
    reservate_teilgebiet.einzelschutz
FROM
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze,
    (SELECT nummer, 
	        liegenschaften_grundstueck.t_datasetname, 
	        geometrie 
	 FROM agi_dm01avso24.liegenschaften_grundstueck 
	 LEFT JOIN agi_dm01avso24.liegenschaften_liegenschaft 
	     ON liegenschaften_liegenschaft.liegenschaft_von = liegenschaften_grundstueck.t_id) 
    liegen,
    arp_naturreservate.reservate_teilgebiet
    LEFT JOIN arp_naturreservate.reservate_reservat
        ON reservate_teilgebiet.reservat = reservate_reservat.t_id
    LEFT JOIN documents_json
        ON documents_json.teilgebiet_id = reservate_teilgebiet.t_id
    LEFT JOIN mjpnatur
        ON mjpnatur.t_id = reservate_teilgebiet.t_id
WHERE 
    ST_Intersects(reservate_teilgebiet.geometrie, hoheitsgrenzen_gemeindegrenze.geometrie) = TRUE 
    AND
    ST_Intersects(reservate_teilgebiet.geometrie, liegen.geometrie) = TRUE
GROUP BY
    reservate_teilgebiet.t_id,
    reservate_reservat.t_id,
    mjpnatur.vereinbarungsflaechen,
    mjpnatur.bewirtschafter,
    documents_json.dokumente
;
