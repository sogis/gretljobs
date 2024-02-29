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
        WHERE sd.schutzbaute_wasser_bruecke_steg IS NOT NULL
        GROUP BY sd.schutzbaute_wasser_bruecke_steg
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
        WHERE sd.schutzbaute_wasser_furt IS NOT NULL
        GROUP BY sd.schutzbaute_wasser_furt
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
        WHERE sd.schutzbaute_wasser_andere_werksart_punkt IS NOT NULL
        GROUP BY sd.schutzbaute_wasser_andere_werksart_punkt
    ) AS t
        ON t.schutzbaute_t_id = wawp.t_id

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
FROM afu_schutzbauten_v1.rutschung_andere_werksart_punkt rawp
JOIN
    afu_schutzbauten_v1.baumaterial_typ bt
        ON bt.ilicode = rawp.material
JOIN
    afu_schutzbauten_v1.koerperschaft_typ kt
        ON kt.ilicode = rawp.erhaltungsverantwortung_kategorie
JOIN
    afu_schutzbauten_v1.beurteilung_typ zt
        ON zt.ilicode = rawp.zustand
JOIN
    afu_schutzbauten_v1.wirksamkeit_typ wt
        ON wt.ilicode = rawp.wirksamkeit
LEFT JOIN
    (
        SELECT
            sd.schutzbaute_rutschung_andere_werksart_punkt as schutzbaute_t_id,
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
        WHERE sd.schutzbaute_rutschung_andere_werksart_punkt IS NOT NULL
        GROUP BY sd.schutzbaute_rutschung_andere_werksart_punkt
    ) AS t
        ON t.schutzbaute_t_id = rawp.t_id

UNION

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
        WHERE sd.schutzbaute_sturz_unterfangung IS NOT NULL
        GROUP BY sd.schutzbaute_sturz_unterfangung
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
        WHERE sd.schutzbaute_sturz_unterfangung IS NOT NULL
        GROUP BY sd.schutzbaute_sturz_unterfangung
    ) AS t
        ON t.schutzbaute_t_id = sawp.t_id