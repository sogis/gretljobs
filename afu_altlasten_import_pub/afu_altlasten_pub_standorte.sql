SELECT
    standort.t_id,
    standort.geometrie AS geometrie,
    standort.standortnummer AS vflz_combined_id_kt,
    split_part(stand, ' / ', 2) AS c_vflz_bearbstand,
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
    bewertung AS bel_teilfl,
    split_part(stand, ' / ', 1) AS c_vflz_unterstand,
    standorttyp AS c_vflz_vftyp,
    a2.max_bel AS max_bel,
    CASE
        WHEN a2.max_bel = '5' 
            THEN 'Belastet, keine schädlichen oder lästigen Einwirkungen zu erwarten'
        WHEN a2.max_bel = '3' 
            THEN 'Belastet, untersuchungsbedürftig'
        WHEN a2.max_bel = '2' 
            THEN 'Belastet, überwachungsbedürftig'
        WHEN a2.max_bel = '1' 
            THEN 'Belastet, sanierungsbedürftig'
        WHEN a2.max_bel = '4' 
            THEN 'Belastet, weder überwachungs- noch sanierungsbedürftig'
        ELSE NULL
    END AS max_bel_text,
    stand AS untersuchungsstand
FROM
    afu_altlasten_pub_v2.belasteter_standort AS standort
    LEFT JOIN 
        ( SELECT
            min(
                CASE
                    WHEN bewertung = 'Belastet, keine schädlichen oder lästigen Einwirkungen zu erwarten' 
                        THEN '5'
                    WHEN bewertung = 'Belastet, untersuchungsbedürftig' 
                        THEN '3'
                    WHEN bewertung = 'Belastet, überwachungsbedürftig' 
                        THEN '2'
                    WHEN bewertung = 'Belastet, sanierungsbedürftig' 
                        THEN '1'
                    WHEN bewertung = 'Belastet, weder überwachungs- noch sanierungsbedürftig' 
                        THEN '4'
                    ELSE '6'
                END) AS max_bel,
            "left"(standortnummer, 12) AS bel
        FROM 
            afu_altlasten_pub_v2.belasteter_standort
        GROUP BY 
            "left"(standortnummer, 12)
        ) AS a2 
        ON "left"(standort.standortnummer, 12) = a2.bel
;
