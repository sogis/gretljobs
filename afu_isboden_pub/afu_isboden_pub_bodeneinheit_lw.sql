SELECT
  pk_ogc_fid,
  gemnr,
  objnr,
  wasserhhgr,
  wasserhhgr_beschreibung,
  wasserhhgr_qgis_txt,
  bodentyp,
  bodentyp_beschreibung,
  gelform,
  gelform_beschreibung,
  geologie,
  untertyp_e,
  untertyp_k,
  untertyp_i,
  untertyp_g,
  untertyp_r,
  untertyp_p,
  untertyp_div,
  skelett_ob,
  skelett_ob_beschreibung,
  skelett_ub,
  skelett_ub_beschreibung,
  koernkl_ob,
  koernkl_ob_beschreibung,
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
  ph_ob_qgis_txt,
  ph_ub,
  ph_ub_qgis_txt,
  maechtigk_ah,
  humusgeh_ah,
  humusgeh_ah_qgis_txt,
  humusform_wa,
  humusform_wa_beschreibung,
  humusform_wa_qgis_txt,
  maechtigk_ahh,
  gefuegeform_ob,
  gefuegeform_ob_beschreibung,
  gefuegeform_t_ob_qgis_int,
  gefuegeform_ub,
  gefuegeform_ub_beschreibung,
  gefueggr_ob,
  gefueggr_ob_beschreibung,
  gefueggr_ub,
  gefueggr_ub_beschreibung,
  pflngr,
  pflngr_qgis_int,
  bodpktzahl,
  bodpktzahl_qgis_txt,
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
  nfkapwe_qgis_txt,
  verdempf,
  drain_wel,
  wassastoss,
  is_hauptauspraegung,
  gewichtung_auspraegung,
  wkb_geometry
FROM
  afu_isboden.bodeneinheit_lw_qgis_server_client_t
WHERE
  archive = 0