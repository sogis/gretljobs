SELECT
    objektname,
    code_regionalgeologische_einheit.text AS regionalgeologische_einheit,
    trim(code_bedeutung.text) AS bedeutung,
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
    replace(trim(code_geowissenschaftlicher_wert.text), ' ', '_') AS geowissenschaftlicher_wert,
    code_anthropogene_gefaehrdung.text AS anthropogene_gefaehrdung,
    lokalname,
    kantonal_gesch AS kant_geschuetztes_objekt,
    ingeso_oid AS nummer,
    ingesonr_alt AS alte_inventar_nummer,
    quelle AS hinweis_literatur,
    wkb_geometry AS geometrie,
    'inKraft' AS rechtstatus,
    'Amt für Umwelt' AS zustaendige_stelle_name,
    'https://www.so.ch/verwaltung/bau-und-justizdepartement/amt-fuer-umwelt/' AS zustaendige_stelle_amtimweb,
    FALSE AS oereb_objekt
FROM
    ingeso.hoehlen
    LEFT JOIN ingeso.code AS code_regionalgeologische_einheit
        ON hoehlen.regio_geol_einheit = code_regionalgeologische_einheit.code_id
    LEFT JOIN ingeso.code AS code_bedeutung
        ON hoehlen.bedeutung = code_bedeutung.code_id
    LEFT JOIN ingeso.code AS code_zustand
        ON hoehlen.zustand= code_zustand.code_id
    LEFT JOIN ingeso.code AS code_schuetzwuerdigkeit
        ON hoehlen.schutzbedarf = code_schuetzwuerdigkeit.code_id
    LEFT JOIN ingeso.code AS code_geowissenschaftlicher_wert
        ON hoehlen.geowiss_wert = code_geowissenschaftlicher_wert.code_id
    LEFT JOIN ingeso.code AS code_anthropogene_gefaehrdung
        ON hoehlen.gefaehrdung = code_anthropogene_gefaehrdung.code_id
WHERE
    "archive" = 0
    AND
    objektart_spez = 140
;