SELECT
    id AS t_id,
    nummer,
    "name",
    bedeutung,
    abstimmung,
    ST_Multi(geometrie) AS geometrie 
FROM
    arp_richtplan_2017.wildtierkorridor
;