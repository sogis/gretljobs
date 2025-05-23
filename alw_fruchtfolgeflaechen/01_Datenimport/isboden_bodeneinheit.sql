SELECT 
    t_id,
    gemnr, 
    objnr, 
    wasserhhgr, 
    wasserhhgr_beschreibung, 
    charakter_wasserhaushalt, 
    wasserhaushalt_spezifisch, 
    wasserhaushalt_uebergreifend, 
    bodentyp, 
    bodentyp_beschreibung, 
    gelform, 
    gelform_text, 
    gelform_beschreibung, 
    geologie, 
    skelett_ob, 
    skelett_ob_text, 
    skelett_ob_beschreibung, 
    skelett_ub, 
    skelett_ub_text, 
    skelett_ub_beschreibung, 
    koernkl_ob, 
    koernkl_ob_beschreibung, 
    bodenart_bodenbearbeitbarkeit, 
    koernkl_ub, 
    koernkl_ub_beschreibung, 
    ton_ob, 
    ton_ub, 
    schluff_ob, 
    schluff_ub, 
    karbgrenze, 
    kalkgeh_ob, 
    kalkgeh_ob_beschreibung, 
    kalkgeh_ub, 
    kalkgeh_ub_beschreibung, 
    ph_ob, 
    ph_ob_text, 
    ph_ub, 
    ph_ub_text, 
    maechtigk_ah, 
    humusgeh_ah, 
    humusgeh_ah_text, 
    humusform_wa, 
    humusform_wa_beschreibung, 
    humusform_wa_text, 
    maechtigk_ahh, 
    gefuegeform_ob, 
    gefuegeform_ob_beschreibung, 
    gefuegeform_ob_int, 
    gefuegeform_ub, 
    gefuegeform_ub_beschreibung, 
    gefueggr_ob, 
    gefueggr_ob_beschreibung, 
    gefueggr_ub, 
    gefueggr_ub_beschreibung, 
    pflngr, 
    pflngr_qgis_int, 
    pflngr_text, 
    bodpktzahl, 
    bodpktzahl_text, 
    bemerkungen, 
    los, 
    kartierjahr, 
    kartierer, 
    kartierquartal, 
    is_wald, 
    bindst_cd, 
    bindst_zn, 
    bindst_cu, 
    bindst_pb, 
    nfkapwe_ob, 
    nfkapwe_ub, 
    nfkapwe, 
    nfkapwe_text, 
    verdempf, 
    verdempf_text, 
    drain_wel, wassastoss, 
    is_hauptauspraegung, 
    gewichtung_auspraegung, 
    geometrie, 
    untertyp, 
    gemnr_aktuell
FROM 
    afu_isboden_fff_pub.bodeneinheit
;
