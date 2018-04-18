SELECT
    typ,
    CASE
        WHEN typ = 3
            THEN 'dem Wald überlagert'
        WHEN typ = 5
            THEN 'dem Landwirtschaftsgebiet überlagert'
    END AS typ_txt,
    gid AS t_id,
    flaeche,
    ST_Multi(geometrie) AS geometrie
FROM
    arp_richtplan_2017.juraschutz
;