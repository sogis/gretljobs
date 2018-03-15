SELECT
    gid AS t_id,
    typ,
    ST_Multi(geometrie) AS geometrie 
FROM
    arp_richtplan_2017.grundnutzung_version
;