SELECT
    se_datenherr AS datenherr,
    se_name AS aname,
    se_nr AS nummer,
    se_geometrie AS geometrie,
    se_datum AS datum,
    se_datum_genauigkeit AS datum_genauigkeit,
    se_hp_wasser AS hauptprozess_wasser,
    se_hp_rutschung AS hauptprozess_rutschung,
    se_hp_sturz AS hauptprozess_sturz,
    se_hp_lawine AS hauptprozess_lawine,
    se_hp_einsturz_absenkung AS hauptprozess_einsturz_absenkung,
    se_hp_andere AS hauptprozess_anderer,
    se_gewaessername AS gewaessername,
    se_meteo_bemerkungen AS meteo_bemerkungen,
    se_schaden_bemerkungen AS schaden_bemerkungen,
    se_prozess_bemerkungen AS prozess_bemerkungen
FROM
    afu_naturereigniskataster_mgdm_v1.storme_mgdm_sammelereignis
;
