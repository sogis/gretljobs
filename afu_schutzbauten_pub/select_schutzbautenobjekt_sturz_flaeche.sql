--------------------------------------------------------------------------------
--
-- Hauptprozess Sturz
-- Schutz vor Ausbruch
-- Abdeckung
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
    'Sturz.Schutz_vor_Ausbruch.Abdeckung' AS werksart,
    'Schutz vor Ausbruch: Abdeckung' AS werksart_txt,
    material,
    bt.dispname AS material_txt,
    NULL::NUMERIC AS laenge,
    NULL::NUMERIC AS breite,
    NULL::NUMERIC AS hoehe,
    NULL::NUMERIC AS hoehe_zum_umland,
    flaeche,
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
FROM afu_schutzbauten_v1.sturz_abdeckung_verankerung savk
JOIN
    afu_schutzbauten_v1.baumaterial_typ bt
        ON bt.ilicode = savk.material
JOIN
    afu_schutzbauten_v1.koerperschaft_typ kt
        ON kt.ilicode = savk.erhaltungsverantwortung_kategorie
JOIN
    afu_schutzbauten_v1.beurteilung_typ zt
        ON zt.ilicode = savk.zustand
JOIN
    afu_schutzbauten_v1.wirksamkeit_typ wt
        ON wt.ilicode = savk.wirksamkeit
LEFT JOIN
    (
        SELECT
            sd.schutzbaute_sturz_abdeckung_verankerung as schutzbaute_t_id,
            array_to_json(
                array_agg(
                    json_build_object(
                        '@type', 'SO_AFU_Schutzbauten_Publikation_20231212.Schutzbauten.Dokument',
                        'Titel', doku.titel,
                        'Beschrieb', doku.beschrieb,
                        'DokumentImWeb', 'https://geo.so.ch/docs/ch.so.afu.schutzbauten/' || doku.dateiname
                    )
                )
            )::jsonb AS dokumente_json
        FROM
            afu_schutzbauten_v1.dokument doku
        JOIN
            afu_schutzbauten_v1.schutzbaute_dokument sd
                ON sd.dokument = doku.t_id
        WHERE sd.schutzbaute_sturz_abdeckung_verankerung IS NOT NULL
        GROUP BY sd.schutzbaute_sturz_abdeckung_verankerung
    ) AS t
        ON t.schutzbaute_t_id = savk.t_id
WHERE
    savk.art = 'Abdeckung'

UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Sturz
-- Schutz vor Ausbruch
-- Verankerung
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
    'Sturz.Schutz_vor_Ausbruch.Verankerung' AS werksart,
    'Schutz vor Ausbruch: Verankerung' AS werksart_txt,
    material,
    bt.dispname AS material_txt,
    NULL::NUMERIC AS laenge,
    NULL::NUMERIC AS breite,
    NULL::NUMERIC AS hoehe,
    NULL::NUMERIC AS hoehe_zum_umland,
    flaeche,
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
FROM afu_schutzbauten_v1.sturz_abdeckung_verankerung savk
JOIN
    afu_schutzbauten_v1.baumaterial_typ bt
        ON bt.ilicode = savk.material
JOIN
    afu_schutzbauten_v1.koerperschaft_typ kt
        ON kt.ilicode = savk.erhaltungsverantwortung_kategorie
JOIN
    afu_schutzbauten_v1.beurteilung_typ zt
        ON zt.ilicode = savk.zustand
JOIN
    afu_schutzbauten_v1.wirksamkeit_typ wt
        ON wt.ilicode = savk.wirksamkeit
LEFT JOIN
    (
        SELECT
            sd.schutzbaute_sturz_abdeckung_verankerung as schutzbaute_t_id,
            array_to_json(
                array_agg(
                    json_build_object(
                        '@type', 'SO_AFU_Schutzbauten_Publikation_20231212.Schutzbauten.Dokument',
                        'Titel', doku.titel,
                        'Beschrieb', doku.beschrieb,
                        'DokumentImWeb', 'https://geo.so.ch/docs/ch.so.afu.schutzbauten/' || doku.dateiname
                    )
                )
            )::jsonb AS dokumente_json
        FROM
            afu_schutzbauten_v1.dokument doku
        JOIN
            afu_schutzbauten_v1.schutzbaute_dokument sd
                ON sd.dokument = doku.t_id
        WHERE sd.schutzbaute_sturz_abdeckung_verankerung IS NOT NULL
        GROUP BY sd.schutzbaute_sturz_abdeckung_verankerung
    ) AS t
        ON t.schutzbaute_t_id = savk.t_id
