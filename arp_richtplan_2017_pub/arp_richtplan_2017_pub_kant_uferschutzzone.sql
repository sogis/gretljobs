SELECT
    gid AS t_id,
    "__gid",
    ogc_fid,
    o_art,
    ST_Multi(geometrie) AS geometrie
FROM
    arp_richtplan_2017.kant_uferschutzzone
WHERE
    archive = 0
;