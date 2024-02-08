with dokumente as (
    select 
        geometrie, 
        dokument as dokument_array,
        json_array_elements(dokument::json) as dokument
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
                      'Hauptprozesse', 'nicht definiert',
                      'Jahr', 'nicht definiert'
                      ) as dokument,
   gemeinden.geometrie as geometrie
from 
    dokumente 
left join 
    gemeinden 
    on 
    st_dwithin(dokumente.geometrie,gemeinden.geometrie,0)