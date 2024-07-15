WITH schutzbauten_doku_ds AS (
    SELECT
        sd.t_id,
        sd.schutzbaute_sturz_andere_werksart_linie,
        sd.schutzbaute_sturz_schutznetz_palisade_dmm_schtzzn_muer,
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
-- Schutz vor Aufprall
-- Schutznetz
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
    'Sturz.Schutz_vor_Aufprall.Schutznetz' AS werksart,
    'Schutz vor Aufprall: Schutznetz' AS werksart_txt,
    material,
    bt.dispname AS material_txt,
    laenge, 
    NULL::NUMERIC AS breite,
    NULL::NUMERIC AS hoehe,
    hoehe_zum_umland,
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
FROM afu_schutzbauten_v1.sturz_schutznetz_palisade_damm_schutzzaun_mauer sspdsm
JOIN
    afu_schutzbauten_v1.baumaterial_typ bt
        ON bt.ilicode = sspdsm.material
JOIN
    afu_schutzbauten_v1.koerperschaft_typ kt
        ON kt.ilicode = sspdsm.erhaltungsverantwortung_kategorie
JOIN
    afu_schutzbauten_v1.beurteilung_typ zt
        ON zt.ilicode = sspdsm.zustand
JOIN
    afu_schutzbauten_v1.wirksamkeit_typ wt
        ON wt.ilicode = sspdsm.wirksamkeit
LEFT JOIN
    (
        SELECT
            sd.schutzbaute_sturz_schutznetz_palisade_dmm_schtzzn_muer as schutzbaute_t_id,
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
        WHERE sd.schutzbaute_sturz_schutznetz_palisade_dmm_schtzzn_muer IS NOT NULL
        GROUP BY schutzbaute_t_id
    ) AS t
        ON t.schutzbaute_t_id = sspdsm.t_id
WHERE
    sspdsm.art = 'Schutznetz'

UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Sturz
-- Schutz vor Aufprall
-- Palisade, Barrage
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
    'Sturz.Schutz_vor_Aufprall.Palisade_Barrage' AS werksart,
    'Schutz vor Aufprall: Palisade, Barrage' AS werksart_txt,
    material,
    bt.dispname AS material_txt,
    laenge, 
    NULL::NUMERIC AS breite,
    NULL::NUMERIC AS hoehe,
    hoehe_zum_umland,
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
FROM afu_schutzbauten_v1.sturz_schutznetz_palisade_damm_schutzzaun_mauer sspdsm
JOIN
    afu_schutzbauten_v1.baumaterial_typ bt
        ON bt.ilicode = sspdsm.material
JOIN
    afu_schutzbauten_v1.koerperschaft_typ kt
        ON kt.ilicode = sspdsm.erhaltungsverantwortung_kategorie
JOIN
    afu_schutzbauten_v1.beurteilung_typ zt
        ON zt.ilicode = sspdsm.zustand
JOIN
    afu_schutzbauten_v1.wirksamkeit_typ wt
        ON wt.ilicode = sspdsm.wirksamkeit
LEFT JOIN
    (
        SELECT
            sd.schutzbaute_sturz_schutznetz_palisade_dmm_schtzzn_muer as schutzbaute_t_id,
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
        WHERE sd.schutzbaute_sturz_schutznetz_palisade_dmm_schtzzn_muer IS NOT NULL
        GROUP BY schutzbaute_t_id
    ) AS t
        ON t.schutzbaute_t_id = sspdsm.t_id
WHERE
    sspdsm.art = 'Palisade_Barrage'

UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Sturz
-- Schutz vor Aufprall
-- Damm
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
    'Sturz.Schutz_vor_Aufprall.Damm' AS werksart,
    'Schutz vor Aufprall: Damm' AS werksart_txt,
    material,
    bt.dispname AS material_txt,
    laenge, 
    NULL::NUMERIC AS breite,
    NULL::NUMERIC AS hoehe,
    hoehe_zum_umland,
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
FROM afu_schutzbauten_v1.sturz_schutznetz_palisade_damm_schutzzaun_mauer sspdsm
JOIN
    afu_schutzbauten_v1.baumaterial_typ bt
        ON bt.ilicode = sspdsm.material
JOIN
    afu_schutzbauten_v1.koerperschaft_typ kt
        ON kt.ilicode = sspdsm.erhaltungsverantwortung_kategorie
JOIN
    afu_schutzbauten_v1.beurteilung_typ zt
        ON zt.ilicode = sspdsm.zustand
JOIN
    afu_schutzbauten_v1.wirksamkeit_typ wt
        ON wt.ilicode = sspdsm.wirksamkeit
LEFT JOIN
    (
        SELECT
            sd.schutzbaute_sturz_schutznetz_palisade_dmm_schtzzn_muer as schutzbaute_t_id,
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
        WHERE sd.schutzbaute_sturz_schutznetz_palisade_dmm_schtzzn_muer IS NOT NULL
        GROUP BY schutzbaute_t_id
    ) AS t
        ON t.schutzbaute_t_id = sspdsm.t_id
WHERE
    sspdsm.art = 'Damm'

UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Sturz
-- Schutz vor Aufprall
-- Schutzzaun
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
    'Sturz.Schutz_vor_Aufprall.Schutzzaun' AS werksart,
    'Schutz vor Aufprall: Schutzzaun' AS werksart_txt,
    material,
    bt.dispname AS material_txt,
    laenge, 
    NULL::NUMERIC AS breite,
    NULL::NUMERIC AS hoehe,
    hoehe_zum_umland,
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
FROM afu_schutzbauten_v1.sturz_schutznetz_palisade_damm_schutzzaun_mauer sspdsm
JOIN
    afu_schutzbauten_v1.baumaterial_typ bt
        ON bt.ilicode = sspdsm.material
JOIN
    afu_schutzbauten_v1.koerperschaft_typ kt
        ON kt.ilicode = sspdsm.erhaltungsverantwortung_kategorie
JOIN
    afu_schutzbauten_v1.beurteilung_typ zt
        ON zt.ilicode = sspdsm.zustand
JOIN
    afu_schutzbauten_v1.wirksamkeit_typ wt
        ON wt.ilicode = sspdsm.wirksamkeit
LEFT JOIN
    (
        SELECT
            sd.schutzbaute_sturz_schutznetz_palisade_dmm_schtzzn_muer as schutzbaute_t_id,
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
        WHERE sd.schutzbaute_sturz_schutznetz_palisade_dmm_schtzzn_muer IS NOT NULL
        GROUP BY schutzbaute_t_id
    ) AS t
        ON t.schutzbaute_t_id = sspdsm.t_id
WHERE
    sspdsm.art = 'Schutzzaun'

UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Sturz
-- Schutz vor Aufprall
-- Mauer
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
    'Sturz.Schutz_vor_Aufprall.Mauer' AS werksart,
    'Schutz vor Aufprall: Mauer' AS werksart_txt,
    material,
    bt.dispname AS material_txt,
    laenge, 
    NULL::NUMERIC AS breite,
    NULL::NUMERIC AS hoehe,
    hoehe_zum_umland,
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
FROM afu_schutzbauten_v1.sturz_schutznetz_palisade_damm_schutzzaun_mauer sspdsm
JOIN
    afu_schutzbauten_v1.baumaterial_typ bt
        ON bt.ilicode = sspdsm.material
JOIN
    afu_schutzbauten_v1.koerperschaft_typ kt
        ON kt.ilicode = sspdsm.erhaltungsverantwortung_kategorie
JOIN
    afu_schutzbauten_v1.beurteilung_typ zt
        ON zt.ilicode = sspdsm.zustand
JOIN
    afu_schutzbauten_v1.wirksamkeit_typ wt
        ON wt.ilicode = sspdsm.wirksamkeit
LEFT JOIN
    (
        SELECT
            sd.schutzbaute_sturz_schutznetz_palisade_dmm_schtzzn_muer as schutzbaute_t_id,
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
        WHERE sd.schutzbaute_sturz_schutznetz_palisade_dmm_schtzzn_muer IS NOT NULL
        GROUP BY schutzbaute_t_id
    ) AS t
        ON t.schutzbaute_t_id = sspdsm.t_id
WHERE
    sspdsm.art = 'Mauer'

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
FROM afu_schutzbauten_v1.sturz_andere_werksart_linie sawl
JOIN
    afu_schutzbauten_v1.baumaterial_typ bt
        ON bt.ilicode = sawl.material
JOIN
    afu_schutzbauten_v1.koerperschaft_typ kt
        ON kt.ilicode = sawl.erhaltungsverantwortung_kategorie
JOIN
    afu_schutzbauten_v1.beurteilung_typ zt
        ON zt.ilicode = sawl.zustand
JOIN
    afu_schutzbauten_v1.wirksamkeit_typ wt
        ON wt.ilicode = sawl.wirksamkeit
LEFT JOIN
    (
        SELECT
            sd.schutzbaute_sturz_andere_werksart_linie as schutzbaute_t_id,
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
        WHERE sd.schutzbaute_sturz_andere_werksart_linie IS NOT NULL
        GROUP BY schutzbaute_t_id
    ) AS t
        ON t.schutzbaute_t_id = sawl.t_id
;