WITH documents AS (
    SELECT DISTINCT
        richtplankarte_dokument.t_id,
        richtplankarte_dokument.t_ili_tid,
        richtplankarte_dokument.titel,
        richtplankarte_dokument.publiziertAb,
        richtplankarte_dokument.bemerkung,
        CASE
            WHEN position('/opt/sogis_pic/documents/ch.so.arp.richtplan/' IN richtplankarte_dokument.dateipfad) != 0
                THEN 'https://geo.so.ch/docs/' || split_part(richtplankarte_dokument.dateipfad, '/documents/', 2)
            WHEN position('opt/sogis_pic/daten_aktuell/arp/Zonenplaene/Zonenplaene_pdf/' IN richtplankarte_dokument.dateipfad) != 0
                THEN 'https://geo.so.ch/docs/ch.so.arp.zonenplaene/' || split_part(richtplankarte_dokument.dateipfad, '/Zonenplaene/', 2)
        END AS dokument,
        richtplankarte_grundnutzung.t_id AS grundnutzung_id
    FROM 
        arp_richtplan.richtplankarte_grundnutzung_dokument
        LEFT JOIN arp_richtplan.richtplankarte_dokument
            ON richtplankarte_dokument.t_id = richtplankarte_grundnutzung_dokument.dokument
        RIGHT JOIN arp_richtplan.richtplankarte_grundnutzung
            ON richtplankarte_grundnutzung_dokument.grundnutzung = richtplankarte_grundnutzung.t_id
    WHERE
        (titel, publiziertab, bemerkung, dateipfad) IS NOT NULL
), documents_json AS (
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
        grundnutzung_id
    FROM 
        documents
    GROUP BY 
        grundnutzung_id
)

SELECT
    richtplankarte_grundnutzung.t_ili_tid,
    richtplankarte_grundnutzung.abstimmungskategorie,
    richtplankarte_grundnutzung.grundnutzungsart,
    richtplankarte_grundnutzung.planungsstand,
    richtplankarte_grundnutzung.geometrie,
    documents_json.dokumente AS dokumente
FROM
    arp_richtplan.richtplankarte_grundnutzung
    LEFT JOIN documents_json
        ON documents_json.grundnutzung_id = richtplankarte_grundnutzung.t_id
WHERE
    richtplankarte_grundnutzung.planungsstand IN ('rechtsgueltig', 'in_Auflage')
;