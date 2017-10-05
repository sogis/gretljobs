select data_id, wkb_geometry, vflz_combined_id_kt, c_vflz_vftyp, 
    c_vflz_unterstand, c_vflz_bearbstand, c_bere_res_abwbewe_txt AS bel_teilfl, 
    c_bere_res_abwbewe, max_bel,CASE
            WHEN a2.max_bel = '5'::character(1)::text THEN 'belastet, nicht untersuchungsbedürftig'::text
            WHEN a2.max_bel = '3'::character(1)::text THEN 'belastet, untersuchungsbedürftig'::text
            WHEN a2.max_bel = '2'::character(1)::text THEN 'belastet, überwachungsbdürftig'::text
            WHEN a2.max_bel = '1'::character(1)::text THEN 'belastet, sanierungsbedürftig'::text
            WHEN a2.max_bel = '4'::character(1)::text THEN 'belastet, weder überwachungs- noch sanierungsbedürftig'::text
            ELSE NULL::text
        END AS max_bel_text
from auszug_akt_altlasten17785.altlasten_belastete_standorte
left join ( select min(CASE
            WHEN c_bere_res_abwbewe::text = '02'::text THEN '5'::character(1)
            WHEN c_bere_res_abwbewe::text = '03'::text THEN '3'::character(1)
            WHEN c_bere_res_abwbewe::text = '04'::text THEN '2'::character(1)
            WHEN c_bere_res_abwbewe::text = '05'::text THEN '1'::character(1)
            WHEN c_bere_res_abwbewe::text = '06'::text THEN '4'::character(1)
            ELSE '6'::bpchar
        END) AS max_bel, "left"(vflz_combined_id_kt::text, 12) AS bel
            from auszug_akt_altlasten17785.altlasten_belastete_standorte
            group by "left"(vflz_combined_id_kt::text, 12)) a2 ON "left"(auszug_akt_altlasten17785.altlasten_belastete_standorte.vflz_combined_id_kt::text, 12) = a2.bel

