WITH
dokumente_pre_process AS (
    SELECT 
        ST_Union(st_multi(geometrie)) AS geometrie,
        dokument,
        bool_or(ik_wasser) AS ik_wasser,
        bool_or(ik_sturz) AS ik_sturz, 
        bool_or(ik_abs_ein) AS ik_abs_ein,
        bool_or(ik_hangm) AS ik_hangm,
        bool_or(ik_ru_spon) AS ik_ru_spon, 
        bool_or(ik_ru_kont) AS ik_ru_kont,
        bool_or(gk_wasser) AS gk_wasser,
        bool_or(gk_sturz) AS gk_sturz,
        bool_or(gk_abs_ein) AS gk_abs_ein,
        bool_or(gk_hangm) AS gk_hangm,
        bool_or(gk_ru_spon) AS gk_ru_spon,
        bool_or(gk_ru_kont) AS gk_ru_kont 
    FROM 
        afu_gefahrenkartierung_pub.gefahrenkartirung_perimeter_gefahrenkartierung_v
    GROUP BY 
        dokument
)

,dokumente AS (
    SELECT 
        geometrie, 
        dokument AS dokument_array,
        json_array_elements(dokument::json) AS dokument,
        CASE
            WHEN (ik_wasser = true) or (ik_hangm = true) or (gk_wasser = true) or (gk_hangm = true) 
            THEN 'Wasser' 
        END AS hauptprozess_wasser, 
        CASE 
            WHEN (ik_sturz = true) or (gk_sturz = true) 
            THEN 'Sturz' 
        END AS hauptprozess_sturz,
        CASE 
            WHEN (ik_abs_ein = true) or (gk_abs_ein = true)
            THEN 'Absenkung/Einsturz' 
        END AS hauptprozess_absenkung_einsturz,
        CASE 
            WHEN (ik_ru_spon = true) or (ik_ru_kont = true) or (gk_ru_spon = true) or (gk_ru_kont = true) 
            THEN 'Rutschung' 
        END AS hauptprozess_rutschung, 
        left(right((json_array_elements(dokument::json) ->'name')::text,9),4) AS jahr
    FROM 
        dokumente_pre_process
)

,gemeinden AS (
    SELECT
        gemeindename,
        geometrie, 
        bfs_gemeindenummer
    FROM 
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze
)

SELECT 
    gemeinden.bfs_gemeindenummer AS gemeinde_bfsnr, 
    gemeinden.gemeindename AS gemeinde_name,
    json_build_object('@type', 'SO_AFU_Naturgefahren_Publikation_20240704.Naturgefahren.Dokument',
                      'Titel', dokument->'name', 
                      'Dateiname', dokument->'name', 
                      'Link', dokument->'url',
                      'Hauptprozesse', concat_ws(', ', hauptprozess_wasser, hauptprozess_sturz, hauptprozess_absenkung_einsturz, hauptprozess_rutschung),
                      'Jahr', jahr
                      ) AS dokument,
   gemeinden.geometrie AS geometrie
FROM 
    dokumente 
LEFT JOIN
    gemeinden 
    ON 
    ST_Dwithin(ST_Buffer(dokumente.geometrie,-10),gemeinden.geometrie,0)


