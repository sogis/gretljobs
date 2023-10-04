SELECT
    pr_w_prozess AS teilprozess_wasser,
    pr_geometrie AS geometrie,
    bi_storme_nr AS storme_nr,
    prozessraum.pr_evidenz AS evidenz,
    bi_massgebender_prozess AS massgebender_hauptprozess,
    bi_datenherr AS datenherr
FROM
   afu_naturereigniskataster_mgdm_v1.storme_mgdm_prozessraum_w AS prozessraum
   INNER JOIN afu_naturereigniskataster_mgdm_v1.storme_mgdm_basisinformation AS basisinformation
     ON prozessraum.bi = basisinformation.t_id AND substring(bi_storme_nr, 4, 4)::int >= 2019
   LEFT JOIN afu_naturereigniskataster_mgdm_v1.storme_mgdm_detailinformation_w_um AS detailinformation
     ON prozessraum.di_storme_mgdm_detailinformation_w_um = detailinformation.t_id
;
