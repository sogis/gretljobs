SELECT 
    grunds.ogc_fid AS t_id, 
    grunds.wkb_geometry AS geometrie,     
    grunds.neuer_code, 
    grunds.layercode, 
    grunds.system, 
    grunds.system1,
    codes_system1.code_text AS system1_txt,
    grunds.system2, 
    grunds.serie, 
    grunds.serie1, 
    codes_serie1.code_text AS serie1_txt,
    grunds.serie2,     
    grunds.formation, 
    grunds.formation1,
    codes_formation1.code_text AS formation1_txt,
    grunds.formation2, 
    grunds.schichtgli,
    substr(grunds.schichtgli::text, 1, 5) AS schichtgliederung,
    codes_schichtgliederung.code_text AS schichtgliederung_txt,
    grunds.ausbi_fest, 
    codes_ausbi_fest.code_text AS ausbi_fest_txt,
    grunds.litho_fest, 
    grunds.sacku_fest, 
    codes_sacku_fest.code_text AS sacku_fest_txt,
    grunds.ausbi_lock,     
    grunds.litho_lock, 
    substr(grunds.neuer_code::text, 13, 2) AS lithologie1,
    codes_lithologie1.code_text AS lithologie1_txt,
    substr(grunds.neuer_code::text, 15, 2) AS lithologie2,
    codes_lithologie2.code_text AS lithologie2_txt,
    grunds.verki_lock, 
    grunds.durchlaess, 
    codes_durchlaess.code_text AS durchlaess_txt,
    grunds.gw_art,  
    codes_gw_art.code_text AS gw_art_txt,
    grunds.gw_fuehrun, 
    codes_gw_fuehrun.code_text AS gw_fuehrun_txt,
    grunds.gespannt, 
    codes_gespannt.code_text AS gespannt_txt,
    grunds.reib_winke, 
    codes_reib_winke.code_text AS reib_winke_txt,
    grunds.kohaesion,  
    codes_kohaesion.code_text AS kohaesion_txt,
    grunds.fels_reib_, 
    codes_fels_reibe_.code_text AS fels_reib_txt,
    grunds.fels_kohae, 
    codes_fels_kohae.code_text AS fels_kohae_txt,
    grunds.mat_maecht,
    codes_mat_maecht.code_text AS mat_maecht_txt,
    grunds.fehlmatmae,    
    codes_fehlmatmae.code_text AS fehlmatmae_txt,
    grunds.maxwinkel, 
    grunds.midwinkel, 
    grunds.minwinkel,
    substr(grunds.neuer_code::text, 11, 1) AS gesteinstyp
FROM 
    geologie.grunds
    LEFT JOIN geologie.codes AS codes_system1
        ON 
            grunds.system1 = codes_system1.code_id
            AND 
            codes_system1.attribut_id = 1
    LEFT JOIN geologie.codes AS codes_serie1
        ON 
            grunds.serie1 = codes_serie1.code_id
            AND 
            codes_serie1.attribut_id = 2
    LEFT JOIN geologie.codes AS codes_formation1
        ON 
            grunds.formation1 = codes_formation1.code_id
            AND 
            codes_formation1.attribut_id = 3
    LEFT JOIN geologie.codes AS codes_schichtgliederung
        ON 
            substr(grunds.schichtgli::text, 1, 5) = codes_schichtgliederung.code_id
            AND 
            codes_schichtgliederung.attribut_id = 4
    LEFT JOIN geologie.codes AS codes_ausbi_fest
        ON 
            grunds.ausbi_fest = codes_ausbi_fest.code_id
            AND 
            codes_ausbi_fest.attribut_id = 10
            AND
            codes_ausbi_fest.gesteinstyp = '1'
    LEFT JOIN geologie.codes AS codes_lithologie1
        ON 
            substr(grunds.neuer_code::text, 13, 2) = codes_lithologie1.code_id
            AND 
            codes_lithologie1.attribut_id = 11
            AND
            codes_lithologie1.gesteinstyp = '1'
     LEFT JOIN geologie.codes AS codes_lithologie2
        ON 
            substr(grunds.neuer_code::text, 15, 2) = codes_lithologie2.code_id
            AND 
            codes_lithologie2.attribut_id = 12
            AND
            codes_lithologie2.gesteinstyp = '1'
    LEFT JOIN geologie.codes AS codes_sacku_fest
        ON 
            grunds.sacku_fest = codes_sacku_fest.code_id
            AND 
            codes_sacku_fest.attribut_id = 13
            AND
            codes_sacku_fest.gesteinstyp = '1'
    LEFT JOIN geologie.codes AS codes_durchlaess
        ON 
            grunds.durchlaess = codes_durchlaess.code_id
            AND 
            codes_durchlaess.attribut_id = 14
    LEFT JOIN geologie.codes AS codes_gw_art
        ON 
            grunds.gw_art = codes_gw_art.code_id
            AND 
            codes_gw_art.attribut_id = 15
    LEFT JOIN geologie.codes AS codes_gw_fuehrun
        ON 
            grunds.gw_fuehrun = codes_gw_fuehrun.code_id
            AND 
            codes_gw_fuehrun.attribut_id = 16
    LEFT JOIN geologie.codes AS codes_gespannt
        ON 
            grunds.gespannt = codes_gespannt.code_id
            AND 
            codes_gespannt.attribut_id = 17
    LEFT JOIN geologie.codes AS codes_reib_winke
        ON 
            grunds.reib_winke = codes_reib_winke.code_id
            AND 
            codes_reib_winke.attribut_id = 18
    LEFT JOIN geologie.codes AS codes_kohaesion
        ON 
            grunds.kohaesion = codes_kohaesion.code_id
            AND 
            codes_kohaesion.attribut_id = 19
    LEFT JOIN geologie.codes AS codes_fels_reibe_
        ON 
            grunds.fels_reib_ = codes_fels_reibe_.code_id
            AND 
            codes_fels_reibe_.attribut_id = 20
    LEFT JOIN geologie.codes AS codes_fels_kohae
        ON 
            grunds.fels_kohae = codes_fels_kohae.code_id
            AND 
            codes_fels_kohae.attribut_id = 21
    LEFT JOIN geologie.codes AS codes_mat_maecht
        ON 
            grunds.mat_maecht = codes_mat_maecht.code_id
            AND 
            codes_mat_maecht.attribut_id = 22
    LEFT JOIN geologie.codes AS codes_fehlmatmae
        ON 
            grunds.fehlmatmae= codes_fehlmatmae.code_id
            AND 
            codes_fehlmatmae.attribut_id = 23
WHERE 
    grunds.archive = 0
;
