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
        WHERE sd.schutzbaute_rutschung_hangstuetzwerk_entwassrng_plsade IS NOT NULL
        GROUP BY sd.schutzbaute_rutschung_hangstuetzwerk_entwassrng_plsade
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
        WHERE sd.schutzbaute_rutschung_hangstuetzwerk_entwassrng_plsade IS NOT NULL
        GROUP BY sd.schutzbaute_rutschung_hangstuetzwerk_entwassrng_plsade
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
        WHERE sd.schutzbaute_rutschung_hangstuetzwerk_entwassrng_plsade IS NOT NULL
        GROUP BY sd.schutzbaute_rutschung_hangstuetzwerk_entwassrng_plsade
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
        WHERE sd.schutzbaute_rutschung_auffangnetz IS NOT NULL
        GROUP BY sd.schutzbaute_rutschung_auffangnetz
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
        WHERE sd.schutzbaute_rutschung_andere_werksart_linie IS NOT NULL
        GROUP BY sd.schutzbaute_rutschung_andere_werksart_linie
    ) AS t
        ON t.schutzbaute_t_id = rawl.t_id
;