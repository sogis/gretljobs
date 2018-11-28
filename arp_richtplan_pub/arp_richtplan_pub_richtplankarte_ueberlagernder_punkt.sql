WITH documents AS (
    SELECT DISTINCT 
        titel, 
        publiziertAb, 
        bemerkung,
        richtplankarte_ueberlagernder_punkt.t_id AS ueberlagernder_punkt_id,
        dateipfad AS dokumente
    FROM 
        arp_richtplan.richtplankarte_ueberlagernder_punkt_dokument
        LEFT JOIN arp_richtplan.richtplankarte_dokument
            ON richtplankarte_dokument.t_id = richtplankarte_ueberlagernder_punkt_dokument.dokument
        RIGHT JOIN arp_richtplan.richtplankarte_ueberlagernder_punkt
            ON richtplankarte_ueberlagernder_punkt_dokument.ueberlagernder_punkt = richtplankarte_ueberlagernder_punkt.t_id
    WHERE
        (titel, publiziertab, bemerkung, dateipfad) IS NOT NULL
    
), documents_json AS (
    SELECT 
        array_to_json(array_agg(row_to_json(documents)))::text AS dokumente, 
        ueberlagernder_punkt_id
    FROM 
        documents
    GROUP BY 
        ueberlagernder_punkt_id
), ueberlagernde_punkte_mit_documents AS (
    SELECT
        richtplankarte_ueberlagernder_punkt.t_ili_tid,
        richtplankarte_ueberlagernder_punkt.objektname,
        richtplankarte_ueberlagernder_punkt.abstimmungskategorie,
        richtplankarte_ueberlagernder_punkt.bedeutung,
        richtplankarte_ueberlagernder_punkt.planungsstand,
        documents_json.dokumente,
        richtplankarte_ueberlagernder_punkt.status,
        richtplankarte_ueberlagernder_punkt.objekttyp,
        richtplankarte_ueberlagernder_punkt.spezifikation,
        richtplankarte_ueberlagernder_punkt.geometrie
    FROM
        arp_richtplan.richtplankarte_ueberlagernder_punkt
        LEFT JOIN documents_json
            ON richtplankarte_ueberlagernder_punkt.t_id = documents_json.ueberlagernder_punkt_id
)

SELECT
    ueberlagernde_punkte_mit_documents.t_ili_tid,
    ueberlagernde_punkte_mit_documents.objektname,
    ueberlagernde_punkte_mit_documents.abstimmungskategorie,
    ueberlagernde_punkte_mit_documents.bedeutung,
    ueberlagernde_punkte_mit_documents.planungsstand,
    ueberlagernde_punkte_mit_documents.dokumente,
    ueberlagernde_punkte_mit_documents.status,
    ueberlagernde_punkte_mit_documents.objekttyp,
    ueberlagernde_punkte_mit_documents.spezifikation,
    ueberlagernde_punkte_mit_documents.geometrie,
    swissboundaries3d_hoheitsgebiet.hoheitsgebietsname AS gemeindename
FROM
    ueberlagernde_punkte_mit_documents,
    agi_swissboundaries3d_pub.swissboundaries3d_hoheitsgebiet
WHERE
    ST_DWithin(ueberlagernde_punkte_mit_documents.geometrie, swissboundaries3d_hoheitsgebiet.geometrie, 0)
    AND
    ST_Within(ueberlagernde_punkte_mit_documents.geometrie, swissboundaries3d_hoheitsgebiet.geometrie)