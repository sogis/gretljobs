SELECT 
    std.data_id AS t_id, 
    std.wkb_geometry AS geometrie, 
    std.vflz_combined_id_kt, 
    std.c_vflz_vftyp, 
    std.c_vflz_unterstand, 
    std.c_vflz_bearbstand, 
    std.c_bere_res_abwbewe_txt AS bel_teilfl, 
    std.c_bere_res_abwbewe, 
    a2.max_bel, 
    CASE
        WHEN a2.max_bel::text = '5'::text THEN 'belastet, nicht untersuchungsbedürftig'::text
        WHEN a2.max_bel::text = '3'::text THEN 'belastet, untersuchungsbedürftig'::text
        WHEN a2.max_bel::text = '2'::text THEN 'belastet, überwachungsbedürftig'::text
        WHEN a2.max_bel::text = '1'::text THEN 'belastet, sanierungsbedürftig'::text
        WHEN a2.max_bel::text = '4'::text THEN 'belastet, weder überwachungs- noch sanierungsbedürftig'::text
        ELSE NULL::text
    END AS max_bel_text
FROM 
    auszug_akt_altlasten17785.altlasten_belastete_standorte std 
    LEFT JOIN 
        ( SELECT
            min(
                CASE
                    WHEN c_bere_res_abwbewe::text = '02'::text THEN '5'::character(1)
                    WHEN c_bere_res_abwbewe::text = '03'::text THEN '3'::character(1)
                    WHEN c_bere_res_abwbewe::text = '04'::text THEN '2'::character(1)
                    WHEN c_bere_res_abwbewe::text = '05'::text THEN '1'::character(1)
                    WHEN c_bere_res_abwbewe::text = '06'::text THEN '4'::character(1)
                    ELSE '6'::bpchar
                END) AS max_bel,
            "left"(vflz_combined_id_kt::text, 12) AS bel
        FROM 
            auszug_akt_altlasten17785.altlasten_belastete_standorte 
        GROUP BY 
            "left"(vflz_combined_id_kt::text, 12)
        ) AS a2 
        ON "left"(std.vflz_combined_id_kt::text, 12) = a2.bel
;