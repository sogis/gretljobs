WITH gemeinde AS (
    SELECT 
        gemeindegrenze.ogc_fid, 
        gemeindegrenze.geometrie, 
        gemeindegrenze.gem_bfs, 
        gemeinde.name
    FROM 
        av_avdpool_ng.gemeindegrenzen_gemeindegrenze gemeindegrenze
        LEFT JOIN av_avdpool_ng.gemeindegrenzen_gemeinde gemeinde 
            ON gemeindegrenze.gemeindegrenze_von::text = gemeinde.tid::text
), 

diff_av AS (
    SELECT 
        differenzen_av.av_gem_bfs, 
        count(differenzen_av.av_gem_bfs) AS anzahl
    FROM 
        av_kaso_abgleich.differenzen differenzen_av
    WHERE 
        differenzen_av.av_gem_bfs IS NOT NULL 
        AND 
        differenzen_av.fehlerart <> 1
    GROUP BY 
        differenzen_av.av_gem_bfs
), 

diff_kaso AS (
    SELECT 
        differenzen_kaso.kaso_bfs_nr, 
        count(differenzen_kaso.kaso_bfs_nr) AS anzahl
    FROM 
        av_kaso_abgleich.differenzen differenzen_kaso
    WHERE 
        differenzen_kaso.kaso_bfs_nr IS NOT NULL 
        AND 
        differenzen_kaso.fehlerart = 4
    GROUP BY 
        differenzen_kaso.kaso_bfs_nr
)

SELECT 
    gemeinde.ogc_fid AS t_id, 
    gemeinde.geometrie, 
    gemeinde.gem_bfs, 
    gemeinde.name, 
    COALESCE(diff_av.anzahl, 0::bigint) + COALESCE(diff_kaso.anzahl, 0::bigint) AS anzahl_differenzen
FROM 
    gemeinde
    LEFT JOIN diff_av 
        ON gemeinde.gem_bfs = diff_av.av_gem_bfs
    LEFT JOIN diff_kaso 
        ON gemeinde.gem_bfs = diff_kaso.kaso_bfs_nr
;