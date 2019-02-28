WITH documents_richtplan AS (
    SELECT DISTINCT
        titel,
        publiziertAb,
        bemerkung,
        richtplankarte_ueberlagernde_flaeche.t_id AS ueberlagernde_flaeche_id,
        dateipfad AS dokumente
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
        array_to_json(array_agg(row_to_json(documents_richtplan)))::text AS dokumente,
        ueberlagernde_flaeche_id
    FROM 
        documents_richtplan
    GROUP BY 
        ueberlagernde_flaeche_id
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
   string_agg(DISTINCT hoheitsgrenzen_gemeindegrenze.gemeindename, ', ' ORDER BY hoheitsgrenzen_gemeindegrenze.gemeindename) AS gemeindenamen
FROM
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze,
    arp_richtplan.richtplankarte_ueberlagernde_flaeche
    LEFT JOIN documents_json_richtplan
        ON documents_json_richtplan.ueberlagernde_flaeche_id = richtplankarte_ueberlagernde_flaeche.t_id
WHERE
    ST_Intersects(richtplankarte_ueberlagernde_flaeche.geometrie, hoheitsgrenzen_gemeindegrenze.geometrie) = TRUE
GROUP BY
    richtplankarte_ueberlagernde_flaeche.t_id,
    documents_json_richtplan.dokumente
;