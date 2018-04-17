SELECT * FROM (
SELECT 
    holoz.ogc_fid AS t_id, 
    holoz.wkb_geometry AS geometrie, 
    holoz.neuer_code, 
    holoz.layercode, 
    holoz.system, 
    holoz.system1, 
    codes_system1.code_text AS system_txt,
    holoz.system2, 
    holoz.serie, 
    holoz.serie1,
    codes_serie1.code_text AS serie_txt,
    holoz.serie2, 
    holoz.formation, 
    holoz.formation1, 
    codes_formation1.code_text AS formation_txt,
    holoz.formation2, 
    holoz.schichtgli,
    holoz.ausbi_fest, 
    holoz.litho_fest, 
    holoz.sacku_fest, 
    holoz.ausbi_lock, 
    codes_ausbi_lock.code_text AS ausbi_lock_txt,
    holoz.litho_lock, 
    holoz.verki_lock, 
    codes_verki_lock.code_text AS verki_lock_txt,
    holoz.durchlaess, 
    codes_durchlaess.code_text AS durchlaess_txt,
    holoz.gw_art, 
    codes_gw_art.code_text AS gw_art_txt,
    holoz.gw_fuehrun, 
    codes_gw_fuehrun.code_text AS gw_fuehrun_txt,
    holoz.gespannt, 
    codes_gespannt.code_text AS gespannt_txt,
    holoz.reib_winke,
    codes_reib_winke.code_text AS reib_winke_txt,
    holoz.kohaesion, 
    codes_kohaesion.code_text AS kohaesion_txt,
    holoz.fels_reib_, 
    codes_fels_reib.code_text AS fels_reib_txt,
    holoz.fels_kohae, 
    codes_fels_kohae.code_text AS fels_kohae_txt,
    holoz.mat_maecht, 
    codes_mat_maecht.code_text AS mat_maecht_txt,
    holoz.fehlmatmae, 
    codes_fehlmatmae.code_text AS fehlmatmae_txt,
    substr(holoz.schichtgli::text, 1, 5) AS schichtgliederung, 
    codes_schichtgliederung.code_text AS schichtgliederung_txt,
    substr(holoz.neuer_code::text, 11, 1) AS gesteinstyp, 
    substr(holoz.neuer_code::text, 13, 2) AS lithologie1, 
    codes_litho1.code_text AS lithologie1_txt,
    substr(holoz.neuer_code::text, 15, 2) AS lithologie2,
    codes_litho2.code_text AS lithologie2_txt
FROM 
    geologie.holoz
    LEFT JOIN geologie.codes AS codes_system1
        ON 
            codes_system1.code_id = holoz.system1
            AND
            codes_system1.attribut_id = 1
    LEFT JOIN geologie.codes AS codes_serie1
        ON 
            codes_serie1.code_id = holoz.serie1
            AND
            codes_serie1.attribut_id = 2
    LEFT JOIN geologie.codes AS codes_formation1
        ON 
            codes_formation1.code_id = holoz.formation1
            AND
            codes_formation1.attribut_id = 3
    LEFT JOIN geologie.codes AS codes_schichtgliederung 
        ON 
            codes_schichtgliederung.code_id = substr(holoz.schichtgli::text, 1, 5)
            AND
            codes_schichtgliederung.attribut_id = 4
    LEFT JOIN geologie.codes AS codes_ausbi_lock
        ON 
            codes_ausbi_lock.code_id = holoz.ausbi_lock
            AND
            codes_ausbi_lock.attribut_id = 10
            AND
            codes_ausbi_lock.gesteinstyp = '2'
    LEFT JOIN geologie.codes AS codes_litho1
        ON 
            codes_litho1.code_id = substr(holoz.neuer_code::text, 13, 2)
            AND
            codes_litho1.attribut_id = 11
            AND
            codes_litho1.gesteinstyp = '2'
    LEFT JOIN geologie.codes AS codes_litho2
        ON 
            codes_litho2.code_id = substr(holoz.neuer_code::text, 15, 2) 
            AND
            codes_litho2.attribut_id = 12
            AND
            codes_litho2.gesteinstyp = '2'
    LEFT JOIN geologie.codes AS codes_verki_lock
        ON 
            codes_verki_lock.code_id = holoz.verki_lock
            AND
            codes_verki_lock.attribut_id = 13
            AND
            codes_verki_lock.gesteinstyp = '2'
    LEFT JOIN geologie.codes AS codes_durchlaess
        ON 
            codes_durchlaess.code_id = holoz.durchlaess
            AND
            codes_durchlaess.attribut_id = 14
    LEFT JOIN geologie.codes AS codes_gw_art
        ON 
            codes_gw_art.code_id = holoz.gw_art
            AND
            codes_gw_art.attribut_id = 15
    LEFT JOIN geologie.codes AS codes_gw_fuehrun
        ON 
            codes_gw_fuehrun.code_id = holoz.gw_fuehrun
            AND
            codes_gw_fuehrun.attribut_id = 16
    LEFT JOIN geologie.codes AS codes_gespannt
        ON 
            codes_gespannt.code_id = holoz.gespannt
            AND
            codes_gespannt.attribut_id = 17
    LEFT JOIN geologie.codes AS codes_reib_winke
        ON 
            codes_reib_winke.code_id = holoz.reib_winke
            AND
            codes_reib_winke.attribut_id = 18
    LEFT JOIN geologie.codes AS codes_kohaesion
        ON 
            codes_kohaesion.code_id = holoz.kohaesion
            AND
            codes_kohaesion.attribut_id = 19
    LEFT JOIN geologie.codes AS codes_fels_reib
        ON 
            codes_fels_reib.code_id = holoz.fels_reib_
            AND
            codes_fels_reib.attribut_id = 20
    LEFT JOIN geologie.codes AS codes_fels_kohae
        ON 
            codes_fels_kohae.code_id = holoz.fels_kohae
            AND
            codes_fels_kohae.attribut_id = 21
    LEFT JOIN geologie.codes AS codes_mat_maecht
        ON 
            codes_mat_maecht.code_id = holoz.mat_maecht
            AND
            codes_mat_maecht.attribut_id = 22
    LEFT JOIN geologie.codes AS codes_fehlmatmae
        ON 
            codes_fehlmatmae.code_id = holoz.fehlmatmae
            AND
            codes_fehlmatmae.attribut_id = 23
WHERE 
    holoz.archive = 0) AS t
    WHERE t.fehlmatmae_txt IS NOT null
;