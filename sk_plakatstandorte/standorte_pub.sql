SELECT 
    gemeindename, 
    bfs_gemeindenummer, 
    auflagen, 
    standorte_erlaubt, 
    standorte_verboten, 
    plaene, 
    beschluss, 
    auflagen_kantonal, 
    geometrie
FROM 
    sk_plakatstandorte_staging_v1.standorte
;