SELECT
    reservate_teilgebiet.t_id,
    reservate_teilgebiet.aname,
    reservate_teilgebiet.beschreibung,
    ST_Area(reservate_teilgebiet.geometrie)/10000 AS flaeche,
    string_agg(DISTINCT hoheitsgrenzen_gemeindegrenze.gemeindename, ', ' ORDER BY hoheitsgrenzen_gemeindegrenze.gemeindename) AS gemeinden,
    string_agg(
        DISTINCT
            CASE
                WHEN reservate_dokument.typ = 'RRB' AND position('/' IN reservate_dokument.dateiname) = 0
                    THEN '/opt/sogis_pic/daten_aktuell/arp/natur_und_landschaft/dokumente/rrb/' || reservate_dokument.dateiname
                WHEN reservate_dokument.typ = 'RRB' AND position('/' IN reservate_dokument.dateiname) != 0
                    THEN 'opt/sogis_pic/daten_aktuell/apr/Zonenplaene/Zonenplaene_pdf' || reservate_dokument.dateiname
                WHEN reservate_dokument.typ = 'Kommunale_Inventare'
                    THEN '/opt/sogis_pic/daten_aktuell/arp/natur_und_landschaft/dokumente/kommunale_inventare/' || reservate_dokument.dateiname
                WHEN reservate_dokument.typ = 'Bericht'
                    THEN '/opt/sogis_pic/daten_aktuell/arp/natur_und_landschaft/dokumente/bericht/' || reservate_dokument.dateiname
                WHEN reservate_dokument.typ = 'Pflegekonzept'
                    THEN '/opt/sogis_pic/daten_aktuell/arp/natur_und_landschaft/dokumente/pflegekonzept/' || reservate_dokument.dateiname
                WHEN reservate_dokument.typ = 'Sonderbauvorschriften' OR reservate_dokument.typ = 'Gestaltungsplan'
                    THEN '/opt/sogis_pic/daten_aktuell/arp/Zonenplaene/Zonenplaene_pdf/' || reservate_dokument.dateiname
                ELSE NULL 
            END
    , ', ') 
        || ', http://georeport.so.ch/jasperserver/rest_v2/reports/reports/arp/naturreservate/objektblatt.pdf?j_username=mspublic_user&j_password=mspublic&reservatsnummer=' || reservate_reservat.nummer 
        || ', http://faust.so.ch/such_start.fau?prj=ARP&dm=FVARP02&rpos=3&ro_zeile_2=' || reservate_reservat.nummer
         || ', http://georeport.so.ch/jasperserver/rest_v2/reports/reports/arp/naturreservate/pflanzenliste.pdf?j_username=mspublic_user&j_password=mspublic&reservatsnummer=' || reservate_reservat.nummer 
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