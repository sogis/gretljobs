SELECT
    ogc_fid AS t_id,
    o_art,
    geometrie
FROM
    arp_richtplan_2017.witischutzzone
WHERE
    archive = 0
;