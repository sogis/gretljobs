SELECT 
    fila.objektart, 
    fila.fila, 
    gemeinde.bfs_gemeindenummer AS bfs_nummer, 
    gemeinde.gemeindename AS gemeinde, 
    fila.geometrie 
FROM 
    agem_fila.strassen_strassenachse fila 
    LEFT JOIN agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze gemeinde 
        ON ST_DWithin(fila.geometrie,gemeinde.geometrie,0)
WHERE 
    gemeinde.bfs_gemeindenummer IS NOT NULL 
;
