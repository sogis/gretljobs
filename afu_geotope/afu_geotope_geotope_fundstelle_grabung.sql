WITH fundstelle_grabung AS (
    SELECT
        CASE 
            WHEN code_petrografie.text = 'Penninischer Grünschiefer'
                THEN 'Penninischer_Gruenschiefer'
            WHEN code_petrografie.text = 'Casanaschiefer (Ton-Talk-Glimmerschiefer)'
                THEN 'Casanaschiefer'
            WHEN petrografie IS NULL
                THEN 'unbekannt'
            ELSE replace(replace(trim(code_petrografie.text), ' ', '_'), '-', '_')
        END AS petrografie,
        CASE 
            WHEN trim(aufenthaltsort_funde) = ''
                THEN 'unbekannt'
            ELSE trim(aufenthaltsort_funde)
        END AS aufenthaltsort,
        CASE
            WHEN trim(fundgegenstaende) = ''
                THEN 'unbekannt'
            ELSE trim(fundgegenstaende)
        END AS fundgegenstaende, 
        CASE
            WHEN code_geologische_system_von.text = 'Tertiär (Paläogen)'
                THEN 'Tertiaer'
            WHEN code_geologische_system_von.text = 'Quartär (Neogen)'
                THEN 'Quartaer'
            WHEN code_geologische_system_von.text IS NULL
                THEN 'unbekannt'
            ELSE code_geologische_system_von.text
        END AS geologisches_system_von,
        CASE
            WHEN code_geologische_system_bis.text = 'Tertiär (Paläogen)'
                THEN 'Tertiaer'
            WHEN code_geologische_system_bis.text = 'Quartär (Neogen)'
                THEN 'Quartaer'
            WHEN code_geologische_system_bis.text IS NULL
                THEN 'unbekannt'
            ELSE code_geologische_system_bis.text
        END AS geologisches_system_bis,
        CASE
            WHEN code_geologische_serie_von.text IS NULL
                THEN 'unbekannt'
            WHEN code_geologische_serie_von.text = 'Eozän'
                THEN 'Eozaen'
            WHEN code_geologische_serie_von.text = 'Miozän'
                THEN 'Miozaen'
            WHEN code_geologische_serie_von.text = 'Oligozän'
                THEN 'Oligozaen'
            WHEN code_geologische_serie_von.text = 'Paläozän'
                THEN 'Palaeozaen'
            WHEN code_geologische_serie_von.text = 'Pliozän'
                THEN 'Pliozaen'
            WHEN code_geologische_serie_von.text = 'Holozän'
                THEN 'Holozaen'
            WHEN code_geologische_serie_von.text = 'Pleistozän'
                THEN 'Pleistozaen'
            ELSE code_geologische_serie_von.text
        END AS geologische_serie_von,
        CASE
            WHEN code_geologische_serie_bis.text IS NULL
                THEN 'unbekannt'
            WHEN code_geologische_serie_bis.text = 'Eozän'
                THEN 'Eozaen'
            WHEN code_geologische_serie_bis.text = 'Miozän'
                THEN 'Miozaen'
            WHEN code_geologische_serie_bis.text = 'Oligozän'
                THEN 'Oligozaen'
            WHEN code_geologische_serie_bis.text = 'Paläozän'
                THEN 'Palaeozaen'
            WHEN code_geologische_serie_bis.text = 'Pliozän'
                THEN 'Pliozaen'
            WHEN code_geologische_serie_bis.text = 'Holozän'
                THEN 'Holozaen'
            WHEN code_geologische_serie_bis.text = 'Pleistozän'
                THEN 'Pleistozaen'
            ELSE code_geologische_serie_bis.text
        END AS geologische_serie_bis,
        CASE
            WHEN code_geologische_stufe_von.text IS NULL
                THEN 'unbekannt'
            WHEN code_geologische_stufe_von.text = 'Aalénien'
                THEN 'Aalenien'
            WHEN code_geologische_stufe_von.text = 'Sinémurien-Pliensbachien'
                THEN 'Sinemurien_Pliensbachien'
            WHEN code_geologische_stufe_von.text = 'Séquanien'
                THEN 'Sequanien'
            WHEN code_geologische_stufe_von.text = 'Lutétien'
                THEN 'Lutetien'
            WHEN code_geologische_stufe_von.text = 'Helvétien OMM'
                THEN 'Helvetien_OMM'
            WHEN code_geologische_stufe_von.text = 'Rupélien UMM'
                THEN 'Rupelien_UMM'
            WHEN code_geologische_stufe_von.text = 'Stampien UMM-USM'
                THEN 'Stampien_UMM_USM'
            WHEN code_geologische_stufe_von.text = 'Mittlerer-Unterer Buntsandstein'
                THEN 'Mittlerer_Unterer_Buntsandstein'
            WHEN code_geologische_stufe_von.text = 'Günz Vergletscherung'
                THEN 'Guenz_Vergletscherung'
            WHEN code_geologische_stufe_von.text = 'Würm Vergletscherung'
                THEN 'Wuerm_Vergletscherung'
            WHEN code_geologische_stufe_von.text = 'Latdorfien/Sannoisien'
                THEN 'Latdorfien_Sannoisien'
            ELSE replace(trim(code_geologische_stufe_von.text), ' ', '_')
        END AS geologische_stufe_von,
        CASE 
            WHEN code_geologische_stufe_bis.text IS NULL
                THEN 'unbekannt'
            WHEN code_geologische_stufe_bis.text = 'Aalénien'
                THEN 'Aalenien'
            WHEN code_geologische_stufe_bis.text = 'Sinémurien-Pliensbachien'
                THEN 'Sinemurien_Pliensbachien'
            WHEN code_geologische_stufe_bis.text = 'Séquanien'
                THEN 'Sequanien'
            WHEN code_geologische_stufe_bis.text = 'Lutétien'
                THEN 'Lutetien'
            WHEN code_geologische_stufe_bis.text = 'Helvétien OMM'
                THEN 'Helvetien_OMM'
            WHEN code_geologische_stufe_bis.text = 'Rupélien UMM'
                THEN 'Rupelien_UMM'
            WHEN code_geologische_stufe_bis.text = 'Stampien UMM-USM'
                THEN 'Stampien_UMM_USM'
            WHEN code_geologische_stufe_bis.text = 'Mittlerer-Unterer Buntsandstein'
                THEN 'Mittlerer_Unterer_Buntsandstein'
            WHEN code_geologische_stufe_bis.text = 'Günz Vergletscherung'
                THEN 'Guenz_Vergletscherung'
            WHEN code_geologische_stufe_bis.text = 'Würm Vergletscherung'
                THEN 'Wuerm_Vergletscherung'
            WHEN code_geologische_stufe_bis.text = 'Latdorfien/Sannoisien'
                THEN 'Latdorfien_Sannoisien'
            ELSE replace(trim(code_geologische_stufe_bis.text), ' ', '_')
        END AS geologische_stufe_bis,
        CASE
            WHEN code_geologische_schicht_von.text IS NULL
                THEN 'unbekannt'
            WHEN code_geologische_schicht_von.text = 'Mäandrina Schichten'
                THEN 'Maeandrina_Schichten'
            WHEN code_geologische_schicht_von.text = 'Dalle nacreé'
                THEN 'Dalle_nacree'
            WHEN code_geologische_schicht_von.text = 'Arieten (Gryphiten) Kalk'
                THEN 'Arieten_Kalk'
            WHEN code_geologische_schicht_von.text = 'Terrain à chailles'
                THEN 'Terrain_a_chailles'
            WHEN code_geologische_schicht_von.text = 'Röt'
                THEN 'Roet'
            WHEN code_geologische_schicht_von.text = 'Gansinger Dolomit (Hauptsteinmergel)'
                THEN 'Gansinger_Dolomit'
            WHEN code_geologische_schicht_von.text = 'Rhät'
                THEN 'Rhaet'
            WHEN code_geologische_schicht_von.text = 'Grundmoräne'
                THEN 'Grundmoraene'
            WHEN code_geologische_schicht_von.text = 'Seitenmoräne'
                THEN 'Seitenmoraene'
            WHEN code_geologische_schicht_von.text = 'U-Tal'
                THEN 'U_Tal'
            WHEN code_geologische_schicht_von.text = 'Vorbourg-Kalke'
                THEN 'Vorbourg_Kalke'
            WHEN code_geologische_schicht_von.text = 'Moräne'
                THEN 'Moraene'
            WHEN code_geologische_schicht_von.text = 'UMM-USM'
                THEN 'UMM_USM'
            ELSE replace(trim(code_geologische_schicht_von.text), ' ', '_')
        END AS geologische_schicht_von,
        CASE
            WHEN code_geologische_schicht_bis.text IS NULL 
                THEN 'unbekannt'
            WHEN code_geologische_schicht_bis.text = 'Mäandrina Schichten'
                THEN 'Maeandrina_Schichten'
            WHEN code_geologische_schicht_bis.text = 'Dalle nacreé'
                THEN 'Dalle_nacree'
            WHEN code_geologische_schicht_bis.text = 'Arieten (Gryphiten) Kalk'
                THEN 'Arieten_Kalk'
            WHEN code_geologische_schicht_bis.text = 'Terrain à chailles'
                THEN 'Terrain_a_chailles'
            WHEN code_geologische_schicht_bis.text = 'Röt'
                THEN 'Roet'
            WHEN code_geologische_schicht_bis.text = 'Gansinger Dolomit (Hauptsteinmergel)'
                THEN 'Gansinger_Dolomit'
            WHEN code_geologische_schicht_bis.text = 'Rhät'
                THEN 'Rhaet'
            WHEN code_geologische_schicht_bis.text = 'Grundmoräne'
                THEN 'Grundmoraene'
            WHEN code_geologische_schicht_bis.text = 'Seitenmoräne'
                THEN 'Seitenmoraene'
            WHEN code_geologische_schicht_bis.text = 'U-Tal'
                THEN 'U_Tal'
            WHEN code_geologische_schicht_bis.text = 'Vorbourg-Kalke'
                THEN 'Vorbourg_Kalke'
            WHEN code_geologische_schicht_bis.text = 'Moräne'
                THEN 'Moraene'
            WHEN code_geologische_schicht_bis.text = 'UMM-USM'
                THEN 'UMM_USM'
            ELSE replace(trim(code_geologische_schicht_bis.text), ' ', '_')
        END AS geologische_schicht_bis,
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
        trim(code_anthropogene_gefaehrdung.text) AS anthropogene_gefaehrdung,
        lokalname,
        kantonal_gesch AS kant_geschuetztes_objekt,
        CASE 
            WHEN ingesonr_alt IS NOT NULL 
                THEN (coalesce(ingeso_oid::character varying,'')||','||ingesonr_alt)
            ELSE coalesce(ingeso_oid::character varying,'') 
        END AS alte_inventar_nummer,
        regexp_replace(quelle, E'[\\n\\r]+', ' ', 'g' ) AS hinweis_literatur,
        wkb_geometry AS geometrie
    FROM
        ingeso.fundstl_grabungen
        LEFT JOIN ingeso.code AS code_regionalgeologische_einheit
            ON fundstl_grabungen.regio_geol_einheit = code_regionalgeologische_einheit.code_id
        LEFT JOIN ingeso.code AS code_geologische_system_von
            ON fundstl_grabungen.geol_sys_von = code_geologische_system_von.code_id
        LEFT JOIN ingeso.code AS code_geologische_system_bis
            ON fundstl_grabungen.geol_sys_bis = code_geologische_system_bis.code_id
        LEFT JOIN ingeso.code AS code_geologische_serie_von
            ON fundstl_grabungen.geol_serie_von = code_geologische_serie_von.code_id
        LEFT JOIN ingeso.code AS code_geologische_serie_bis
            ON fundstl_grabungen.geol_serie_bis = code_geologische_serie_bis.code_id
        LEFT JOIN ingeso.code AS code_geologische_stufe_von
            ON fundstl_grabungen.geol_stufe_von = code_geologische_stufe_von.code_id
        LEFT JOIN ingeso.code AS code_geologische_stufe_bis
            ON fundstl_grabungen.geol_stufe_bis = code_geologische_stufe_bis.code_id
        LEFT JOIN ingeso.code AS code_geologische_schicht_von
            ON fundstl_grabungen.geol_schicht_von = code_geologische_schicht_von.code_id
        LEFT JOIN ingeso.code AS code_geologische_schicht_bis
            ON fundstl_grabungen.geol_schicht_bis = code_geologische_schicht_bis.code_id
        LEFT JOIN ingeso.code AS code_petrografie
            ON fundstl_grabungen.petrografie = code_petrografie.code_id
        LEFT JOIN ingeso.code AS code_bedeutung
            ON fundstl_grabungen.bedeutung = code_bedeutung.code_id
        LEFT JOIN ingeso.code AS code_zustand
            ON fundstl_grabungen.zustand= code_zustand.code_id
        LEFT JOIN ingeso.code AS code_schuetzwuerdigkeit
            ON fundstl_grabungen.schutzbedarf = code_schuetzwuerdigkeit.code_id
        LEFT JOIN ingeso.code AS code_geowissenschaftlicher_wert
            ON fundstl_grabungen.geowiss_wert = code_geowissenschaftlicher_wert.code_id
        LEFT JOIN ingeso.code AS code_anthropogene_gefaehrdung
            ON fundstl_grabungen.gefaehrdung = code_anthropogene_gefaehrdung.code_id
        LEFT JOIN ingeso.code AS code_oberflaechenform
            ON fundstl_grabungen.objektart_spez = code_oberflaechenform.code_id
    WHERE
        "archive" = 0
),
lithostratigraphie AS (
    SELECT
        lithostratigrphie_geologische_schicht.t_id AS geologische_schicht,
        lithostratigrphie_geologische_schicht.bezeichnung AS geologische_schicht_bezeichnung,
        lithostratigrphie_geologische_stufe.t_id AS geologische_stufe,
        lithostratigrphie_geologische_stufe.bezeichnung AS geologische_stufe_bezeichnung,
        lithostratigrphie_geologische_serie.t_id AS geologische_serie,
        lithostratigrphie_geologische_serie.bezeichnung AS geologische_serie_bezeichnung,
        lithostratigrphie_geologisches_system.t_id AS geologisches_system,
        lithostratigrphie_geologisches_system.bezeichnung AS geologisches_system_bezeichnung
    FROM
        afu_geotope.lithostratigrphie_geologische_schicht
        LEFT JOIN afu_geotope.lithostratigrphie_geologische_stufe
            ON lithostratigrphie_geologische_schicht.geologische_stufe = lithostratigrphie_geologische_stufe.t_id
        LEFT JOIN afu_geotope.lithostratigrphie_geologische_serie
            ON lithostratigrphie_geologische_stufe.geologische_serie = lithostratigrphie_geologische_serie.t_id
        LEFT JOIN afu_geotope.lithostratigrphie_geologisches_system
            ON lithostratigrphie_geologische_serie.geologisches_system = lithostratigrphie_geologisches_system.t_id
)

