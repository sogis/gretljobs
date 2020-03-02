SELECT
    CASE 
        WHEN code_petrografie.text = 'Penninischer Grünschiefer'
            THEN 'Penninischer_Gruenschiefer'
        WHEN code_petrografie.text = 'Casanaschiefer (Ton-Talk-Glimmerschiefer)'
            THEN 'Casanaschiefer_Ton_Talk_Glimmerschiefer'
        ELSE replace(replace(trim(code_petrografie.text), ' ', '_'), '-', '_')
    END AS petrografie,
    CASE
        WHEN code_entstehung.text = 'natürlich'
            THEN 'natuerlich'
        ELSE code_entstehung.text
    END AS entstehung,
    CASE 
        WHEN trim(regexp_replace(groesse, E'[\\n\\r]+', ' ', 'g')) != ''
            THEN trim(regexp_replace(groesse, E'[\\n\\r]+', ' ', 'g'))
        ELSE 'unbekannt'
    END AS groesse,
    CASE 
        WHEN eiszeit = 473
            THEN 'Wuerm'
        WHEN eiszeit = 474
            THEN 'Riss'
        WHEN eiszeit = 510
            THEN 'unbekannt'
    END AS eiszeit,
    CASE 
        WHEN trim(regexp_replace(herkunft, E'[\\n\\r]+', ' ', 'g')) != ''
            THEN trim(regexp_replace(herkunft, E'[\\n\\r]+', ' ', 'g'))
        ELSE 'unbekannt'
    END AS herkunft,
    CASE
        WHEN schalenstein = 476
            THEN TRUE
        WHEN schalenstein = 477
            THEN FALSE
        ELSE NULL
    END AS schalenstein,
    aufenthaltsort,
    objektname,
    code_regionalgeologische_einheit.text AS regionalgeologische_einheit,
    code_bedeutung.text AS bedeutung,
    CASE
        WHEN code_zustand.text = 'nicht beeinträchtigt'
            THEN 'nicht_beeintraechtigt'
        WHEN code_zustand.text = 'gering beeinträchtigt'
            THEN 'gering_beeintraechtigt'
        WHEN code_zustand.text = 'stark beeinträchtigt'
            THEN 'stark_beeintraechtigt'
        WHEN code_zustand.text = 'zerstört'
            THEN 'zerstoert'
        ELSE code_zustand.text 
    END AS zustand,
    kurzbeschreibung AS beschreibung,
    CASE
        WHEN code_schuetzwuerdigkeit.text = 'schutzwürdig'
            THEN 'schutzwuerdig'
        WHEN code_schuetzwuerdigkeit.text = 'geschützt'
            THEN 'geschuetzt'
        ELSE trim(code_schuetzwuerdigkeit.text)
    END AS schutzwuerdigkeit,
    code_geowissenschaftlicher_wert.text AS geowissenschaftlicher_wert,
    code_anthropogene_gefaehrdung.text AS anthropogene_gefaehrdung,
    lokalname,
    kantonal_gesch AS kant_geschuetztes_objekt,
    CASE 
        WHEN ingesonr_alt IS NOT NULL 
            THEN (coalesce(ingeso_oid::character varying,'')||','||ingesonr_alt)
        ELSE coalesce(ingeso_oid::character varying,'') 
    END AS alte_inventar_nummer,
    regexp_replace(quelle, E'[\\n\\r]+', ' ', 'g' ) AS hinweis_literatur,
    wkb_geometry AS geometrie,
    'inKraft' AS rechtsstatus,
    geotope_zustaendige_stelle.t_id AS zustaendige_stelle,
    FALSE AS oereb_objekt
FROM
    ingeso.erratiker
    LEFT JOIN ingeso.code AS code_entstehung
        ON erratiker.objektart_allg = code_entstehung.code_id
    LEFT JOIN ingeso.code AS code_regionalgeologische_einheit
        ON erratiker.regio_geol_einheit = code_regionalgeologische_einheit.code_id
    LEFT JOIN ingeso.code AS code_petrografie
        ON erratiker.petrografie = code_petrografie.code_id
    LEFT JOIN ingeso.code AS code_bedeutung
        ON erratiker.bedeutung = code_bedeutung.code_id
    LEFT JOIN ingeso.code AS code_zustand
        ON erratiker.zustand= code_zustand.code_id
    LEFT JOIN ingeso.code AS code_schuetzwuerdigkeit
        ON erratiker.schutzbedarf = code_schuetzwuerdigkeit.code_id
    LEFT JOIN ingeso.code AS code_geowissenschaftlicher_wert
        ON erratiker.geowiss_wert = code_geowissenschaftlicher_wert.code_id
    LEFT JOIN ingeso.code AS code_anthropogene_gefaehrdung
        ON erratiker.gefaehrdung = code_anthropogene_gefaehrdung.code_id
    CROSS JOIN afu_geotope.geotope_zustaendige_stelle
WHERE
    "archive" = 0
;
