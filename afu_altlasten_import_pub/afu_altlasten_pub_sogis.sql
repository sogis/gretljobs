SELECT
    standort.t_id AS data_id,
    standort.geometrie AS wkb_geometry,
    standort_restricted.bezeichnung,
    standort.standortnummer AS vflz_combined_id_kt,
    split_part(standort.stand, ' / ', 2) AS c_vflz_bearbstand,
    CASE
        WHEN standort.bewertung = 'Belastet, keine schädlichen oder lästigen Einwirkungen zu erwarten'
            THEN '02'
        WHEN standort.bewertung = 'Belastet, untersuchungsbedürftig'
            THEN '03'
        WHEN standort.bewertung = 'Belastet, überwachungsbedürftig'
            THEN '04'
        WHEN standort.bewertung = 'Belastet, sanierungsbedürftig'
            THEN '05'       
        WHEN standort.bewertung = 'Belastet, weder überwachungs- noch sanierungsbedürftig'
            THEN '06'  
    END AS c_bere_res_abwbewe,
    standort.bewertung AS c_bere_res_abwbewe_txt,
    split_part(standort.stand, ' / ', 1) AS c_vflz_unterstand,
    standort.standorttyp AS c_vflz_vftyp
FROM
    afu_altlasten_pub_v2.belasteter_standort AS standort
    LEFT JOIN afu_altlasten_restricted_pub_v1.belasteter_standort AS standort_restricted
    ON standort.standortnummer = standort_restricted.standortnummer
;
