SELECT
    typ,
    gid AS t_id,
    flaeche,
    ST_Multi(geometrie) AS geometrie
FROM
    arp_richtplan_2017.juraschutz
;