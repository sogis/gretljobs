DELETE FROM 
    sk_plakatstandorte_staging_v1.standorte
;

INSERT INTO 
    sk_plakatstandorte_staging_v1.standorte (
        gemeindename, 
        bfs_gemeindenummer, 
        auflagen, 
        standorte_erlaubt, 
        standorte_verboten, 
        plaene, 
        beschluss, 
        auflagen_kantonal, 
        geometrie
    )
SELECT 
    gemeindegrenze.gemeindename AS gemeindename, 
    gemeindegrenze.bfs_gemeindenummer, 
    auflagen, 
    standorte_erlaubt, 
    standorte_verboten, 
    plaene, 
    beschluss, 
    auflagen_kantonal,
    gemeindegrenze.geometrie AS geometrie
FROM 
    sk_plakatstandorte_v1.standorte standorte
LEFT JOIN 
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze gemeindegrenze 
    ON 
    gemeindegrenze.bfs_gemeindenummer = standorte.bfs_gemeindenummer 
;