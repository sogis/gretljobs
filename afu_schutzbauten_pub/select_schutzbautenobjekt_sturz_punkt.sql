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
        sd.schutzbaute_wasser_uferdeckwerk_ufermauer,
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
-- Hauptprozess Sturz
-- Schutz vor Ausbruch
-- Unterfangung
--
--------------------------------------------------------------------------------
SELECT
    geometrie,
    schutzbauten_id,
    'Sturz' AS hauptprozess,
    'Sturz' AS hauptprozess_txt,
    weiterer_prozess_wasser,
    weiterer_prozess_wasser AS weiterer_prozess_wasser_txt,
    weiterer_prozess_rutschung,
    weiterer_prozess_rutschung AS weiterer_prozess_rutschung_txt,
    false AS weiterer_prozess_sturz,
    false AS weiterer_prozess_sturz_txt,
    'Sturz.Schutz_vor_Ausbruch.Unterfangung' AS werksart,
    'Schutz vor Ausbruch: Unterfangung' AS werksart_txt,
    material,
    bt.dispname AS material_txt,
    NULL::NUMERIC AS laenge,
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
FROM afu_schutzbauten_v1.sturz_unterfangung stuf
JOIN
    afu_schutzbauten_v1.baumaterial_typ bt
        ON bt.ilicode = stuf.material
JOIN
    afu_schutzbauten_v1.koerperschaft_typ kt
        ON kt.ilicode = stuf.erhaltungsverantwortung_kategorie
JOIN
    afu_schutzbauten_v1.beurteilung_typ zt
        ON zt.ilicode = stuf.zustand
JOIN
    afu_schutzbauten_v1.wirksamkeit_typ wt
        ON wt.ilicode = stuf.wirksamkeit
LEFT JOIN
    (
        SELECT
            sd.schutzbaute_sturz_unterfangung as schutzbaute_t_id,
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
        WHERE sd.schutzbaute_sturz_unterfangung IS NOT NULL
        GROUP BY schutzbaute_t_id
    ) AS t
        ON t.schutzbaute_t_id = stuf.t_id

UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Sturz
-- Diverse
-- andere Werksart
--
--------------------------------------------------------------------------------
SELECT
    geometrie,
    schutzbauten_id,
    'Sturz' AS hauptprozess,
    'Sturz' AS hauptprozess_txt,
    weiterer_prozess_wasser,
    weiterer_prozess_wasser AS weiterer_prozess_wasser_txt,
    weiterer_prozess_rutschung,
    weiterer_prozess_rutschung AS weiterer_prozess_rutschung_txt,
    false AS weiterer_prozess_sturz,
    false AS weiterer_prozess_sturz_txt,
    'Sturz.Diverse.andere_Werksart' AS werksart,
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
FROM afu_schutzbauten_v1.sturz_andere_werksart_punkt sawp
JOIN
    afu_schutzbauten_v1.baumaterial_typ bt
        ON bt.ilicode = sawp.material
JOIN
    afu_schutzbauten_v1.koerperschaft_typ kt
        ON kt.ilicode = sawp.erhaltungsverantwortung_kategorie
JOIN
    afu_schutzbauten_v1.beurteilung_typ zt
        ON zt.ilicode = sawp.zustand
JOIN
    afu_schutzbauten_v1.wirksamkeit_typ wt
        ON wt.ilicode = sawp.wirksamkeit
LEFT JOIN
    (
        SELECT
            sd.schutzbaute_sturz_unterfangung as schutzbaute_t_id,
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
        WHERE sd.schutzbaute_sturz_unterfangung IS NOT NULL
        GROUP BY schutzbaute_t_id
    ) AS t
        ON t.schutzbaute_t_id = sawp.t_id
;