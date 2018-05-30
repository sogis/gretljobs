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
        av_gb_abgleich.differenzen differenzen_av
    WHERE 
        differenzen_av.av_gem_bfs IS NOT NULL
    GROUP BY 
        differenzen_av.av_gem_bfs
), 

diff_gb AS (
    SELECT 
        differenzen_gb.gb_gem_bfs, 
        count(differenzen_gb.gb_gem_bfs) AS anzahl
    FROM 
        av_gb_abgleich.differenzen differenzen_gb
    WHERE 
        differenzen_gb.gb_nummer::integer < 90000
    GROUP BY 
        differenzen_gb.gb_gem_bfs
)

SELECT 
    gemeinde.ogc_fid AS t_id, 
    gemeinde.geometrie, 
    gemeinde.gem_bfs, 
    gemeinde.name, 
    CASE
        WHEN (COALESCE(diff_av.anzahl, 0::bigint) + COALESCE(diff_gb.anzahl, 0::bigint)) = 0 
            THEN NULL::bigint
        ELSE COALESCE(diff_av.anzahl, 0::bigint) + COALESCE(diff_gb.anzahl, 0::bigint)
    END AS anzahl_differenzen
FROM 
    gemeinde
    LEFT JOIN diff_av 
        ON gemeinde.gem_bfs = diff_av.av_gem_bfs
    LEFT JOIN diff_gb 
        ON gemeinde.gem_bfs = diff_gb.gb_gem_bfs
;