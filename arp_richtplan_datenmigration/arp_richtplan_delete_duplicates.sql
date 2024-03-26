WITH

duplicates_d_uf AS (
    SELECT t_id,
        ROW_NUMBER() OVER(PARTITION by dokument, ueberlagernde_flaeche ORDER BY t_id) AS rn 
    FROM arp_richtplan_v2.richtplankarte_ueberlagernde_flaeche_dokument
)

DELETE FROM 
    arp_richtplan_v2.richtplankarte_ueberlagernde_flaeche_dokument
WHERE
    t_id IN(
        SELECT
            t_id
        FROM
            duplicates_d_uf WHERE rn > 1
)
;

WITH

duplicates_d_ul AS (
    SELECT t_id,
        ROW_NUMBER() OVER(PARTITION by dokument, ueberlagernde_linie ORDER BY t_id) AS rn 
    FROM arp_richtplan_v2.richtplankarte_ueberlagernde_linie_dokument
)

DELETE FROM 
    arp_richtplan_v2.richtplankarte_ueberlagernde_linie_dokument
WHERE
    t_id IN(
        SELECT
            t_id
        FROM
            duplicates_d_ul WHERE rn > 1
)
;

WITH

duplicates_d_up AS (
    SELECT t_id,
        ROW_NUMBER() OVER(PARTITION by dokument, ueberlagernder_punkt ORDER BY t_id) AS rn 
    FROM arp_richtplan_v2.richtplankarte_ueberlagernder_punkt_dokument
)

DELETE FROM 
    arp_richtplan_v2.richtplankarte_ueberlagernder_punkt_dokument
WHERE
    t_id IN(
        SELECT
            t_id
        FROM
            duplicates_d_up WHERE rn > 1
)
;