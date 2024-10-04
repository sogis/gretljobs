WITH http_dokument AS (
    SELECT
    	t_id,
    	titel,
    	dokument_beschreibung,
    	typ,
    	datum,
        concat(
            'https://geo.so.ch/docs/ch.so.afu.wasserversorgung/', 
            split_part(
                dateiname, 
                'ch.so.afu.wasserversorgung\', 
                2
            )
        ) AS dokumentimweb,
        'SO_AFU_Wasserbewirtschaftung_Publikation_20241001.Wasserbewirtschaftung.Dokument' as ili_type
    FROM 
        afu_wasserversorg_obj_v1.dokument d
),

dokumente_quelle_gefasst AS (
    SELECT
        qgd.quelle_gefasst_r,   
        array_to_json(
            array_agg(
                json_build_object(
                    '@type', d.ili_type,
                    'Titel', d.titel,
                    'Dokument_Beschreibung', d.dokument_beschreibung,
                    'Typ', d.typ,
                    'Datum', d.datum,
                    'DokumentImWeb', d.dokumentimweb
                )
            )
        )::jsonb AS dokumente
    FROM 
        http_dokument d
    JOIN
        afu_wasserversorg_obj_v1.quelle_gefasst__dokument qgd ON d.t_id = qgd.dokument_r
    GROUP BY
        quelle_gefasst_r
)

SELECT
    TRUE AS gefasst,
    'ja' AS gefasst_txt,
    NULL AS eigentuemer,
    minimale_schuettung AS min_schuettung,
    maximale_schuettung AS max_schuettung,
    zustand,
    zustand AS zustand_txt,
    schutzzone,
    schutzzone AS schutzzone_txt,
    CASE nutzungsart
        WHEN 'Oeffentliche_Fassung'
            THEN 'oeffentlich'
        WHEN 'Private_Fassung'
            THEN 'privat'
        WHEN 'Private_Fassung_von_oeffentlichem_Interesse'
            THEN 'privat_oeffentliches_Interesse'
        ELSE
            NULL
    END AS nutzungstyp,
    CASE nutzungsart
        WHEN 'Oeffentliche_Fassung'
            THEN 'öffentlich'
        WHEN 'Private_Fassung'
            THEN 'privat'
        WHEN 'Private_Fassung_von_oeffentlichem_Interesse'
            THEN 'privat öffentliches Interesse'
        ELSE
            NULL
    END nutzungstyp_txt,
    CASE verwendung 
        WHEN 'keine_Angabe'
            THEN NULL
        ELSE
            verwendung 
    END AS verwendungszweck,
    CASE verwendung 
        WHEN 'keine_Angabe'
            THEN NULL
        ELSE
            verwendung 
    END AS verwendungszweck_txt,
    CASE nutzungsart 
        WHEN 'Oeffentliche_Fassung'
            THEN 'Gefasste Quelle für die öffentliche Wasserversorgung'
        WHEN 'Private_Fassung'
            THEN 'Gefasste Quelle mit privater Nutzung'
        WHEN 'Private_Fassung_von_oeffentlichem_Interesse'
            THEN 'Gefasste Quelle mit privater Nutzung von öffentlichem Interesse'
        ELSE
            'Gefasste Quelle'
    END AS objekttyp_anzeige,
    bezeichnung AS objektname,
    objekt_id AS objektnummer,
    beschreibung AS technische_angabe,
    bemerkung,
    dqg.dokumente,
    geometrie
FROM
    afu_wasserversorg_obj_v1.quelle_gefasst
LEFT JOIN
    dokumente_quelle_gefasst dqg ON t_id = dqg.quelle_gefasst_r
;