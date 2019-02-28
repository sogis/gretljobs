WITH documents AS (
    SELECT DISTINCT
        titel,
        publiziertAb,
        bemerkung,
        richtplankarte_grundnutzung.t_id AS grundnutzung_id,
        dateipfad AS dokumente
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
        array_to_json(array_agg(row_to_json(documents)))::text AS dokumente, 
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

