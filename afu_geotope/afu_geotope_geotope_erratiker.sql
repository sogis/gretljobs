SELECT
    code_petrografie.text AS petrografie,
    'bla' AS entstehung, -- welches Attribut?
    groesse,
    CASE 
        WHEN eiszeit = 473
            THEN 'Wuerm'
        WHEN eiszeit = 474
            THEN 'Riss'
        WHEN eiszeit = 510
            THEN 'unbekannt'
    END AS eiszeit,
    herkunft,
    CASE
        WHEN schalenstein = 476
            THEN TRUE
        WHEN schalenstein = 477
            THEN FALSE
        ELSE FALSE --temporäre Lösung
    END AS schalenstein,
    aufenthaltsort,
    objektname,
    code_regionalgeologische_einheit.text AS regionalgeologische_einheit,
    code_bedeutung.text AS bedeutung,
    code_zustand.text AS zustand,
    kurzbeschreibung AS beschreibung,
    code_schuetzwuerdigkeit.text AS schutzwuerdigkeit,
    code_geowissenschaftlicher_wert.text AS geowissenschaftlicher_wert,
    code_anthropogene_gefaehrdung.text AS anthropogene_gefaehrdung,
    lokalname,
    kantonal_gesch AS kant_geschuetztes_objekt,
    ingeso_oid AS nummer, --korrekt?
    ingesonr_alt AS alte_inventar_nummer,
    quelle AS hinweis_literatur, --korrekt?
    wkb_geometry AS geometrie
FROM
    ingeso.erratiker
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
WHERE
    "archive" = 0
;