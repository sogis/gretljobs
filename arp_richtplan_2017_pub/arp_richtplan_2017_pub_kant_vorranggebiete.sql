SELECT
    ogc_fid AS t_id,
    o_art,
    "name",
    gebietsnum,
    nummer_geb,
    geometrie
FROM
    arp_richtplan_2017.kant_vorranggebiete
WHERE
    archive = 0
;