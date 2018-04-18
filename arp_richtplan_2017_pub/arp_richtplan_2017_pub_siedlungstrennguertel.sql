SELECT
    ogc_fid AS t_id,
    gid,
    o_art,
    CASE 
        WHEN o_art = 30601
            THEN 'von kantonaler Bedeutung'
        WHEN o_art = 30602
            THEN 'von regionaler Bedeutung'
    END AS o_art_txt,
    geometrie
FROM
    arp_richtplan_2017.siedlungstrennguertel
;