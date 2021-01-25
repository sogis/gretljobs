DELETE FROM agi_av_kaso_abgleich_import.uebersicht_des_vergleichs_staging
;

WITH 
    gemeinde AS (
        SELECT 
            gemeindegrenze.t_id, 
            gemeindegrenze.geometrie, 
            CAST(SUBSTRING(gemeindegrenze.t_datasetname,1,4) AS integer) AS bfs_gemeindenummer, 
            gemeinde.aname AS gemeindename
        FROM 
            agi_dm01avso24.gemeindegrenzen_gemeindegrenze AS gemeindegrenze
            LEFT JOIN agi_dm01avso24.gemeindegrenzen_gemeinde AS gemeinde
                ON gemeinde.t_id = gemeindegrenze.gemeindegrenze_von
    ), 
    diff_av AS (
        SELECT 
            av.av_gem_bfs, 
            count(av.av_gem_bfs) AS anzahl
        FROM 
            agi_av_kaso_abgleich_import.differenzen_staging AS av
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
            agi_av_kaso_abgleich_import.differenzen_staging AS kaso
        WHERE 
            kaso.kaso_bfs_nr IS NOT NULL 
            AND 
            kaso.fehlerart = 4
        GROUP BY 
            kaso.kaso_bfs_nr
    )
    
INSERT INTO agi_av_kaso_abgleich_import.uebersicht_des_vergleichs_staging (
    t_id,
    geometrie,
    gem_bfs,
    aname,
    anzahl_differenzen
)
(
    SELECT 
        gemeinde.t_id, 
        ST_Multi(ST_CurveToLine(gemeinde.geometrie, 0.002, 1, 1)) AS geometrie,
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
