WITH

dokument_poly AS (
    SELECT
        d.dateiname,
        d.titel,
        d.jahr,
        COALESCE(g.gemeindename, 'FEHLER: Ausserhalb Kanton') AS gemeindename,
        COALESCE(g.bfs_gemeindenummer, -99) AS bfs_gemeindenummer,
        COALESCE(g.geometrie, ST_Buffer(d.geometrie, 1500, 1)) AS geometrie
    FROM 
        afu_naturgefahren_alte_dokumente_v2.alte_dokumente d
    LEFT JOIN 
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze g ON ST_Intersects(d.geometrie, g.geometrie)
),

poly_dokumente AS ( 
    SELECT
        json_agg(
            json_build_object(
                '@type', 'SO_AFU_Naturgefahren_Publikation_20241025.Naturgefahren.Dokument',
                'Titel', titel, 
                'Dateiname', dateiname, 
                'Link', concat('https://geo.so.ch/docs/ch.so.afu.naturgefahren/', dateiname),
                'Hauptprozesse', 'obsolet',
                'Jahr', jahr
            )
        ) AS dokument,
        gemeindename AS gemeinde_name,
        bfs_gemeindenummer AS gemeinde_bfsnr,
        geometrie 
    FROM 
        dokument_poly
    GROUP BY 
        gemeindename,
        bfs_gemeindenummer,
        geometrie        
)

SELECT * FROM poly_dokumente