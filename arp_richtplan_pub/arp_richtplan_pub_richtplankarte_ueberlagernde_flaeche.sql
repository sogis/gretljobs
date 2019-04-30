WITH documents_richtplan AS (
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
        END AS dokument
    FROM 
        arp_richtplan.richtplankarte_ueberlagernde_flaeche_dokument
        LEFT JOIN arp_richtplan.richtplankarte_dokument
            ON richtplankarte_dokument.t_id = richtplankarte_ueberlagernde_flaeche_dokument.dokument
        RIGHT JOIN arp_richtplan.richtplankarte_ueberlagernde_flaeche
            ON richtplankarte_ueberlagernde_flaeche_dokument.ueberlagernde_flaeche = richtplankarte_ueberlagernde_flaeche.t_id
    WHERE
        (titel, publiziertab, bemerkung, dateipfad) IS NOT NULL
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
        arp_richtplan.richtplankarte_ueberlagernde_flaeche
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
    richtplankarte_ueberlagernde_flaeche.status,
    richtplankarte_ueberlagernde_flaeche.geometrie,
    documents_json_richtplan.dokumente,
    betroffene_gemeinden.gemeindenamen
FROM
    arp_richtplan.richtplankarte_ueberlagernde_flaeche
    LEFT JOIN documents_json_richtplan
        ON documents_json_richtplan.ueberlagernde_flaeche_id = richtplankarte_ueberlagernde_flaeche.t_id
    LEFT JOIN betroffene_gemeinden
        ON betroffene_gemeinden.t_id = richtplankarte_ueberlagernde_flaeche.t_id
WHERE
    richtplankarte_ueberlagernde_flaeche.planungsstand IN ('rechtsgueltig', 'in_Auflage')
;