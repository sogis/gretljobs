SELECT 
    pleist.ogc_fid AS t_id, 
    pleist.wkb_geometry AS geometrie, 
    pleist.neuer_code, 
    pleist.layercode, 
    pleist.system, 
    pleist.system1, 
    codes_system1.code_text AS system1_txt,
    pleist.system2, 
    pleist.serie, 
    pleist.serie1, 
    codes_serie1.code_text AS serie1_txt,
    pleist.serie2, 
    pleist.formation, 
    pleist.formation1, 
    codes_formation1.code_text AS formation1_txt,
    pleist.formation2, 
    pleist.schichtgli, 
    pleist.ausbi_fest, 
    pleist.litho_fest, 
    pleist.sacku_fest, 
    pleist.ausbi_lock, 
    codes_ausbi_lock.code_text AS ausbi_lock_txt,
    pleist.litho_lock, 
    pleist.verki_lock, 
    codes_verki_lock.code_text AS verki_lock_txt,
    pleist.durchlaess, 
    codes_durchlaess.code_text AS durchlaess_txt,
    pleist.gw_art, 
    codes_gw_art.code_text AS gw_art_txt,
    pleist.gw_fuehrun, 
    codes_gw_fuehrun.code_text AS gw_fuehrun_txt,
    pleist.gespannt, 
    codes_gespannt.code_text AS gespannt_txt,
    pleist.reib_winke, 
    codes_reib_winke.code_text AS reib_winke_txt,
    pleist.kohaesion, 
    codes_kohaesion.code_text AS kohaesion_txt,
    pleist.fels_reib_, 
    codes_fels_reib_.code_text AS fels_reib_txt,
    pleist.fels_kohae,
    codes_fels_kohae.code_text AS fels_kohae_txt,
    pleist.mat_maecht, 
    codes_mat_maecht.code_text AS mat_maecht_txt,
    pleist.fehlmatmae, 
    codes_fehlmatmae.code_text AS fehlmatmae_txt,
    substr(pleist.schichtgli::text, 1, 5) AS schichtgliederung,
    codes_schichtgliederung.code_text AS schichtgliederung_txt,
    substr(pleist.neuer_code::text, 11, 1) AS gesteinstyp, 
    substr(pleist.neuer_code::text, 13, 2) AS lithologie1, 
    codes_lithologie1.code_text AS lithologie1_txt,
    substr(pleist.neuer_code::text, 15, 2) AS lithologie2,
    codes_lithologie2.code_text AS lithologie2_txt
FROM 
    geologie.pleist
    LEFT JOIN geologie.codes AS codes_system1
        ON 
            pleist.system1 = codes_system1.code_id
            AND 
            codes_system1.attribut_id = 1
    LEFT JOIN geologie.codes AS codes_serie1
        ON 
            pleist.serie1 = codes_serie1.code_id
            AND 
            codes_serie1.attribut_id = 2
    LEFT JOIN geologie.codes AS codes_formation1
        ON 
            pleist.formation1 = codes_formation1.code_id
            AND 
            codes_formation1.attribut_id = 3
    LEFT JOIN geologie.codes AS codes_schichtgliederung
        ON 
            substr(pleist.schichtgli::text, 1, 5) = codes_schichtgliederung.code_id
            AND 
            codes_schichtgliederung.attribut_id = 4
    LEFT JOIN geologie.codes AS codes_ausbi_lock
        ON 
            pleist.ausbi_lock = codes_ausbi_lock.code_id
            AND 
            codes_ausbi_lock.attribut_id = 10
            AND
            codes_ausbi_lock.gesteinstyp = '2'
    LEFT JOIN geologie.codes AS codes_lithologie1
        ON 
            substr(pleist.neuer_code::text, 13, 2) = codes_lithologie1.code_id
            AND 
            codes_lithologie1.attribut_id = 11
            AND
            codes_lithologie1.gesteinstyp = '2'
    LEFT JOIN geologie.codes AS codes_lithologie2
        ON 
            substr(pleist.neuer_code::text, 15, 2) = codes_lithologie2.code_id
            AND 
            codes_lithologie2.attribut_id = 12
            AND
            codes_lithologie2.gesteinstyp = '2'
    LEFT JOIN geologie.codes AS codes_verki_lock
        ON 
            pleist.verki_lock = codes_verki_lock.code_id
            AND 
            codes_verki_lock.attribut_id = 13
            AND
            codes_verki_lock.gesteinstyp = '2'
    LEFT JOIN geologie.codes AS codes_durchlaess
        ON 
            pleist.durchlaess = codes_durchlaess.code_id
            AND 
            codes_durchlaess.attribut_id = 14
    LEFT JOIN geologie.codes AS codes_gw_art
        ON 
            pleist.gw_art = codes_gw_art.code_id
            AND 
            codes_gw_art.attribut_id = 15
    LEFT JOIN geologie.codes AS codes_gw_fuehrun
        ON 
            pleist.gw_fuehrun = codes_gw_fuehrun.code_id
            AND 
            codes_gw_fuehrun.attribut_id = 16
    LEFT JOIN geologie.codes AS codes_gespannt
        ON 
            pleist.gespannt = codes_gespannt.code_id
            AND 
            codes_gespannt.attribut_id = 17
    LEFT JOIN geologie.codes AS codes_reib_winke
        ON 
            pleist.reib_winke = codes_reib_winke.code_id
            AND 
            codes_reib_winke.attribut_id = 18
    LEFT JOIN geologie.codes AS codes_kohaesion
        ON 
            pleist.kohaesion = codes_kohaesion.code_id
            AND 
            codes_kohaesion.attribut_id = 19
    LEFT JOIN geologie.codes AS codes_fels_reib_
        ON 
            pleist.fels_reib_ = codes_fels_reib_.code_id
            AND 
            codes_fels_reib_.attribut_id = 20
    LEFT JOIN geologie.codes AS codes_fels_kohae
        ON 
            pleist.fels_kohae = codes_fels_kohae.code_id
            AND 
            codes_fels_kohae.attribut_id = 21
    LEFT JOIN geologie.codes AS codes_mat_maecht
        ON 
            pleist.mat_maecht = codes_mat_maecht.code_id
            AND 
            codes_mat_maecht.attribut_id = 22
    LEFT JOIN geologie.codes AS codes_fehlmatmae
        ON 
            pleist.fehlmatmae = codes_fehlmatmae.code_id
            AND 
            codes_fehlmatmae.attribut_id = 23
WHERE 
    pleist.archive = 0
;