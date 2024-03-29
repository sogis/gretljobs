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
        bfs_gemeindenummer,
        gemeindename
    FROM
        afu_gepgwp_v1.gepgwp_gepgwp AS gepgwp
    WHERE archiviert = 'false'
),

bfs_gepgwp_json_dokument_agg AS (
    SELECT
        bfs_gemeindenummer,
        gemeindename,
        geometrie,
        '[' || dokumente::varchar || ']' AS dokumente
    FROM
    (
        SELECT
            gemgrenze.bfs_gemeindenummer,
            gemeindename,
            gemgrenze.geometrie,
            string_agg(json_dok, ',') AS dokumente
        FROM
            json_documents
            LEFT JOIN afu_gepgwp_v1.gepgwp_gemgrenze AS gemgrenze
            ON gemgrenze.bfs_gemeindenummer = json_documents.bfs_gemeindenummer
        GROUP BY
        gemgrenze.bfs_gemeindenummer, gemgrenze.geometrie, gemeindename
    ) AS a
)

SELECT 
    dokument.bfs_gemeindenummer, 
    gemeindename,
    geometrie, 
    dokumente::json AS dokumente 
FROM bfs_gepgwp_json_dokument_agg AS dokument
