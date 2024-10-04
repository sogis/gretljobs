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
    UNION ALL
    SELECT
    	t_id,
    	titel,
    	dokument_beschreibung,
    	typ,
    	datum,
        concat(
            'https://geo.so.ch/docs/ch.so.afu.grundwasserschutz/',
            split_part(
                dateiname, 
                'ch.so.afu.grundwasserschutz\', 
                2
            )
        ) AS dokumentimweb,
        'SO_AFU_Wasserbewirtschaftung_Publikation_20241001.Wasserbewirtschaftung.Dokument' as ili_type
    FROM 
        afu_grundwasserschutz_obj_v1.dokument d    
),

dokumente_sodbrunnen AS (
    SELECT
        sd.sodbrunnen_r,   
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
        afu_grundwasserschutz_obj_v1.sodbrunnen__dokument sd ON d.t_id = sd.dokument_r
    GROUP BY
        sodbrunnen_r
),

dokumente_filterbrunnen AS (
    SELECT
        fd.filterbrunnen_r,   
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
        afu_wasserversorg_obj_v1.filterbrunnen__dokument fd ON d.t_id = fd.dokument_r
    GROUP BY
        filterbrunnen_r
),

sodbrunnen AS (
    SELECT
        'Sodbrunnen' AS fassungstyp,
        konzessionsmenge,
        FALSE AS schutzzone,
        NULL AS nutzungstyp,
        verwendung AS verwendungszweck,
        'Sodbrunnen' AS objekttyp_anzeige,
        bezeichnung AS objektname,
        objekt_id AS objektnummer,
        beschreibung AS technische_angabe,
        bemerkung,
        ds.dokumente,
        geometrie
    FROM
        afu_grundwasserschutz_obj_v1.sodbrunnen
    LEFT JOIN
        dokumente_sodbrunnen ds ON t_id = ds.sodbrunnen_r
),

horizontalfilterbrunnen AS (
    SELECT 
        'Horizontalfilterbrunnen' AS fassungstyp,
        konzessionsmenge,
        schutzzone,
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
        verwendung AS verwendungszweck,
        CASE nutzungsart
            WHEN 'Oeffentliche_Fassung'
                THEN 'Horizontalfilterbrunnen für die öffentliche Wasserversorgung'
            WHEN 'Private_Fassung'
                THEN 'Horizontalfilterbrunnen mit privater Nutzung'
            WHEN 'Private_Fassung_von_oeffentlichem_Interesse'
                THEN 'Horizontalfilterbrunnen mit privater Nutzung von öffentlichem Interesse'
            ELSE
                'Horizontalfilterbrunnen'
        END AS objekttyp_anzeige,
        bezeichnung AS objektname,
        objekt_id AS objektnummer,
        beschreibung AS technische_angabe,
        bemerkung,
        df.dokumente,
        geometrie
    FROM
        afu_wasserversorg_obj_v1.filterbrunnen
    LEFT JOIN
        dokumente_filterbrunnen df ON t_id = df.filterbrunnen_r
    WHERE
        typ = 'horizontal'
),

vertikalfilterbrunnen AS (
    SELECT 
        'Vertikalfilterbrunnen' AS fassungstyp,
        konzessionsmenge,
        schutzzone,
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
        verwendung AS verwendungszweck,
        CASE nutzungsart
            WHEN 'Oeffentliche_Fassung'
                THEN 'Vertikalfilterbrunnen für die öffentliche Wasserversorgung'
            WHEN 'Private_Fassung'
                THEN 'Vertikalfilterbrunnen mit privater Nutzung'
            WHEN 'Private_Fassung_von_oeffentlichem_Interesse'
                THEN 'Vertikalfilterbrunnen mit privater Nutzung von öffentlichem Interesse'
            ELSE
                'Vertikalfilterbrunnen'
         END AS objekttyp_anzeige,
        bezeichnung AS objektname,
        objekt_id AS objektnummer,
        beschreibung AS technische_angabe,
        bemerkung,
        df.dokumente,
        geometrie
    FROM
        afu_wasserversorg_obj_v1.filterbrunnen
    LEFT JOIN
        dokumente_filterbrunnen df ON t_id = df.filterbrunnen_r
    WHERE
        typ = 'vertikal'
)

SELECT
    fassungstyp,
    fassungstyp AS fassungstyp_txt,
    konzessionsmenge,
    schutzzone,
    schutzzone AS schutzzone_txt,
    nutzungstyp,
    verwendungszweck,
    verwendungszweck AS verwendungszweck_txt,
    objekttyp_anzeige,
    objektname,
    objektnummer,
    technische_angabe,
    bemerkung,
    dokumente,
    geometrie
FROM
    sodbrunnen
    
UNION ALL

SELECT
    fassungstyp,
    fassungstyp AS fassungstyp_txt,
    konzessionsmenge,
    schutzzone,
    schutzzone AS schutzzone_txt,
    nutzungstyp,
    verwendungszweck,
    verwendungszweck AS verwendungszweck_txt,
    objekttyp_anzeige,
    objektname,
    objektnummer,
    technische_angabe,
    bemerkung,
    dokumente,
    geometrie
FROM
    horizontalfilterbrunnen

UNION ALL

SELECT
    fassungstyp,
    fassungstyp AS fassungstyp_txt,
    konzessionsmenge,
    schutzzone,
    schutzzone AS schutzzone_txt,
    nutzungstyp,
    verwendungszweck,
    verwendungszweck AS verwendungszweck_txt,
    objekttyp_anzeige,
    objektname,
    objektnummer,
    technische_angabe,
    bemerkung,
    dokumente,
    geometrie
FROM
    vertikalfilterbrunnen
;
