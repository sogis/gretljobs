SELECT 
    a."VOLPERSW~6" AS passagieranzahl_pro_werktag_2015, 
    b."VOLPERSW~6" AS passagieranzahl_in_abendspitzen_2015, 
    c."VOLPERSW~6" AS passagieranzahl_pro_werktag_2040, 
    d."VOLPERSW~6" AS passagieranzahl_in_abendspitzen_2040, 
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