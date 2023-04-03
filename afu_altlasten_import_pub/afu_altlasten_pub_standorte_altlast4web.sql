SELECT
    t_id,
    geometrie AS geometrie,
    bezeichnung,
    standortnummer AS vflz_combined_id_kt,
    untersuchungsstand||', '||bearbeitungsstand AS c_vflz_bearbstand,
    CASE
        WHEN bewertung = 'Belastet, keine schädlichen oder lästigen Einwirkungen zu erwarten'
            THEN '02'
        WHEN bewertung = 'Belastet, untersuchungsbedürftig'
            THEN '03'
        WHEN bewertung = 'Belastet, überwachungsbedürftig'
            THEN '04'
        WHEN bewertung = 'Belastet, sanierungsbedürftig'
            THEN '05'       
        WHEN bewertung = 'Belastet, weder überwachungs- noch sanierungsbedürftig'
            THEN '06'  
    END AS c_bere_res_abwbewe,
    bewertung AS c_bere_res_abwbewe_txt,
    untersuchungsstand AS c_vflz_unterstand,
    standorttyp AS c_vflz_vftyp
FROM
    afu_altlasten_restricted_pub_v1.belasteter_standort
;
