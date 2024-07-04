WITH schutzbauten_doku_ds AS (
    SELECT
        sd.t_id,
        sd.schutzbaute_wasser_bruecke_steg,
        sd.schutzbaute_wasser_andere_werksart_punkt,
        sd.schutzbaute_wasser_furt,
        doku.titel,
        doku.beschrieb,
        'https://geo.so.ch/docs/ch.so.afu.schutzbauten/' || tidd.datasetname || '/' || doku.dateiname AS dokumentimweb,
        'SO_AFU_Schutzbauten_Publikation_20231212.Schutzbauten.Dokument' AS ili_type
    FROM
        afu_schutzbauten_v1.schutzbaute_dokument sd
    LEFT JOIN
        afu_schutzbauten_v1.dokument doku
            ON doku.t_id = sd.dokument
    JOIN
	afu_schutzbauten_v1.t_ili2db_basket tidb
            ON tidb.t_id  = sd.t_basket
    JOIN
	afu_schutzbauten_v1.t_ili2db_dataset tidd
            ON tidd.t_id = tidb.dataset
)

--------------------------------------------------------------------------------
--
-- Hauptprozess Wasser
-- Diverse
-- Brücke, Steg
--
--------------------------------------------------------------------------------
SELECT
    geometrie,
    schutzbauten_id,
    'Wasser' AS hauptprozess,
    'Wasser' AS hauptprozess_txt,
    false AS weiterer_prozess_wasser,
    false AS weiterer_prozess_wasser_txt,
    weiterer_prozess_rutschung,
    weiterer_prozess_rutschung AS weiterer_prozess_rutschung_txt,
    weiterer_prozess_sturz,
    weiterer_prozess_sturz AS weiterer_prozess_sturz_txt,
    'Wasser.Diverse.Bruecke_Steg' AS werksart,
    'Diverse: Brücke, Steg' AS werksart_txt,
    material,
    bt.dispname AS material_txt,
    laenge,
    breite,
    hoehe, 
    NULL::NUMERIC AS hoehe_zum_umland, -- nicht vorhanden
    NULL::NUMERIC AS flaeche, -- nicht vorhanden
    NULL::NUMERIC AS rueckhaltevolumen, -- nicht vorhanden
    erstellungsjahr,
    erhaltungsverantwortung_kategorie,
    kt.dispname AS erhaltungsverantwortung_kategorie_txt,
    erhaltungsverantwortung_name,
    zustand,    
    zt.dispname AS zustand_txt,
    zustandsbeurteilung_jahr,
    wirksamkeit,
    wt.dispname AS wirksamkeit_txt,
    bemerkungen,
    t.dokumente_json AS dokumente
FROM afu_schutzbauten_v1.wasser_bruecke_steg wbst
JOIN
    afu_schutzbauten_v1.baumaterial_typ bt
        ON bt.ilicode = wbst.material
JOIN
    afu_schutzbauten_v1.koerperschaft_typ kt
        ON kt.ilicode = wbst.erhaltungsverantwortung_kategorie
JOIN
    afu_schutzbauten_v1.beurteilung_typ zt
        ON zt.ilicode = wbst.zustand
JOIN
    afu_schutzbauten_v1.wirksamkeit_typ wt
        ON wt.ilicode = wbst.wirksamkeit
LEFT JOIN
    (
        SELECT
            sd.schutzbaute_wasser_bruecke_steg as schutzbaute_t_id,
            array_to_json(
                array_agg(
                    json_build_object(
                        '@type', sd.ili_type,
                        'Titel', sd.titel,
                        'Beschrieb', sd.beschrieb,
                        'DokumentImWeb', sd.dokumentimweb
                    )
                )
            )::jsonb AS dokumente_json
        FROM
            schutzbauten_doku_ds sd
        WHERE sd.schutzbaute_wasser_bruecke_steg IS NOT NULL
        GROUP BY schutzbaute_t_id
    ) AS t
        ON t.schutzbaute_t_id = wbst.t_id

UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Wasser
-- Diverse
-- Furt
--
--------------------------------------------------------------------------------
SELECT
    geometrie,
    schutzbauten_id,
    'Wasser' AS hauptprozess,
    'Wasser' AS hauptprozess_txt,
    false AS weiterer_prozess_wasser,
    false AS weiterer_prozess_wasser_txt,
    weiterer_prozess_rutschung,
    weiterer_prozess_rutschung AS weiterer_prozess_rutschung_txt,
    weiterer_prozess_sturz,
    weiterer_prozess_sturz AS weiterer_prozess_sturz_txt,
    'Wasser.Diverse.Furt' AS werksart,
    'Diverse: Furt' AS werksart_txt,
    material,
    bt.dispname AS material_txt,
    laenge,
    breite,
    NULL::NUMERIC AS hoehe, --nicht vorhanden
    NULL::NUMERIC AS hoehe_zum_umland, -- nicht vorhanden
    NULL::NUMERIC AS flaeche, -- nicht vorhanden
    NULL::NUMERIC AS rueckhaltevolumen, -- nicht vorhanden
    erstellungsjahr,
    erhaltungsverantwortung_kategorie,
    kt.dispname AS erhaltungsverantwortung_kategorie_txt,
    erhaltungsverantwortung_name,
    zustand,    
    zt.dispname AS zustand_txt,
    zustandsbeurteilung_jahr,
    wirksamkeit,
    wt.dispname AS wirksamkeit_txt,
    bemerkungen,
    t.dokumente_json AS dokumente
FROM afu_schutzbauten_v1.wasser_furt wfur
JOIN
    afu_schutzbauten_v1.baumaterial_typ bt
        ON bt.ilicode = wfur.material
JOIN
    afu_schutzbauten_v1.koerperschaft_typ kt
        ON kt.ilicode = wfur.erhaltungsverantwortung_kategorie
JOIN
    afu_schutzbauten_v1.beurteilung_typ zt
        ON zt.ilicode = wfur.zustand
JOIN
    afu_schutzbauten_v1.wirksamkeit_typ wt
        ON wt.ilicode = wfur.wirksamkeit
LEFT JOIN
    (
        SELECT
            sd.schutzbaute_wasser_furt as schutzbaute_t_id,
            array_to_json(
                array_agg(
                    json_build_object(
                        '@type', sd.ili_type,
                        'Titel', sd.titel,
                        'Beschrieb', sd.beschrieb,
                        'DokumentImWeb', sd.dokumentimweb
                    )
                )
            )::jsonb AS dokumente_json
        FROM
            schutzbauten_doku_ds sd
        WHERE sd.schutzbaute_wasser_furt IS NOT NULL
        GROUP BY schutzbaute_t_id
    ) AS t
        ON t.schutzbaute_t_id = wfur.t_id

UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Wasser
-- Diverse
-- andere Werksart
--
--------------------------------------------------------------------------------
SELECT
    geometrie,
    schutzbauten_id,
    'Wasser' AS hauptprozess,
    'Wasser' AS hauptprozess_txt,
    false AS weiterer_prozess_wasser,
    false AS weiterer_prozess_wasser_txt,
    weiterer_prozess_rutschung,
    weiterer_prozess_rutschung AS weiterer_prozess_rutschung_txt,
    weiterer_prozess_sturz,
    weiterer_prozess_sturz AS weiterer_prozess_sturz_txt,
    'Wasser.Diverse.andere_Werksart' AS werksart,
    'Diverse: andere Werksart' AS werksart_txt,
    material,
    bt.dispname AS material_txt,
    laenge,
    breite,
    hoehe,
    hoehe_zum_umland,
    flaeche,
    rueckhaltevolumen,
    erstellungsjahr,
    erhaltungsverantwortung_kategorie,
    kt.dispname AS erhaltungsverantwortung_kategorie_txt,
    erhaltungsverantwortung_name,
    zustand,    
    zt.dispname AS zustand_txt,
    zustandsbeurteilung_jahr,
    wirksamkeit,
    wt.dispname AS wirksamkeit_txt,
    bemerkungen,
    t.dokumente_json AS dokumente
FROM afu_schutzbauten_v1.wasser_andere_werksart_punkt wawp
JOIN
    afu_schutzbauten_v1.baumaterial_typ bt
        ON bt.ilicode = wawp.material
JOIN
    afu_schutzbauten_v1.koerperschaft_typ kt
        ON kt.ilicode = wawp.erhaltungsverantwortung_kategorie
JOIN
    afu_schutzbauten_v1.beurteilung_typ zt
        ON zt.ilicode = wawp.zustand
JOIN
    afu_schutzbauten_v1.wirksamkeit_typ wt
        ON wt.ilicode = wawp.wirksamkeit
LEFT JOIN
    (
        SELECT
            sd.schutzbaute_wasser_andere_werksart_punkt as schutzbaute_t_id,
            array_to_json(
                array_agg(
                    json_build_object(
                        '@type', sd.ili_type,
                        'Titel', sd.titel,
                        'Beschrieb', sd.beschrieb,
                        'DokumentImWeb', sd.dokumentimweb
                    )
                )
            )::jsonb AS dokumente_json
        FROM
            schutzbauten_doku_ds sd
        WHERE sd.schutzbaute_wasser_andere_werksart_punkt IS NOT NULL
        GROUP BY schutzbaute_t_id
    ) AS t
        ON t.schutzbaute_t_id = wawp.t_id
;