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
            agi_av_gb_abgleich_import.differenzen_staging AS av
        WHERE 
            av.av_gem_bfs IS NOT NULL 
            AND 
            av.fehlerart <> 1
        GROUP BY 
            av.av_gem_bfs
), 
    diff_gb AS (
        SELECT 
            gb.gb_gem_bfs, 
            count(gb.gb_gem_bfs) AS anzahl
        FROM 
            agi_av_gb_abgleich_import.differenzen_staging AS gb
        WHERE 
            gb.gb_gem_bfs IS NOT NULL 
            AND 
            gb.fehlerart = 4
        GROUP BY 
            gb.gb_gem_bfs
)

INSERT INTO agi_av_gb_abgleich_import.uebersicht_des_vergleichs_staging (
    t_id,
    geometrie,
    gem_bfs,
    aname,
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
