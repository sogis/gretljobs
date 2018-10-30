SELECT 
    CASE 
        WHEN (a."VOLPERSW~6") < 2001 
            THEN round(a."VOLPERSW~6",-1) 
        WHEN (a."VOLPERSW~6") > 2000 AND (a."VOLPERSW~6") < 20000 
            THEN round(a."VOLPERSW~6",-2)
        ELSE round(a."VOLPERSW~6",-3)
    END AS passagieranzahl_pro_werktag_2015, 
    CASE 
        WHEN (b."VOLPERSW~6") < 501 
            THEN round(b."VOLPERSW~6",-1) 
        ELSE round(b."VOLPERSW~6",-2) 
    END AS passagieranzahl_in_abendspitzen_2015, 
    CASE 
        WHEN (c."VOLPERSW~6") < 2001 
            THEN round(c."VOLPERSW~6",-1)
        WHEN (c."VOLPERSW~6") > 2000 AND (c."VOLPERSW~6") < 20000 
            THEN round(c."VOLPERSW~6",-2)
        ELSE round(c."VOLPERSW~6",-3) 
    END AS passagieranzahl_pro_werktag_2040, 
    CASE 
        WHEN (d."VOLPERSW~6") < 501 
            THEN round(d."VOLPERSW~6",-1)
        ELSE round(d."VOLPERSW~6",-2)
    END AS passagieranzahl_in_abendspitzen_2040, 
    CASE 
        WHEN a."TYPENO"::integer = 11 
            THEN 'Bahn'
        ELSE 
            'Bus'
    END AS streckentyp, 
    a.wkb_geometry AS geometrie
FROM 
    verkehrsmodell2015.gvm_so_2015_oev_dwv_2015_link a, 
    verkehrsmodell2015.gvm_so_2015_oev_asp_2015_link b, 
    verkehrsmodell2015.gvm_so_2015_oev_dwv_2040_link c, 
    verkehrsmodell2015.gvm_so_2015_oev_asp_2040_link d 
WHERE 
    a.gid = b.gid
    AND 
    a.gid = c.gid
    AND
    a.gid = d.gid