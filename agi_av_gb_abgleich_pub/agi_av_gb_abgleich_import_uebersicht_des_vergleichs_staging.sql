DELETE FROM agi_av_gb_abgleich_import.uebersicht_des_vergleichs_staging
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
            av_gem_bfs, 
            count(av_gem_bfs) AS anzahl
        FROM 
            agi_av_gb_abgleich_import.differenzen_staging
        WHERE 
            av_gem_bfs IS NOT NULL
        GROUP BY 
            av_gem_bfs
    ), 
    diff_gb AS (
        SELECT 
            gb_gem_bfs, 
            count(gb_gem_bfs) AS anzahl
        FROM 
            agi_av_gb_abgleich_import.differenzen_staging
        WHERE 
            gb_nummer::integer < 90000
        GROUP BY 
            gb_gem_bfs
    )

INSERT INTO agi_av_gb_abgleich_import.uebersicht_des_vergleichs_staging (
    t_id,
    geometrie,
    gem_bfs,
    name,
    anzahl_differenzen
)
SELECT 
    gemeinde.t_id, 
    gemeinde.geometrie, 
    gemeinde.bfs_gemeindenummer, 
    gemeinde.gemeindename, 
    COALESCE(diff_av.anzahl, 0::bigint) + COALESCE(diff_gb.anzahl, 0::bigint) AS anzahl_differenzen
FROM 
    gemeinde
    LEFT JOIN diff_av 
        ON gemeinde.bfs_gemeindenummer = diff_av.av_gem_bfs
    LEFT JOIN diff_gb 
        ON gemeinde.bfs_gemeindenummer = diff_gb.gb_gem_bfs
;