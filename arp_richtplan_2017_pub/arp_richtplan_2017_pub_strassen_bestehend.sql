SELECT
    objectid_1 AS t_id,
    objectid,
    objid,
    objectorig,
    objectval,
    CASE
        WHEN objectval = 'Autobahn'
            THEN 'Nationalstrasse bestehend: Autobahn'
        WHEN objectval = 'Autostr'
            THEN 'Nationalstrasse bestehend: Autostrasse'
        WHEN objectval = 'Autobahn Tunnel'
            THEN 'Nationalstrasse bestehend: Autobahn Tunnel'
    END AS objectval_txt,
    yearchange,
    constructi,
    objectname,
    length,
    fnode_,
    tnode_,
    lpoly_,
    rpoly_,
    d_autob_tr,
    d_autob__1,
    shape_leng,
    ST_Multi(geometrie) AS geometrie
FROM
    arp_richtplan_2017.strassen_bestehend
;