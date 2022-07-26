WITH json_documents AS (
    SELECT
    (
    row_to_json
    ((
        SELECT
            docs
        FROM
        (
            SELECT
                art AS "Planart",
                gebiet AS "Planbezeichnung",
                rrbnr AS "RRBNr",
                rrbdatum AS "RRBDatum",
                plandatum AS "PlanDatum",
                plannr AS "PlanNr",
                link AS "Link",
               'SO_AFU_GEPGWP_Publikation_20220725.GEPGWP.Dokument' AS "@type"

        ) docs
    ))
    )::text AS json_dok,
        t_id,
        bfs_gemeindenummer
    FROM
        afu_gepgwp_v1.gepgwp_gepgwp AS gepgwp
),

bfs_gepgwp_json_dokument_agg AS (
    SELECT
        bfs_gemeindenummer,
        geometrie,
        '[' || dokumente::varchar || ']' AS dokumente
    FROM
    (
        SELECT
            gemgrenze.bfs_gemeindenummer,
            gemgrenze.geometrie,
            string_agg(json_dok, ',') AS dokumente
        FROM
            json_documents
            LEFT JOIN afu_gepgwp_v1.gepgwp_gemgrenze AS gemgrenze
            ON gemgrenze.bfs_gemeindenummer = json_documents.bfs_gemeindenummer
        GROUP BY
        gemgrenze.bfs_gemeindenummer, gemgrenze.geometrie
    ) AS a
)

SELECT 
    dokument.bfs_gemeindenummer, 
    gepgwp.gemeindename,
    geometrie, 
    dokumente::json AS dokumente 
FROM bfs_gepgwp_json_dokument_agg AS dokument
    LEFT JOIN afu_gepgwp_v1.gepgwp_gepgwp AS gepgwp
    ON gepgwp.bfs_gemeindenummer = dokument.bfs_gemeindenummer
WHERE gepgwp.archiviert = 'false'