WHERE
    savk.art = 'Verankerung'

UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Sturz
-- Schutz vor Aufprall
-- Galerie
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
    'Sturz.Schutz_vor_Aufprall.Galerie' AS werksart,
    'Schutz vor Aufprall: Galerie' AS werksart_txt,
    material,
    bt.dispname AS material_txt,
    laenge,
    breite,
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
FROM afu_schutzbauten_v1.sturz_galerie sgal
JOIN
    afu_schutzbauten_v1.baumaterial_typ bt
        ON bt.ilicode = sgal.material
JOIN
    afu_schutzbauten_v1.koerperschaft_typ kt
        ON kt.ilicode = sgal.erhaltungsverantwortung_kategorie
JOIN
    afu_schutzbauten_v1.beurteilung_typ zt
        ON zt.ilicode = sgal.zustand
JOIN
    afu_schutzbauten_v1.wirksamkeit_typ wt
        ON wt.ilicode = sgal.wirksamkeit
LEFT JOIN
    (
        SELECT
            sd.schutzbaute_sturz_galerie as schutzbaute_t_id,
            array_to_json(
                array_agg(
                    json_build_object(
                        '@type', 'SO_AFU_Schutzbauten_Publikation_20231212.Schutzbauten.Dokument',
                        'Titel', doku.titel,
                        'Beschrieb', doku.beschrieb,
                        'DokumentImWeb', 'https://geo.so.ch/docs/ch.so.afu.schutzbauten/' || doku.dateiname
                    )
                )
            )::jsonb AS dokumente_json
        FROM
            afu_schutzbauten_v1.dokument doku
        JOIN
            afu_schutzbauten_v1.schutzbaute_dokument sd
                ON sd.dokument = doku.t_id
        WHERE sd.schutzbaute_sturz_galerie IS NOT NULL
        GROUP BY sd.schutzbaute_sturz_galerie
    ) AS t
        ON t.schutzbaute_t_id = sgal.t_id

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
FROM afu_schutzbauten_v1.sturz_andere_werksart_flaeche sawf
JOIN
    afu_schutzbauten_v1.baumaterial_typ bt
        ON bt.ilicode = sawf.material
JOIN
    afu_schutzbauten_v1.koerperschaft_typ kt
        ON kt.ilicode = sawf.erhaltungsverantwortung_kategorie
JOIN
    afu_schutzbauten_v1.beurteilung_typ zt
        ON zt.ilicode = sawf.zustand
JOIN
    afu_schutzbauten_v1.wirksamkeit_typ wt
        ON wt.ilicode = sawf.wirksamkeit
LEFT JOIN
    (
        SELECT
            sd.schutzbaute_sturz_andere_werksart_flaeche as schutzbaute_t_id,
            array_to_json(
                array_agg(
                    json_build_object(
                        '@type', 'SO_AFU_Schutzbauten_Publikation_20231212.Schutzbauten.Dokument',
                        'Titel', doku.titel,
                        'Beschrieb', doku.beschrieb,
                        'DokumentImWeb', 'https://geo.so.ch/docs/ch.so.afu.schutzbauten/' || doku.dateiname
                    )
                )
            )::jsonb AS dokumente_json
        FROM
            afu_schutzbauten_v1.dokument doku
        JOIN
            afu_schutzbauten_v1.schutzbaute_dokument sd
                ON sd.dokument = doku.t_id
        WHERE sd.schutzbaute_sturz_andere_werksart_flaeche IS NOT NULL
        GROUP BY sd.schutzbaute_sturz_andere_werksart_flaeche
    ) AS t
        ON t.schutzbaute_t_id = sawf.t_id
;