TRUNCATE afu_bodeneinheiten_v1.bodeneinheithauptauspraegung_landwirtschaft CASCADE;

WITH dataset AS ( 
    SELECT  
        t_id
    FROM 
        afu_bodeneinheiten_v1.t_ili2db_dataset 
    WHERE  
        datasetname = 'migration'
), 
basket AS (
    SELECT 
        t_id  
    FROM 
        afu_bodeneinheiten_v1.t_ili2db_basket 
    WHERE  
        attachmentkey = 'migration'
), 
geometrie_from_isboden AS (
    SELECT  
        wkb_geometry AS geometrie, 
        objnr, 
        gemnr 
    FROM 
        afu_isboden.bodeneinheit_t
)        

INSERT INTO afu_bodeneinheiten_v1.bodeneinheithauptauspraegung_landwirtschaft (
    t_basket, 
    t_datasetname,
    bodeneinheit_nummer,
    gemeinde_nr,
    kartierjahr,
    kartierquartal,
    los,
    alte_daten_vorhanden,
    import_oid,
    gewichtung,
    wasserhaushalt,
    bodentyp,
    gelaendeform,
    geologie,
    karbonatgrenze,
    maechtigkeit_ah,
    humusgehalt_ah,
    bemerkungen,
    bodenpunktzahl,
    pflanzennutzbaregruendigkeit,
    untertyp_e,
    untertyp_i,
    untertyp_g,
    untertyp_r,
    oberboden0_t_type,
    oberboden0_tongehalt,
    oberboden0_koernungsklasse,
    oberboden0_schluffgehalt,
    oberboden0_kalkgehalt,
    oberboden0_ph,
    oberboden0_gefuegeform,
    oberboden0_gefuegegroesse,
    oberboden0_skelettgehalt_oberboden,
    unterboden0_t_type,
    unterboden0_tongehalt,
    unterboden0_koernungsklasse,
    unterboden0_schluffgehalt,
    unterboden0_kalkgehalt,
    unterboden0_ph,
    unterboden0_gefuegeform,
    unterboden0_gefuegegroesse,
    unterboden0_skelettgehalt_unterboden,
    ohne_oberboden,
    ohne_unterboden, 
    geometrie
)
SELECT
    basket.t_id, 
    dataset.t_id,
    imp.objnr,  
    imp.gemnr,
    imp.kartierjahr,
    imp.kartierquartal,
    los_tab.t_id AS los,
    'nein',
    imp.t_id,
    imp.gewichtung_auspraegung,
    imp.wasserhhgr,
    imp.bodentyp,
    imp.gelform,
    imp.geologie,
    imp.karbgrenze,
    imp.maechtigk_ah,
    imp.humusgeh_ah,
    imp.bemerkungen,
    imp.bodpktzahl,
    imp.pflngr,
    imp.untertyp_e,
    imp.untertyp_i,
    imp.untertyp_g,
    imp.untertyp_r,
    'oberboden_landwirtschaft',
    imp.ton_ob,
    CASE 
      WHEN imp.koernkl_ob = 1 THEN 'sand'
      WHEN imp.koernkl_ob = 2 THEN 'schluffiger_sand'
      WHEN imp.koernkl_ob = 3 THEN 'lehmiger_sand'
      WHEN imp.koernkl_ob = 4 THEN 'lehmreicher_sand'
      WHEN imp.koernkl_ob = 5 THEN 'sandiger_lehm'
      WHEN imp.koernkl_ob = 6 THEN 'lehm'
      WHEN imp.koernkl_ob = 7 THEN 'toniger_lehm'
      WHEN imp.koernkl_ob = 8 THEN 'lehmiger_ton'
      WHEN imp.koernkl_ob = 9 THEN 'ton'
      WHEN imp.koernkl_ob = 10 THEN 'sandiger_schluff'
      WHEN imp.koernkl_ob = 11 THEN 'schluff'
      WHEN imp.koernkl_ob = 12 THEN 'lehmiger_schluff'
      WHEN imp.koernkl_ob = 13 THEN 'toniger_schluff'
    END,
    imp.schluff_ob,
    CASE 
      WHEN imp.kalkgeh_ob = 0 THEN 'kein_kalk'
      WHEN imp.kalkgeh_ob = 1 THEN 'nur_im_skelett'
      WHEN imp.kalkgeh_ob = 2 THEN 'sehr_wenig'
      WHEN imp.kalkgeh_ob = 3 THEN 'wenig'
      WHEN imp.kalkgeh_ob = 4 THEN 'mittel'
      WHEN imp.kalkgeh_ob = 5 THEN 'viel'
    END,
    imp.ph_ob,
    imp.gefuegeform_ob,
    CASE 
      WHEN imp.gefueggr_ob = 1 THEN 'kleiner_als_2'
      WHEN imp.gefueggr_ob = 2 THEN 'von_2_bis_5'
      WHEN imp.gefueggr_ob = 3 THEN 'von_5_bis_10'
      WHEN imp.gefueggr_ob = 4 THEN 'von_10_bis_20'
      WHEN imp.gefueggr_ob = 5 THEN 'von_20_bis_50'
      WHEN imp.gefueggr_ob = 6 THEN 'von_50_bis_100'
      WHEN imp.gefueggr_ob = 7 THEN 'groesser_als_100'
    END,
    CASE 
      WHEN imp.skelett_ob = 0 THEN 'skelettfrei'
      WHEN imp.skelett_ob = 1 THEN 'schwach_skeletthaltig'
      WHEN imp.skelett_ob = 2 THEN 'kieshaltig'
      WHEN imp.skelett_ob = 3 THEN 'steinhaltig'
      WHEN imp.skelett_ob = 4 THEN 'stark_kieshaltig'
      WHEN imp.skelett_ob = 5 THEN 'stark_steinhaltig'
      WHEN imp.skelett_ob = 6 THEN 'kiesreich'
      WHEN imp.skelett_ob = 7 THEN 'steinreich'
      WHEN imp.skelett_ob = 8 THEN 'kies'
      WHEN imp.skelett_ob = 9 THEN 'geroell'
    END,
    'unterboden_landwirtschaft',
    imp.ton_ub,
    CASE 
      WHEN imp.koernkl_ub = 1 THEN 'sand'
      WHEN imp.koernkl_ub = 2 THEN 'schluffiger_sand'
      WHEN imp.koernkl_ub = 3 THEN 'lehmiger_sand'
      WHEN imp.koernkl_ub = 4 THEN 'lehmreicher_sand'
      WHEN imp.koernkl_ub = 5 THEN 'sandiger_lehm'
      WHEN imp.koernkl_ub = 6 THEN 'lehm'
      WHEN imp.koernkl_ub = 7 THEN 'toniger_lehm'
      WHEN imp.koernkl_ub = 8 THEN 'lehmiger_ton'
      WHEN imp.koernkl_ub = 9 THEN 'ton'
      WHEN imp.koernkl_ub = 10 THEN 'sandiger_schluff'
      WHEN imp.koernkl_ub = 11 THEN 'schluff'
      WHEN imp.koernkl_ub = 12 THEN 'lehmiger_schluff'
      WHEN imp.koernkl_ub = 13 THEN 'toniger_schluff'
    END,
    imp.schluff_ub,
    CASE 
      WHEN imp.kalkgeh_ub = 0 THEN 'kein_kalk'
      WHEN imp.kalkgeh_ub = 1 THEN 'nur_im_skelett'
      WHEN imp.kalkgeh_ub = 2 THEN 'sehr_wenig'
      WHEN imp.kalkgeh_ub = 3 THEN 'wenig'
      WHEN imp.kalkgeh_ub = 4 THEN 'mittel'
      WHEN imp.kalkgeh_ub = 5 THEN 'viel'
    END,
    imp.ph_ub,
    imp.gefuegeform_ub,
    CASE 
      WHEN imp.gefueggr_ub = 1 THEN 'kleiner_als_2'
      WHEN imp.gefueggr_ub = 2 THEN 'von_2_bis_5'
      WHEN imp.gefueggr_ub = 3 THEN 'von_5_bis_10'
      WHEN imp.gefueggr_ub = 4 THEN 'von_10_bis_20'
      WHEN imp.gefueggr_ub = 5 THEN 'von_20_bis_50'
      WHEN imp.gefueggr_ub = 6 THEN 'von_50_bis_100'
      WHEN imp.gefueggr_ub = 7 THEN 'groesser_als_100'
    END,
    CASE 
      WHEN imp.skelett_ub = 0 THEN 'skelettfrei'
      WHEN imp.skelett_ub = 1 THEN 'schwach_skeletthaltig'
      WHEN imp.skelett_ub = 2 THEN 'kieshaltig'
      WHEN imp.skelett_ub = 3 THEN 'steinhaltig'
      WHEN imp.skelett_ub = 4 THEN 'stark_kieshaltig'
      WHEN imp.skelett_ub = 5 THEN 'stark_steinhaltig'
      WHEN imp.skelett_ub = 6 THEN 'kiesreich'
      WHEN imp.skelett_ub = 7 THEN 'steinreich'
      WHEN imp.skelett_ub = 8 THEN 'kies'
      WHEN imp.skelett_ub = 9 THEN 'geroell'
    END,
    imp.ohne_oberboden,
    imp.ohne_unterboden, 
    geometrie_from_isboden.geometrie 
  FROM 
    dataset, 
    basket,
    afu_bodeneinheiten_v1.import_table imp
LEFT JOIN 
    afu_bodeneinheiten_v1.los los_tab  
    ON 
    imp.los = los_tab.los 
LEFT JOIN 
    geometrie_from_isboden 
    ON 
    geometrie_from_isboden.gemnr = imp.gemnr 
    AND 
    geometrie_from_isboden.objnr = imp.objnr 
WHERE 
    imp.ist_hauptauspraegung = 'true'
    AND 
    imp.ist_wald = 'false' 
; 