WITH http_dokument AS (
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

dokumente_baggerschlitz AS (
    SELECT
        bd.baggerschlitz_r,   
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
        afu_grundwasserschutz_obj_v1.baggerschlitz__dokument bd  ON d.t_id = bd.dokument_r
    GROUP BY
        baggerschlitz_r
),

dokumente_bohrung AS (
    SELECT
        bd.bohrung_r,   
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
        afu_grundwasserschutz_obj_v1.bohrung__dokument bd  ON d.t_id = bd.dokument_r
    GROUP BY
        bohrung_r
),

dokumente_einbaute AS (
    SELECT
        ed.einbaute_r,   
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
        afu_grundwasserschutz_obj_v1.einbaute__dokument ed  ON d.t_id = ed.dokument_r
    GROUP BY
        einbaute_r
),

dokumente_grundwasserwaermepumpe AS (
    SELECT
        gd.grundwasserwaermepumpe_r,   
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
        afu_grundwasserschutz_obj_v1.grundwasserwaermepumpe__dokument gd  ON d.t_id = gd.dokument_r
    GROUP BY
        grundwasserwaermepumpe_r
),

dokumente_piezometer AS (
    SELECT
        pd.piezometer_gerammt_r,   
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
        afu_grundwasserschutz_obj_v1.piezometer__dokument pd  ON d.t_id = pd.dokument_r
    GROUP BY
        piezometer_gerammt_r
),

baggerschlitz AS (
    SELECT 
        'Grundwasserbeobachtung.Sondierung.Baggerschlitz' AS objektart,
        baugk_geschaeft,
        'Sondierungsbaggerschlitz' AS objekttyp_anzeige,
        bezeichnung AS objektname,
        objekt_id AS objektnummer,
        beschreibung AS technische_angabe,
        bemerkung,
        db.dokumente,
        geometrie
    FROM
        afu_grundwasserschutz_obj_v1.baggerschlitz
    LEFT JOIN
        dokumente_baggerschlitz db ON t_id = db.baggerschlitz_r
),

sondierungsbohrung AS (
    SELECT 
        'Grundwasserbeobachtung.Sondierung.Bohrung' AS objektart,
        baugk_geschaeft,
        'Sondierungsbohrung' AS objekttyp_anzeige,
        bezeichnung AS objektname,
        objekt_id AS objektnummer,
        beschreibung AS technische_angabe,
        bemerkung,
        db.dokumente,
        geometrie
    FROM
        afu_grundwasserschutz_obj_v1.bohrung
    LEFT JOIN
        dokumente_bohrung db ON t_id = db.bohrung_r
    WHERE
        piezometer = FALSE
),

piezometerbohrung AS (
    SELECT 
        'Grundwasserbeobachtung.Piezometer.Bohrung' AS objektart,
        baugk_geschaeft,
        'Bohrung mit Piezometer' AS objekttyp_anzeige,
        bezeichnung AS objektname,
        objekt_id AS objektnummer,
        beschreibung AS technische_angabe,
        bemerkung,
        db.dokumente,
        geometrie
    FROM
        afu_grundwasserschutz_obj_v1.bohrung
    LEFT JOIN
        dokumente_bohrung db ON t_id = db.bohrung_r
    WHERE
        piezometer = TRUE
),

einbaute AS (
    SELECT 
        'weitere_Einbauten' AS objektart,
        baugk_geschaeft,
        'Weitere Einbauten' AS objekttyp_anzeige,
        bezeichnung AS objektname,
        objekt_id AS objektnummer,
        beschreibung AS technische_angabe,
        bemerkung,
        de.dokumente,
        geometrie
    FROM
        afu_grundwasserschutz_obj_v1.einbaute
    LEFT JOIN
        dokumente_einbaute de ON t_id = de.einbaute_r
),

versickerungsschacht AS (
    SELECT 
        'Versickerungsschacht' AS objektart,
        baugk_geschaeft,
        'Versickerungsschacht' AS objekttyp_anzeige,
        bezeichnung AS objektname,
        objekt_id AS objektnummer,
        beschreibung AS technische_angabe,
        bemerkung,
        dg.dokumente,
        geometrie
    FROM
        afu_grundwasserschutz_obj_v1.grundwasserwaermepumpe
    LEFT JOIN
        dokumente_grundwasserwaermepumpe dg ON t_id = dg.grundwasserwaermepumpe_r
    WHERE
        schachttyp = 'Rueckgabe'
),

piezometer_gerammt AS (
    SELECT 
        'Grundwasserbeobachtung.Piezometer.Gerammt' AS objektart,
        -- Fuer Piezometer gerammt gibt es keine BauGK Geschäftsnummer
        NULL AS baugk_geschaeft,
        'Piezometer gerammt' AS objekttyp_anzeige,
        bezeichnung AS objektname,
        objekt_id AS objektnummer,
        beschreibung AS technische_angabe,
        bemerkung,
        dpg.dokumente,
        geometrie
    FROM
        afu_grundwasserschutz_obj_v1.piezometer_gerammt
    LEFT JOIN
        dokumente_piezometer dpg ON t_id = dpg.piezometer_gerammt_r
)

SELECT
    objektart,
    objektart AS objektart_txt,
    baugk_geschaeft,
    objekttyp_anzeige,
    objektname,
    objektnummer,
    technische_angabe,
    bemerkung,
    dokumente,
    geometrie
FROM
    baggerschlitz
    
UNION ALL

SELECT
    objektart,
    objektart AS objektart_txt,
    baugk_geschaeft,
    objekttyp_anzeige,
    objektname,
    objektnummer,
    technische_angabe,
    bemerkung,
    dokumente,
    geometrie
FROM
    sondierungsbohrung
    
UNION ALL
    
SELECT
    objektart,
    objektart AS objektart_txt,
    baugk_geschaeft,
    objekttyp_anzeige,
    objektname,
    objektnummer,
    technische_angabe,
    bemerkung,
    dokumente,
    geometrie
FROM
    piezometerbohrung
        
UNION ALL

SELECT
    objektart,
    objektart AS objektart_txt,
    baugk_geschaeft,
    objekttyp_anzeige,
    objektname,
    objektnummer,
    technische_angabe,
    bemerkung,
    dokumente,
    geometrie
FROM
    einbaute
    
UNION ALL

SELECT
    objektart,
    objektart AS objektart_txt,
    baugk_geschaeft,
    objekttyp_anzeige,
    objektname,
    objektnummer,
    technische_angabe,
    bemerkung,
    dokumente,
    geometrie
FROM
    versickerungsschacht

UNION ALL

SELECT
    objektart,
    objektart AS objektart_txt,
    baugk_geschaeft,
    objekttyp_anzeige,
    objektname,
    objektnummer,
    technische_angabe,
    bemerkung,
    dokumente,
    geometrie
FROM
    piezometer_gerammt
;