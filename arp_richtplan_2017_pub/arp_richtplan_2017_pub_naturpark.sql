SELECT
    bzrk_nr,
    bzrk_name,
    x_min,
    y_min,
    x_max,
    y_max,
    ogc_fid AS t_id,
    geometrie
FROM
    arp_richtplan_2017.naturpark
;