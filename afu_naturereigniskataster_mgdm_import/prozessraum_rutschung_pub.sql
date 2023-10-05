SELECT
    pr_r_prozess AS teilprozess_rutschung,
    pr_geometrie AS geometrie,
    bi_storme_nr AS storme_nr,
    prozessraum.pr_evidenz AS evidenz,
    bi_massgebender_prozess AS massgebender_hauptprozess,
    bi_datenherr AS datenherr
FROM
    afu_naturereigniskataster_mgdm_v1.storme_mgdm_prozessraum_r AS prozessraum
    INNER JOIN afu_naturereigniskataster_mgdm_v1.storme_mgdm_basisinformation AS basisinformation
      ON prozessraum.bi = basisinformation.t_id  AND pr_evidenz <> 'externe_Datenquelle'
    LEFT JOIN afu_naturereigniskataster_mgdm_v1.storme_mgdm_detailinformation_r AS detailinformation
      ON prozessraum.di_storme_mgdm_detailinformation_r = detailinformation.t_id
;
