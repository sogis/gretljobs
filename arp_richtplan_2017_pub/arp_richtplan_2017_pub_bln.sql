SELECT
    gid AS t_id,
    ogc_fid,
    obj_nr,
    fl_obj,
    "name",
    "version",
    o_art,
    geometrie
FROM 
    arp_richtplan_2017.bln
WHERE
    archive = 0
;