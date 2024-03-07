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
-- Hauptprozess Wasser
-- Gewährung der Sohlenstabilität
-- Rampe
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
    'Wasser.Gewaehrung_der_Sohlenstabilitaet.Rampe' AS werksart,
    'Gewährung der Sohlenstabilität: Rampe' AS werksart_txt,
    material,
    bt.dispname AS material_txt,
    laenge,
    breite,
    NULL::NUMERIC AS hoehe, 
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
FROM afu_schutzbauten_v1.wasser_rampe_sohlensicherung wrso
JOIN
    afu_schutzbauten_v1.baumaterial_typ bt
        ON bt.ilicode = wrso.material
JOIN
    afu_schutzbauten_v1.koerperschaft_typ kt
        ON kt.ilicode = wrso.erhaltungsverantwortung_kategorie
JOIN
    afu_schutzbauten_v1.beurteilung_typ zt
        ON zt.ilicode = wrso.zustand
JOIN
    afu_schutzbauten_v1.wirksamkeit_typ wt
        ON wt.ilicode = wrso.wirksamkeit
LEFT JOIN
    (
        SELECT
            sd.schutzbaute_wasser_rampe_sohlensicherung as schutzbaute_t_id,
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
        WHERE sd.schutzbaute_wasser_rampe_sohlensicherung IS NOT NULL
        GROUP BY schutzbaute_t_id
    ) AS t
        ON t.schutzbaute_t_id = wrso.t_id
WHERE
    wrso.art = 'Rampe'

UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Wasser
-- Gewährung der Sohlenstabilität
-- Flächenhafte Sohlensicherung
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
    'Wasser.Gewaehrung_der_Sohlenstabilitaet.flaechenhafte_Sohlensicherung' AS werksart,
    'Gewährung der Sohlenstabilität: flächenhafte Sohlensicherung' AS werksart_txt,
    material,
    bt.dispname AS material_txt,
    laenge,
    breite,
    NULL::NUMERIC AS hoehe, 
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
FROM afu_schutzbauten_v1.wasser_rampe_sohlensicherung wrso
JOIN
    afu_schutzbauten_v1.baumaterial_typ bt
        ON bt.ilicode = wrso.material
JOIN
    afu_schutzbauten_v1.koerperschaft_typ kt
        ON kt.ilicode = wrso.erhaltungsverantwortung_kategorie
JOIN
    afu_schutzbauten_v1.beurteilung_typ zt
        ON zt.ilicode = wrso.zustand
JOIN
    afu_schutzbauten_v1.wirksamkeit_typ wt
        ON wt.ilicode = wrso.wirksamkeit
LEFT JOIN
    (
        SELECT
            sd.schutzbaute_wasser_rampe_sohlensicherung as schutzbaute_t_id,
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
        WHERE sd.schutzbaute_wasser_rampe_sohlensicherung IS NOT NULL
        GROUP BY schutzbaute_t_id
    ) AS t
        ON t.schutzbaute_t_id = wrso.t_id
WHERE
    wrso.art = 'flaechenhafte_Sohlensicherung'

UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Wasser
-- Rückhalt
-- bewirtschafteter Geschiebeablagerungsplatz
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
    'Wasser.Rueckhalt.bewirtschafteter_Geschiebeablagerungsplatz_strecke' AS werksart,
    'Rückhalt: bewirtschafteter Geschiebeablagerungsplatz oder -strecke' AS werksart_txt,
    material,
    bt.dispname AS material_txt,
    NULL::NUMERIC AS laenge, -- nicht vorhanden
    NULL::NUMERIC AS breite, -- nicht vorhanden
    NULL::NUMERIC AS hoehe, -- nicht vorhanden
    NULL::NUMERIC AS hoehe_zum_umland, -- nicht vorhanden
    flaeche,
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
FROM afu_schutzbauten_v1.wasser_geschiebeablagerungsplatz wgag
JOIN
    afu_schutzbauten_v1.baumaterial_typ bt
        ON bt.ilicode = wgag.material
JOIN
    afu_schutzbauten_v1.koerperschaft_typ kt
        ON kt.ilicode = wgag.erhaltungsverantwortung_kategorie
JOIN
    afu_schutzbauten_v1.beurteilung_typ zt
        ON zt.ilicode = wgag.zustand
JOIN
    afu_schutzbauten_v1.wirksamkeit_typ wt
        ON wt.ilicode = wgag.wirksamkeit
LEFT JOIN
    (
        SELECT
            sd.schutzbaute_wasser_geschiebeablagerungsplatz as schutzbaute_t_id,
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
        WHERE sd.schutzbaute_wasser_geschiebeablagerungsplatz IS NOT NULL
        GROUP BY schutzbaute_t_id
    ) AS t
        ON t.schutzbaute_t_id = wgag.t_id

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
FROM afu_schutzbauten_v1.wasser_andere_werksart_flaeche wawf
JOIN
    afu_schutzbauten_v1.baumaterial_typ bt
        ON bt.ilicode = wawf.material
JOIN
    afu_schutzbauten_v1.koerperschaft_typ kt
        ON kt.ilicode = wawf.erhaltungsverantwortung_kategorie
JOIN
    afu_schutzbauten_v1.beurteilung_typ zt
        ON zt.ilicode = wawf.zustand
JOIN
    afu_schutzbauten_v1.wirksamkeit_typ wt
        ON wt.ilicode = wawf.wirksamkeit
LEFT JOIN
    (
        SELECT
            sd.schutzbaute_wasser_andere_werksart_flaeche as schutzbaute_t_id,
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
        WHERE sd.schutzbaute_wasser_andere_werksart_flaeche IS NOT NULL
        GROUP BY schutzbaute_t_id
    ) AS t
        ON t.schutzbaute_t_id = wawf.t_id
;