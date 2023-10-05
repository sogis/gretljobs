SELECT
    pr_l_prozess AS teilprozess_lawine,
    pr_geometrie AS geometrie,
    prozessraum.pr_evidenz AS evidenz,
    bi_massgebender_prozess AS massgebender_hauptprozess,
    bi_datenherr AS datenherr
FROM
   afu_naturereigniskataster_mgdm_v1.storme_mgdm_prozessraum_l AS prozessraum
   INNER JOIN afu_naturereigniskataster_mgdm_v1.storme_mgdm_basisinformation AS basisinformation
     ON prozessraum.bi = basisinformation.t_id AND pr_evidenz <> 'externe_Datenquelle'
   LEFT JOIN afu_naturereigniskataster_mgdm_v1.storme_mgdm_detailinformation_l AS detailinformation
     ON prozessraum.di_storme_mgdm_detailinformation_l = detailinformation.t_id
;
