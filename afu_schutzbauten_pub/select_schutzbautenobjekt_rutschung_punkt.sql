WITH schutzbauten_doku_ds AS (
    SELECT
        sd.t_id,
        sd.schutzbaute_rutschung_andere_werksart_punkt,
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
                        '@type', sd.ili_type,
                        'Titel', sd.titel,
                        'Beschrieb', sd.beschrieb,
                        'DokumentImWeb', sd.dokumentimweb
                    )
                )
            )::jsonb AS dokumente_json
        FROM
            schutzbauten_doku_ds sd
        WHERE sd.schutzbaute_rutschung_andere_werksart_punkt IS NOT NULL
        GROUP BY schutzbaute_t_id
    ) AS t
        ON t.schutzbaute_t_id = rawp.t_id
;