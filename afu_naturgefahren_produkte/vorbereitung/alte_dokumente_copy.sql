with dokumente as (
    select 
        geometrie, 
        dokument as dokument_array,
        json_array_elements(dokument::json) as dokument,
        case
        	when (ik_wasser = true) or (ik_hangm = true) or (gk_wasser = true) or (gk_hangm = true) 
        	then 'Wasser' 
        end as hauptprozess_wasser, 
        case 
        	when (ik_sturz = true) or (gk_sturz = true) 
        	then 'Sturz' 
        end as hauptprozess_sturz,
        case 
        	when (ik_abs_ein = true) or (gk_abs_ein = true)
        	then 'Absenkung/Einsturz' 
        end as hauptprozess_absenkung_einsturz,
        case 
        	when (ik_ru_spon = true) or (ik_ru_kont = true) or (gk_ru_spon = true) or (gk_ru_kont = true) 
        	then 'Rutschung' 
        end as hauptprozess_rutschung, 
        left(right((json_array_elements(dokument::json) ->'name')::text,9),4) as jahr
    from 
        afu_gefahrenkartierung_pub.gefahrenkartirung_perimeter_gefahrenkartierung_v
),

gemeinden as (
    select
        gemeindename,
        geometrie, 
        bfs_gemeindenummer
    from 
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze
)

select 
    gemeinden.bfs_gemeindenummer as gemeinde_bfsnr, 
    gemeinden.gemeindename as gemeinde_name,
    json_build_object('@type', 'SO_AFU_Naturgefahren_Kernmodell_20231016.Naturgefahren.Dokument',
                      'Titel', dokument->'name', 
                      'Dateiname', dokument->'name', 
                      'Link', dokument->'url',
                      'Hauptprozesse', concat_ws(', ', hauptprozess_wasser, hauptprozess_sturz, hauptprozess_absenkung_einsturz, hauptprozess_rutschung),
                      'Jahr', jahr
                      ) as dokument,
   gemeinden.geometrie as geometrie
from 
    dokumente 
left join 
    gemeinden 
    on 
    st_dwithin(st_buffer(dokumente.geometrie,-1),gemeinden.geometrie,0)
