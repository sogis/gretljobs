SELECT 
    standort.data_id AS t_id, 
    standort.wkb_geometry AS geometrie, 
    standort.vflz_combined_id_kt, 
    standort.c_vflz_vftyp, 
    standort.c_vflz_unterstand, 
    standort.c_vflz_bearbstand, 
    standort.c_bere_res_abwbewe_txt AS bel_teilfl, 
    standort.c_bere_res_abwbewe, 
    a2.max_bel, 
    CASE
        WHEN a2.max_bel::text = '5'::text 
            THEN 'Belastet, keine schädlichen oder lästigen Einwirkungen zu erwarten'::text
        WHEN a2.max_bel::text = '3'::text 
            THEN 'Belastet, untersuchungsbedürftig'::text
        WHEN a2.max_bel::text = '2'::text 
            THEN 'Belastet, überwachungsbedürftig'::text
        WHEN a2.max_bel::text = '1'::text 
            THEN 'Belastet, sanierungsbedürftig'::text
        WHEN a2.max_bel::text = '4'::text 
            THEN 'Belastet, weder überwachungs- noch sanierungsbedürftig'::text
        ELSE NULL::text
    END AS max_bel_text,
    standort.c_vflz_unterstand||', '||standort.c_vflz_bearbstand AS untersuchungsstand
FROM 
    auszug_akt_altlasten17785.altlasten_belastete_standorte AS standort 
    LEFT JOIN 
        ( SELECT
            min(
                CASE
                    WHEN c_bere_res_abwbewe::text = '02'::text 
                        THEN '5'::character(1)
                    WHEN c_bere_res_abwbewe::text = '03'::text 
                        THEN '3'::character(1)
                    WHEN c_bere_res_abwbewe::text = '04'::text 
                        THEN '2'::character(1)
                    WHEN c_bere_res_abwbewe::text = '05'::text 
                        THEN '1'::character(1)
                    WHEN c_bere_res_abwbewe::text = '06'::text 
                        THEN '4'::character(1)
                    ELSE '6'::bpchar
                END) AS max_bel,
            "left"(vflz_combined_id_kt::text, 12) AS bel
        FROM 
            auszug_akt_altlasten17785.altlasten_belastete_standorte 
        GROUP BY 
            "left"(vflz_combined_id_kt::text, 12)
        ) AS a2 
        ON "left"(standort.vflz_combined_id_kt::text, 12) = a2.bel
;
