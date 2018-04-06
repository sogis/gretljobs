SELECT
    reservate_teilgebiet.t_id,
    reservate_teilgebiet.aname,
    reservate_teilgebiet.beschreibung,
    ST_Area(reservate_teilgebiet.geometrie)/10000 AS flaeche,
    string_agg(DISTINCT hoheitsgrenzen_gemeindegrenze.gemeindename, ', ' ORDER BY hoheitsgrenzen_gemeindegrenze.gemeindename) AS gemeinden,
string_agg(
        DISTINCT
            CASE
                WHEN 
                    reservate_dokument.typ = 'RRB' 
                    AND 
                    position('/opt/sogis_pic/daten_aktuell/arp/natur_und_landschaft/dokumente/rrb/' IN reservate_dokument.dateipfad) != 0 
                    AND 
                    reservate_dokument.bezeichnung != ''
                    THEN '<a href ="https://geoweb.so.ch/naturreservate/' 
                                    || split_part(reservate_dokument.dateipfad, '/natur_und_landschaft/dokumente/', 2)  || '" target="_blank">' || reservate_dokument.bezeichnung || ' (RRB)</a>'
                WHEN 
                    reservate_dokument.typ = 'RRB' 
                    AND 
                    position('/opt/sogis_pic/daten_aktuell/arp/natur_und_landschaft/dokumente/rrb/' IN reservate_dokument.dateipfad) != 0 
                    AND 
                    reservate_dokument.bezeichnung = ''
                    THEN '<a href ="https://geoweb.so.ch/naturreservate/' 
                                    || split_part(reservate_dokument.dateipfad, '/natur_und_landschaft/dokumente/', 2) || '" target="_blank">' || reservate_dokument.typ || '</a>'
                                    
                WHEN 
                    reservate_dokument.typ = 'RRB' 
                    AND 
                    position('opt/sogis_pic/daten_aktuell/apr/Zonenplaene/Zonenplaene_pdf/' IN reservate_dokument.dateipfad) != 0
                    AND 
                    reservate_dokument.bezeichnung != '' 
                    THEN '<a href ="https://geoweb.so.ch/zonenplaene/' 
                                    || split_part(reservate_dokument.dateipfad, '/Zonenplaene/', 2) || '" target="_blank">' || reservate_dokument.bezeichnung || ' (RRB)</a>'
                                    
                WHEN 
                    reservate_dokument.typ = 'RRB' 
                    AND 
                    position('opt/sogis_pic/daten_aktuell/apr/Zonenplaene/Zonenplaene_pdf/' IN reservate_dokument.dateipfad) != 0
                    AND 
                    reservate_dokument.bezeichnung = ''
                    THEN '<a href ="https://geoweb.so.ch/zonenplaene/' 
                                    || split_part(reservate_dokument.dateipfad, '/Zonenplaene/', 2) || '" target="_blank">' || reservate_dokument.typ || '</a>'
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
                    THEN '<a href ="https://geoweb.so.ch/naturreservate/' 
                                    || split_part(reservate_dokument.dateipfad, '/natur_und_landschaft/dokumente/', 2) || '" target="_blank">' || reservate_dokument.bezeichnung || '</a>'                                    
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
                    THEN  '<a href ="https://geoweb.so.ch/naturreservate/' 
                                    || split_part(reservate_dokument.dateipfad, '/natur_und_landschaft/dokumente/', 2) || '" target="_blank">' || reservate_dokument.typ || '</a>'
               WHEN 
                    (
                        reservate_dokument.typ = 'Sonderbauvorschriften' 
                        OR 
                        reservate_dokument.typ = 'Gestaltungsplan'
                    )
                    AND 
                    reservate_dokument.bezeichnung != '' 
                    THEN '<a href ="https://geoweb.so.ch/zonenplaene/' 
                                    || split_part(reservate_dokument.dateipfad, '/Zonenplaene/', 2)  || '" target="_blank">' || reservate_dokument.bezeichnung || '</a>'                                    
                WHEN 
                    (
                        reservate_dokument.typ = 'Sonderbauvorschriften' 
                        OR 
                        reservate_dokument.typ = 'Gestaltungsplan'
                    )
                    AND 
                    reservate_dokument.bezeichnung = ''
                    THEN '<a href ="https://geoweb.so.ch/zonenplaene/' 
                                    || split_part(reservate_dokument.dateipfad, '/Zonenplaene/', 2) || '" target="_blank">' || reservate_dokument.typ || '</a>'
                ELSE NULL 
            END
    , '<br>') 
         || ', http://georeport.so.ch/jasperserver/rest_v2/reports/reports/arp/naturreservate/pflanzenliste.pdf?j_username=mspublic_user&j_password=mspublic&teilgebiet_id=' || reservate_teilgebiet.t_id 
            AS dokumente,
    string_agg(DISTINCT liegen.nummer || '(' || liegen.gem_bfs|| ')', ', ' ORDER BY liegen.nummer || '(' || liegen.gem_bfs || ')') AS parzellennummern,
    reservate_reservat.nummer AS reservatsnummer,
    reservate_reservat.aname AS reservatsname,
    mjpnatur.vereinbarungsflaechen,
    mjpnatur.bewirtschafter,
    reservate_teilgebiet.geometrie