SELECT
    fundstelle_grabung.petrografie,
    fundstelle_grabung.aufenthaltsort,
    fundstelle_grabung.fundgegenstaende,
    lithostratigraphie_von.geologisches_system AS geologisches_system_von,
    lithostratigraphie_bis.geologisches_system AS geologisches_system_bis,
    lithostratigraphie_von.geologische_serie AS geologische_serie_von,
    lithostratigraphie_bis.geologische_serie AS geologische_serie_bis,
    lithostratigraphie_von.geologische_stufe AS geologische_stufe_von,
    lithostratigraphie_bis.geologische_stufe AS geologische_stufe_bis,
    lithostratigraphie_von.geologische_schicht AS geologische_schicht_von,
    lithostratigraphie_bis.geologische_schicht AS geologische_schicht_bis,
    fundstelle_grabung.objektname,
    fundstelle_grabung.regionalgeologische_einheit,
    fundstelle_grabung.bedeutung,
    fundstelle_grabung.zustand,
    fundstelle_grabung.beschreibung,
    fundstelle_grabung.schutzwuerdigkeit,
    fundstelle_grabung.geowissenschaftlicher_wert,
    fundstelle_grabung.anthropogene_gefaehrdung,
    fundstelle_grabung.lokalname,
    fundstelle_grabung.kant_geschuetztes_objekt,
    fundstelle_grabung.alte_inventar_nummer,
    fundstelle_grabung.hinweis_literatur,
    fundstelle_grabung.geometrie,
    'inKraft' AS rechtsstatus,
    geotope_zustaendige_stelle.t_id AS zustaendige_stelle,
    FALSE AS oereb_objekt
FROM
    fundstelle_grabung,
    lithostratigraphie AS lithostratigraphie_von,
    lithostratigraphie AS lithostratigraphie_bis,
    afu_geotope.geotope_zustaendige_stelle
WHERE
    fundstelle_grabung.geologische_schicht_von = lithostratigraphie_von.geologische_schicht_bezeichnung
    AND
    fundstelle_grabung.geologische_serie_von = lithostratigraphie_von.geologische_serie_bezeichnung
    AND
    fundstelle_grabung.geologische_stufe_von = lithostratigraphie_von.geologische_stufe_bezeichnung
    AND
    fundstelle_grabung.geologisches_system_von = lithostratigraphie_von.geologisches_system_bezeichnung
    AND
    fundstelle_grabung.geologische_schicht_bis = lithostratigraphie_bis.geologische_schicht_bezeichnung
    AND
    fundstelle_grabung.geologische_serie_bis = lithostratigraphie_bis.geologische_serie_bezeichnung
    AND
    fundstelle_grabung.geologische_stufe_bis = lithostratigraphie_bis.geologische_stufe_bezeichnung
    AND
    fundstelle_grabung.geologisches_system_bis = lithostratigraphie_bis.geologisches_system_bezeichnung
;
