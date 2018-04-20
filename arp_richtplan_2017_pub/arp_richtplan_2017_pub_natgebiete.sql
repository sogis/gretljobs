SELECT
    ogc_fid AS t_id,
    o_art,
    "name",
    nr,
    ST_Multi(geometrie) AS geometrie
FROM
    arp_richtplan_2017.natgebiete
WHERE
    archive = 0
;