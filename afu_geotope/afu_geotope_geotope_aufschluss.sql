SELECT
    code_petrografie.text AS petrografie,
    'bla' AS entstehung, -- welches Attribut?
    code_oberflaechenform.text AS oberflaechenform,
    code_geologische_system_von.text AS geologisches_system_von,
    code_geologische_system_bis.text AS geologisches_system_bis,
    code_geologische_serie_von.text AS geologische_serie_von,
    code_geologische_serie_bis.text AS geologische_serie_bis,
    code_geologische_stufe_von.text AS geologische_stufe_von,
    code_geologische_stufe_bis.text AS geologische_stufe_bis,
    code_geologische_schicht_von.text AS geologische_schicht_von,
    code_geologische_schicht_bis.text AS geologische_schicht_bis,
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
    (ST_DUMP(wkb_geometry)).geom AS geometrie --gesplittet zu Polygon. Okay so?
FROM
    ingeso.aufschluesse
    LEFT JOIN ingeso.code AS code_regionalgeologische_einheit
        ON aufschluesse.regio_geol_einheit = code_regionalgeologische_einheit.code_id
    LEFT JOIN ingeso.code AS code_geologische_system_von
        ON aufschluesse.geol_sys_von = code_geologische_system_von.code_id
    LEFT JOIN ingeso.code AS code_geologische_system_bis
        ON aufschluesse.geol_sys_bis = code_geologische_system_bis.code_id
    LEFT JOIN ingeso.code AS code_geologische_serie_von
        ON aufschluesse.geol_serie_von = code_geologische_serie_von.code_id
    LEFT JOIN ingeso.code AS code_geologische_serie_bis
        ON aufschluesse.geol_serie_bis = code_geologische_serie_bis.code_id
    LEFT JOIN ingeso.code AS code_geologische_stufe_von
        ON aufschluesse.geol_stufe_von = code_geologische_stufe_von.code_id
    LEFT JOIN ingeso.code AS code_geologische_stufe_bis
        ON aufschluesse.geol_stufe_bis = code_geologische_stufe_bis.code_id
    LEFT JOIN ingeso.code AS code_geologische_schicht_von
        ON aufschluesse.geol_schicht_von = code_geologische_schicht_von.code_id
    LEFT JOIN ingeso.code AS code_geologische_schicht_bis
        ON aufschluesse.geol_schicht_bis = code_geologische_schicht_bis.code_id
    LEFT JOIN ingeso.code AS code_petrografie
        ON aufschluesse.petrografie = code_petrografie.code_id
    LEFT JOIN ingeso.code AS code_bedeutung
        ON aufschluesse.bedeutung = code_bedeutung.code_id
    LEFT JOIN ingeso.code AS code_zustand
        ON aufschluesse.zustand= code_zustand.code_id
    LEFT JOIN ingeso.code AS code_schuetzwuerdigkeit
        ON aufschluesse.schutzbedarf = code_schuetzwuerdigkeit.code_id
    LEFT JOIN ingeso.code AS code_geowissenschaftlicher_wert
        ON aufschluesse.geowiss_wert = code_geowissenschaftlicher_wert.code_id
    LEFT JOIN ingeso.code AS code_anthropogene_gefaehrdung
        ON aufschluesse.gefaehrdung = code_anthropogene_gefaehrdung.code_id
    LEFT JOIN ingeso.code AS code_oberflaechenform
        ON aufschluesse.objektart_spez = code_oberflaechenform.code_id
WHERE
    "archive" = 0
;