FROM
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze,
    avdpool.liegen,
    arp_naturreservate.reservate_teilgebiet
    LEFT JOIN arp_naturreservate.reservate_reservat
        ON reservate_teilgebiet.reservat = reservate_reservat.t_id
    LEFT JOIN arp_naturreservate.reservate_reservat_dokument
        ON reservate_reservat_dokument.reservat = reservate_reservat.t_id
    LEFT JOIN arp_naturreservate.reservate_dokument
        ON reservate_dokument.t_id = reservate_reservat_dokument.dokument
    LEFT JOIN 
        (
            SELECT 
                reservate_teilgebiet.t_id,
                string_agg(DISTINCT flaechen_geom.vbnr, ', ' ORDER BY flaechen_geom.vbnr) AS vereinbarungsflaechen,
                string_agg(DISTINCT 
                    CASE
                        WHEN personen.name IS NOT NULL AND personen.name != '' AND personen.vorname IS NOT NULL AND personen.vorname != ''
                            THEN personen.name || ', ' || personen.vorname
                        WHEN (personen.name IS NULL OR personen.name = '') AND personen.vorname IS NOT NULL AND personen.vorname != ''
                            THEN personen.vorname
                        WHEN personen.name IS NOT NULL AND personen.name != '' AND (personen.vorname IS NULL OR personen.vorname = '')
                            THEN personen.name
                        ELSE NULL 
                    END
                    , '; ') AS bewirtschafter
            FROM 
                arp_naturreservate.reservate_teilgebiet,
                mjpnatur.flaechen_geom 
                LEFT JOIN mjpnatur.personen
                    ON personen.persid = flaechen_geom.persid
            WHERE 
                ST_Intersects(reservate_teilgebiet.geometrie, flaechen_geom.wkb_geometry) = TRUE
            GROUP BY 
                reservate_teilgebiet.t_id) AS mjpnatur
        ON mjpnatur.t_id = reservate_teilgebiet.t_id

WHERE 
    ST_Intersects(reservate_teilgebiet.geometrie, hoheitsgrenzen_gemeindegrenze.geometrie) = TRUE 
    AND
    ST_Intersects(reservate_teilgebiet.geometrie, liegen.wkb_geometry) = TRUE
    AND 
    liegen.ARCHIVE = 0
GROUP BY
    reservate_teilgebiet.t_id,
    reservate_reservat.t_id,
    mjpnatur.vereinbarungsflaechen,
    mjpnatur.bewirtschafter
;