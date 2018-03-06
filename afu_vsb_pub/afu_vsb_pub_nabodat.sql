SELECT
    ogc_fid AS t_id,
    projektname,
    untersuchungstyp,
    "standort id" AS standort_id,
    "staokoordinate x ost" AS staokoordinate_x_ost,
    "staokoordinate y nord" AS staokoordinate_y_nord,
    "(sm) cd [mg/kg]" AS "sm_cd_mg_kg",
    "(sm) cr [mg/kg]" AS "sm_cr_mg_kg",
    "(sm) cu [mg/kg]" AS "sm_cu_mg_kg",
    "(sm) hg [mg/kg]" AS "sm_hg_mg_kg",
    "(sm) ni [mg/kg]" AS "sm_ni_mg_kg",
    "(sm) pb [mg/kg]" AS "sm_pb_mg_kg",
    "(sm) zn [mg/kg]" AS "sm_zn_mg_kg",
    "(pak) bap [ug/kg]" AS "pak_bap_ug_kg",
    "(pak) pak(16epa) [ug/kg]" AS "pak_pak16epa_ug_kg",
    "(sm) mo [mg/kg]" AS "sm_mo_mg_kg",
    "(pcb) pcb gesamt (7) [ug/kg]" AS "pcb_pcb_gesamt_7_ug_kg",
    "(sm) cd [mg/l]" AS "sm_cd_mg_l",
    "(sm) zn [mg/l]" AS "sm_zn_mg_l",
    "(sm) cu [mg/l]" AS "sm_cu_mg_l",
    "(diox) pcdd/f2 [ng i-teq/kg ts]" AS "diox_pcdd_f2_ng_i_teq_kg_ts",
    "(sm) ni [mg/l]" AS "sm_ni_mg_l",
    legende,
    wkb_geometry AS geometrie 
FROM
    vsb.nabodat
;