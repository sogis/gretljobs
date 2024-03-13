WITH

id_documents AS (
    SELECT
        nd.t_id AS t_id_documents_new,
        od.t_id AS t_id_documents_old
    FROM
        arp_richtplan_v2.richtplankarte_dokument AS nd,
        arp_richtplan_v1.richtplankarte_dokument AS od
    WHERE
        nd.titel = od.titel
),

id_points AS (
    SELECT
        np.t_id AS t_id_points_new,
        op.t_id AS t_id_points_old
    FROM
        arp_richtplan_v2.richtplankarte_ueberlagernder_punkt AS np,
        arp_richtplan_v1.richtplankarte_ueberlagernder_punkt AS op
    WHERE 
        np.geometrie = op.geometrie 
),

documents_points AS (
    SELECT 
        rupd.dokument,
        id.t_id_documents_new,
        rupd.ueberlagernder_punkt,
        ip.t_id_points_new
    FROM
        arp_richtplan_v1.richtplankarte_ueberlagernder_punkt_dokument AS rupd,
        id_documents AS id,
        id_points AS ip
    WHERE
        rupd.dokument = id.t_id_documents_old
        AND 
        rupd.ueberlagernder_punkt = ip.t_id_points_old
)



SELECT
    *
FROM
    documents_points
