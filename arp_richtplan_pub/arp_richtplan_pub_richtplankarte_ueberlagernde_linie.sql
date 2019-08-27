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
        richtplankarte_ueberlagernde_linie.t_id AS ueberlagernder_linie_id
    FROM 
        arp_richtplan.richtplankarte_ueberlagernde_linie_dokument
        LEFT JOIN arp_richtplan.richtplankarte_dokument
            ON richtplankarte_dokument.t_id = richtplankarte_ueberlagernde_linie_dokument.dokument
        RIGHT JOIN arp_richtplan.richtplankarte_ueberlagernde_linie
            ON richtplankarte_ueberlagernde_linie_dokument.ueberlagernde_linie = richtplankarte_ueberlagernde_linie.t_id
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
        ueberlagernder_linie_id
    FROM 
        documents
    GROUP BY 
        ueberlagernder_linie_id
)

SELECT
    richtplankarte_ueberlagernde_linie.t_ili_tid,
    richtplankarte_ueberlagernde_linie.objektname,
    richtplankarte_ueberlagernde_linie.abstimmungskategorie,
    richtplankarte_ueberlagernde_linie.bedeutung,
    richtplankarte_ueberlagernde_linie.planungsstand,
    documents_json.dokumente,
    richtplankarte_ueberlagernde_linie.status,
    richtplankarte_ueberlagernde_linie.objektnummer,
    richtplankarte_ueberlagernde_linie.objekttyp,
    richtplankarte_ueberlagernde_linie.geometrie
FROM
    arp_richtplan.richtplankarte_ueberlagernde_linie
    LEFT JOIN documents_json
            ON richtplankarte_ueberlagernde_linie.t_id = documents_json.ueberlagernder_linie_id
WHERE
    richtplankarte_ueberlagernde_linie.planungsstand IN ('rechtsgueltig', 'in_Auflage')
;
