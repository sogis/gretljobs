DELETE FROM agi_av_kaso_abgleich_pub.uebersicht_des_vergleichs
;

WITH 
    gemeinde AS (
        SELECT 
            t_id, 
            geometrie, 
            bfs_gemeindenummer, 
            gemeindename
        FROM 
            agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze
    ), 
    diff_av AS (
        SELECT 
            av.av_gem_bfs, 
            count(av.av_gem_bfs) AS anzahl
        FROM 
            agi_av_kaso_abgleich_pub.differenzen av
        WHERE 
            av.av_gem_bfs IS NOT NULL 
            AND 
            av.fehlerart <> 1
        GROUP BY 
            av.av_gem_bfs
    ), 
    diff_kaso AS (
        SELECT 
            kaso.kaso_bfs_nr, 
            count(kaso.kaso_bfs_nr) AS anzahl
        FROM 
            agi_av_kaso_abgleich_pub.differenzen kaso
        WHERE 
            kaso.kaso_bfs_nr IS NOT NULL 
            AND 
            kaso.fehlerart = 4
        GROUP BY 
            kaso.kaso_bfs_nr
    )
    
INSERT INTO agi_av_kaso_abgleich_pub.uebersicht_des_vergleichs (
    t_id,
    geometrie,
    gem_bfs,
    name,
    anzahl_differenzen
)
(
    SELECT 
        gemeinde.t_id, 
        gemeinde.geometrie, 
        gemeinde.bfs_gemeindenummer AS gem_bfs, 
        gemeinde.gemeindename AS name, 
        COALESCE(diff_av.anzahl, 0::bigint) + COALESCE(diff_kaso.anzahl, 0::bigint) AS anzahl_differenzen
    FROM 
        gemeinde
        LEFT JOIN diff_av 
            ON gemeinde.bfs_gemeindenummer = diff_av.av_gem_bfs
        LEFT JOIN diff_kaso 
            ON gemeinde.bfs_gemeindenummer = diff_kaso.kaso_bfs_nr
)
;