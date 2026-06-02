SELECT 
    CONCAT(ort.ortschaftsname, '.', ms.strassenname) AS id,
    plz.plz,
    ort.ortschaftsname AS ortschaft,
    ms.bfs_nr AS gem_bfs,
    ms.strassenname,
    st_linemerge(st_union(ms.geometrie)) AS geometrie,
    0 AS ESID
FROM agi_mopublic_pub.mopublic_strassenachse ms
     JOIN agi_plz_ortschaften_pub.plzortschaften_postleitzahl plz ON st_coveredby(ms.geometrie, plz.geometrie)
     JOIN agi_plz_ortschaften_pub.plzortschaften_ortschaft ort ON st_coveredby(ms.geometrie, ort.geometrie)
GROUP BY 
    plz.plz, 
    ort.ortschaftsname, 
    ms.strassenname, 
    ms.bfs_nr;
;
