SELECT
    ogc_fid AS t_id,
    o_art,
    "name"
    geometrie
FROM
    arp_richtplan_2017.sondernutzungsgebiet
WHERE
    archive = 0
;