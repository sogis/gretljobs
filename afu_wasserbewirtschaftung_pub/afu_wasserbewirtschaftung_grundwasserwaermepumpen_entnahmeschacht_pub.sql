WITH

http_dokument AS (
    SELECT
        concat(
            'https://geo.so.ch/docs/ch.so.afu.grundwasserschutz/', 
            split_part(
                dateiname, 
                'ch.so.afu.grundwasserschutz\', 
                2
            )
        ) AS url,
        t_id
    FROM 
        afu_grundwasserschutz_obj_v1.dokument d    
),

dokumente_grundwasserwaermepumpe AS(
    SELECT
        gd.grundwasserwaermepumpe_r, 
        json_agg(d.url ORDER BY url) AS dokumente
    FROM 
        http_dokument d
    JOIN
        afu_grundwasserschutz_obj_v1.grundwasserwaermepumpe__dokument gd ON d.t_id = gd.dokument_r
    GROUP BY
        grundwasserwaermepumpe_r 
)


SELECT 
    CASE
        WHEN aufnahmedatum >= current_date - INTERVAL '5 years' AND zustand = 'Voranfrage'
            THEN 'neue_Voranfrage'
        WHEN aufnahmedatum < current_date - INTERVAL '5 years' AND zustand = 'Voranfrage'
            THEN 'alte_Voranfrage'
        WHEN schachttyp != 'Rueckgabe' AND zustand != 'Voranfrage'
            THEN 'bewilligt'
        ELSE 
            'unbekannter_Verfahrensstand'
    END AS verfahrensstand,
    'Grundwasserwärmepumpen Entnahmeschacht' AS objekttyp_anzeige,
    bezeichnung AS objektname,
    objekt_id AS objektnummer,
    beschreibung AS technische_angabe,
    bemerkung,
    dokumente,
    geometrie
FROM
    afu_grundwasserschutz_obj_v1.grundwasserwaermepumpe
LEFT JOIN
    dokumente_grundwasserwaermepumpe dg ON t_id = dg.grundwasserwaermepumpe_r
WHERE
    schachttyp != 'Rueckgabe'
;