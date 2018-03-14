SELECT
    reservate_reservat.t_id,
    reservate_reservat.nummer,
    reservate_reservat.nsi_nummer,
    reservate_reservat.aname,
    reservate_reservat.beschreibung,
    ST_Area(ST_Union(reservate_teilgebiet.geometrie))/10000 AS flaeche,
    string_agg(DISTINCT reservate_teilgebiet.aname, ', ' ORDER BY reservate_teilgebiet.aname) AS teilgebietsnamen,
    string_agg(DISTINCT hoheitsgrenzen_gemeindegrenze.gemeindename, ', ' ORDER BY hoheitsgrenzen_gemeindegrenze.gemeindename) AS gemeinden,
    string_agg(
        DISTINCT
            CASE
                WHEN reservate_dokument.typ = 'RRB'
                    THEN '/opt/sogis_pic/daten_aktuell/arp/natur_und_landschaft/dokumente/rrb/' || reservate_dokument.dateiname || '.pdf'
                WHEN reservate_dokument.typ = 'Kommunale_Inventare'
                    THEN '/opt/sogis_pic/daten_aktuell/arp/natur_und_landschaft/dokumente/kommunale_inventare/' || reservate_dokument.dateiname || '.pdf'
                WHEN reservate_dokument.typ = 'Objektblatt'
                    THEN ''
                WHEN reservate_dokument.typ = 'Foto'
                    THEN 'http://faust.so.ch/such_start.fau?prj=ARP&dm=FVARP02&rpos=3&ro_zeile_2='
                WHEN reservate_dokument.typ = 'Bericht'
                    THEN '/opt/sogis_pic/daten_aktuell/arp/natur_und_landschaft/dokumente/bericht/' || reservate_dokument.dateiname || '.pdf'
                WHEN reservate_dokument.typ = 'Pflegekonzept'
                    THEN '/opt/sogis_pic/daten_aktuell/arp/natur_und_landschaft/dokumente/pflegekonzept/' || reservate_dokument.dateiname || '.pdf'
                WHEN reservate_dokument.typ = 'Sonderbauvorschriften' OR reservate_dokument.typ = 'Gestaltungsplan'
                    THEN '/opt/sogis_pic/daten_aktuell/arp/Zonenplaene/Zonenplaene_pdf/' || reservate_dokument.dateiname
                WHEN reservate_dokument.typ = 'Pflanzenliste'
                    THEN ''
                ELSE NULL 
            END
    , ', ') AS dokumente,
    string_agg(
        DISTINCT
            CASE
                WHEN reservate_zustaendiger.aname IS NOT NULL AND reservate_zustaendiger.organisation IS NOT NULL 
                    THEN reservate_zustaendiger.aname || ' (' || reservate_zustaendiger.organisation || ')'
                WHEN reservate_zustaendiger.aname IS NOT NULL AND reservate_zustaendiger.organisation IS NULL
                    THEN reservate_zustaendiger.aname
                WHEN reservate_zustaendiger.aname IS NULL AND reservate_zustaendiger.organisation IS NOT NULL
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
    LEFT JOIN arp_naturreservate.reservate_reservat_dokument
        ON reservate_reservat_dokument.reservat = reservate_reservat.t_id
    LEFT JOIN arp_naturreservate.reservate_dokument
        ON reservate_dokument.t_id = reservate_reservat_dokument.dokument
    LEFT JOIN arp_naturreservate.reservate_reservat_zustaendiger
        ON reservate_reservat_zustaendiger.reservat = reservate_reservat.t_id
    LEFT JOIN arp_naturreservate.reservate_zustaendiger
        ON reservate_zustaendiger.t_id = reservate_reservat_zustaendiger.zustaendiger
WHERE 
    ST_Intersects(reservate_teilgebiet.geometrie, hoheitsgrenzen_gemeindegrenze.geometrie) = TRUE
GROUP BY 
    reservate_reservat.t_id
;