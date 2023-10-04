SELECT
    bi_geometrie AS geometrie,
    bi_datenherr AS datenherr,
    bi_storme_nr AS storme_nr,
    bi_hp_wasser AS hauptprozess_wasser,
    bi_hp_rutschung AS hauptprozess_rutschung,
    bi_hp_sturz AS hauptprozess_sturz,
    bi_hp_lawine AS hauptprozess_lawine,
    bi_hp_einsturz_absenkung AS hauptprozess_einsturz_absenkung,
    bi_hp_andere AS hauptprozess_anderer,
    bi_massgebender_prozess AS massgebender_hauptprozess,
    bi_datum::date AS ereignisdatum,
    bi_datum_genauigkeit AS datumsgenauigkeit,
    bi_erhebungsart AS erhebungsart,
    bi_name_lokalitaet AS name_lokalitaet,
    bi_gemeinde AS gemeinde,
CASE
    WHEN
        bi_bemerkungen IS NULL
            THEN 'keine'
    ELSE
        bi_bemerkungen
END AS bemerkungen_basisinformationen,
    sc_mensch_tier AS schaeden_an_menschen_tieren,
    sc_menschen_tot AS todesfaelle_an_menschen,
    sc_menschen_verletzt AS menschen_verletzt,
    sc_tiere AS tote_oder_verletzte_tiere,
    sc_sachwerte AS schaeden_an_sachwerten,
    sc_infrastruktur AS schaeden_an_infrastruktur_verbindungen,
    sc_lw_wald AS schaeden_an_landwirtschaftsland_wald,
CASE
    WHEN
        sc_bemerkungen IS NULL
            THEN 'keine'
    ELSE
        sc_bemerkungen
END AS bemerkungen_schaeden
FROM
    afu_naturereigniskataster_mgdm_v1.storme_mgdm_basisinformation AS basisinformation
    LEFT JOIN afu_naturereigniskataster_mgdm_v1.storme_mgdm_schaden AS schaden 
        ON basisinformation.t_id = schaden.bi
;
