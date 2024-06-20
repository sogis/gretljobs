WITH schutzbauten_doku_ds AS (
    SELECT
        sd.t_id,
        sd.schutzbaute_sturz_unterfangung,
        sd.schutzbaute_sturz_andere_werksart_linie,
        sd.schutzbaute_sturz_andere_werksart_punkt,
        sd.schutzbaute_sturz_andere_werksart_flaeche,
        sd.schutzbaute_sturz_galerie,
        sd.schutzbaute_sturz_abdeckung_verankerung,
        sd.schutzbaute_sturz_schutznetz_palisade_dmm_schtzzn_muer,
        sd.schutzbaute_wasser_murbrecher_murbremse,
        sd.schutzbaute_wasser_sperre_schwelle,
        sd.schutzbaute_wasser_bruecke_steg,
        sd.schutzbaute_wasser_geschiebeablagerungsplatz,
        sd.schutzbaute_wasser_entlastungsbauwerk,
        sd.schutzbaute_wasser_mauer,
        sd.schutzbaute_wasser_rampe_sohlensicherung,
        sd.schutzbaute_wasser_entlastungsstollen_kanal,
        sd.schutzbaute_wasser_eindolung,
        sd.schutzbaute_wasser_damm,
        sd.schutzbaute_wasser_andere_werksart_punkt,
        sd.schutzbaute_wasser_uferdeckwerk_ufermauer_lebendverbau,
        sd.schutzbaute_wasser_furt,
        sd.schutzbaute_wasser_rueckhaltebauwerk,
        sd.schutzbaute_wasser_buhne,
        sd.schutzbaute_wasser_andere_werksart_linie,
        sd.schutzbaute_wasser_andere_werksart_flaeche,
        sd.schutzbaute_rutschung_andere_werksart_punkt,
        sd.schutzbaute_rutschung_abdeckung_ingmassnahme,
        sd.schutzbaute_rutschung_hangstuetzwerk_entwassrng_plsade,
        sd.schutzbaute_rutschung_andere_werksart_linie,
        sd.schutzbaute_rutschung_auffangnetz,
        sd.schutzbaute_rutschung_damm,
        sd.schutzbaute_rutschung_andere_werksart_flaeche,
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
-- Hauptprozess Rutschung
-- Schutz vor Anriss
-- Hangstützwerk
--
--------------------------------------------------------------------------------
SELECT
    geometrie,
    schutzbauten_id,
    'Rutschung' AS hauptprozess,
    'Rutschung' AS hauptprozess_txt,
    weiterer_prozess_wasser,
    weiterer_prozess_wasser AS weiterer_prozess_wasser_txt,
    false AS weiterer_prozess_rutschung,
    false AS weiterer_prozess_rutschung_txt,
    weiterer_prozess_sturz,
    weiterer_prozess_sturz AS weiterer_prozess_sturz_txt,
    'Rutschung.Schutz_vor_Anriss.Hangstuetzwerk' AS werksart,
    'Schutz vor Anriss: Hangstützwerk' AS werksart_txt,
    material,
    bt.dispname AS material_txt,
    laenge, 
    NULL::NUMERIC AS breite,
    NULL::NUMERIC AS hoehe,
    NULL::NUMERIC AS hoehe_zum_umland,
    NULL::NUMERIC AS flaeche,
    NULL::NUMERIC AS rueckhaltevolumen,
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
FROM afu_schutzbauten_v1.rutschung_hangstuetzwerk_entwaesserung_palisade rhep
JOIN
    afu_schutzbauten_v1.baumaterial_typ bt
        ON bt.ilicode = rhep.material
JOIN
    afu_schutzbauten_v1.koerperschaft_typ kt
        ON kt.ilicode = rhep.erhaltungsverantwortung_kategorie
JOIN
    afu_schutzbauten_v1.beurteilung_typ zt
        ON zt.ilicode = rhep.zustand
JOIN
    afu_schutzbauten_v1.wirksamkeit_typ wt
        ON wt.ilicode = rhep.wirksamkeit
LEFT JOIN
    (
        SELECT
            sd.schutzbaute_rutschung_hangstuetzwerk_entwassrng_plsade as schutzbaute_t_id,
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
        WHERE sd.schutzbaute_rutschung_hangstuetzwerk_entwassrng_plsade IS NOT NULL
        GROUP BY schutzbaute_t_id
    ) AS t
        ON t.schutzbaute_t_id = rhep.t_id
WHERE
    rhep.art = 'Hangstuetzwerk'

UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Rutschung
-- Schutz vor Anriss
-- Entwässerung
--
--------------------------------------------------------------------------------
SELECT
    geometrie,
    schutzbauten_id,
    'Rutschung' AS hauptprozess,
    'Rutschung' AS hauptprozess_txt,
    weiterer_prozess_wasser,
    weiterer_prozess_wasser AS weiterer_prozess_wasser_txt,
    false AS weiterer_prozess_rutschung,
    false AS weiterer_prozess_rutschung_txt,
    weiterer_prozess_sturz,
    weiterer_prozess_sturz AS weiterer_prozess_sturz_txt,
    'Rutschung.Schutz_vor_Anriss.Entwaesserung' AS werksart,
    'Schutz vor Anriss: Entwässerung' AS werksart_txt,
    material,
    bt.dispname AS material_txt,
    laenge, 
    NULL::NUMERIC AS breite,
    NULL::NUMERIC AS hoehe,
    NULL::NUMERIC AS hoehe_zum_umland,
    NULL::NUMERIC AS flaeche,
    NULL::NUMERIC AS rueckhaltevolumen,
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
FROM afu_schutzbauten_v1.rutschung_hangstuetzwerk_entwaesserung_palisade rhep
JOIN
    afu_schutzbauten_v1.baumaterial_typ bt
        ON bt.ilicode = rhep.material
JOIN
    afu_schutzbauten_v1.koerperschaft_typ kt
        ON kt.ilicode = rhep.erhaltungsverantwortung_kategorie
JOIN
    afu_schutzbauten_v1.beurteilung_typ zt
        ON zt.ilicode = rhep.zustand
JOIN
    afu_schutzbauten_v1.wirksamkeit_typ wt
        ON wt.ilicode = rhep.wirksamkeit
LEFT JOIN
    (
        SELECT
            sd.schutzbaute_rutschung_hangstuetzwerk_entwassrng_plsade as schutzbaute_t_id,
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
        WHERE sd.schutzbaute_rutschung_hangstuetzwerk_entwassrng_plsade IS NOT NULL
        GROUP BY schutzbaute_t_id
    ) AS t
        ON t.schutzbaute_t_id = rhep.t_id
WHERE
    rhep.art = 'Entwaesserung'

UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Rutschung
-- Schutz vor Anriss
-- Palisade
--
--------------------------------------------------------------------------------
SELECT
    geometrie,
    schutzbauten_id,
    'Rutschung' AS hauptprozess,
    'Rutschung' AS hauptprozess_txt,
    weiterer_prozess_wasser,
    weiterer_prozess_wasser AS weiterer_prozess_wasser_txt,
    false AS weiterer_prozess_rutschung,
    false AS weiterer_prozess_rutschung_txt,
    weiterer_prozess_sturz,
    weiterer_prozess_sturz AS weiterer_prozess_sturz_txt,
    'Rutschung.Schutz_vor_Anriss.Palisade' AS werksart,
    'Schutz vor Anriss: Palisade' AS werksart_txt,
    material,
    bt.dispname AS material_txt,
    laenge, 
    NULL::NUMERIC AS breite,
    NULL::NUMERIC AS hoehe,
    NULL::NUMERIC AS hoehe_zum_umland,
    NULL::NUMERIC AS flaeche,
    NULL::NUMERIC AS rueckhaltevolumen,
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
FROM afu_schutzbauten_v1.rutschung_hangstuetzwerk_entwaesserung_palisade rhep
JOIN
    afu_schutzbauten_v1.baumaterial_typ bt
        ON bt.ilicode = rhep.material
JOIN
    afu_schutzbauten_v1.koerperschaft_typ kt
        ON kt.ilicode = rhep.erhaltungsverantwortung_kategorie
JOIN
    afu_schutzbauten_v1.beurteilung_typ zt
        ON zt.ilicode = rhep.zustand
JOIN
    afu_schutzbauten_v1.wirksamkeit_typ wt
        ON wt.ilicode = rhep.wirksamkeit
LEFT JOIN
    (
        SELECT
            sd.schutzbaute_rutschung_hangstuetzwerk_entwassrng_plsade as schutzbaute_t_id,
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
        WHERE sd.schutzbaute_rutschung_hangstuetzwerk_entwassrng_plsade IS NOT NULL
        GROUP BY schutzbaute_t_id
    ) AS t
        ON t.schutzbaute_t_id = rhep.t_id
WHERE
    rhep.art = 'Palisade'

UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Rutschung
-- Ablenkung und Auffangen
-- Auffangnetz
--
--------------------------------------------------------------------------------
SELECT
    geometrie,
    schutzbauten_id,
    'Rutschung' AS hauptprozess,
    'Rutschung' AS hauptprozess_txt,
    weiterer_prozess_wasser,
    weiterer_prozess_wasser AS weiterer_prozess_wasser_txt,
    false AS weiterer_prozess_rutschung,
    false AS weiterer_prozess_rutschung_txt,
    weiterer_prozess_sturz,
    weiterer_prozess_sturz AS weiterer_prozess_sturz_txt,
    'Rutschung.Ablenkung_und_Auffangen.Auffangnetz' AS werksart,
    'Ablenkung und Auffangen: Auffangnetz' AS werksart_txt,
    material,
    bt.dispname AS material_txt,
    laenge, 
    NULL::NUMERIC AS breite,
    NULL::NUMERIC AS hoehe,
    NULL::NUMERIC AS hoehe_zum_umland,
    NULL::NUMERIC AS flaeche,
    NULL::NUMERIC AS rueckhaltevolumen,
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
FROM afu_schutzbauten_v1.rutschung_auffangnetz rafg
JOIN
    afu_schutzbauten_v1.baumaterial_typ bt
        ON bt.ilicode = rafg.material
JOIN
    afu_schutzbauten_v1.koerperschaft_typ kt
        ON kt.ilicode = rafg.erhaltungsverantwortung_kategorie
JOIN
    afu_schutzbauten_v1.beurteilung_typ zt
        ON zt.ilicode = rafg.zustand
JOIN
    afu_schutzbauten_v1.wirksamkeit_typ wt
        ON wt.ilicode = rafg.wirksamkeit
LEFT JOIN
    (
        SELECT
            sd.schutzbaute_rutschung_auffangnetz as schutzbaute_t_id,
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
        WHERE sd.schutzbaute_rutschung_auffangnetz IS NOT NULL
        GROUP BY schutzbaute_t_id
    ) AS t
        ON t.schutzbaute_t_id = rafg.t_id

UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Rutschung
-- Diverse
-- andere Werksart
--
--------------------------------------------------------------------------------
SELECT
    geometrie,
    schutzbauten_id,
    'Rutschung' AS hauptprozess,
    'Rutschung' AS hauptprozess_txt,
    weiterer_prozess_wasser,
    weiterer_prozess_wasser AS weiterer_prozess_wasser_txt,
    false AS weiterer_prozess_rutschung,
    false AS weiterer_prozess_rutschung_txt,
    weiterer_prozess_sturz,
    weiterer_prozess_sturz AS weiterer_prozess_sturz_txt,
    'Rutschung.Diverse.andere_Werksart' AS werksart,
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
FROM afu_schutzbauten_v1.rutschung_andere_werksart_linie rawl
JOIN
    afu_schutzbauten_v1.baumaterial_typ bt
        ON bt.ilicode = rawl.material
JOIN
    afu_schutzbauten_v1.koerperschaft_typ kt
        ON kt.ilicode = rawl.erhaltungsverantwortung_kategorie
JOIN
    afu_schutzbauten_v1.beurteilung_typ zt
        ON zt.ilicode = rawl.zustand
JOIN
    afu_schutzbauten_v1.wirksamkeit_typ wt
        ON wt.ilicode = rawl.wirksamkeit
LEFT JOIN
    (
        SELECT
            sd.schutzbaute_rutschung_andere_werksart_linie as schutzbaute_t_id,
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
        WHERE sd.schutzbaute_rutschung_andere_werksart_linie IS NOT NULL
        GROUP BY schutzbaute_t_id
    ) AS t
        ON t.schutzbaute_t_id = rawl.t_id
;