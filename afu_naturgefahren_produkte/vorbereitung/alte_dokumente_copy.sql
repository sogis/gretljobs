WITH
alte_dokumente_view AS (
    SELECT perimeter.t_id,
        perimeter.t_ili_tid,
        perimeter.ngkid,
        perimeter.peri_name,
        perimeter.gk_n_mn,
        perimeter.erst_art,
        perimeter.erst_dat,
        perimeter.bemerkung,
        perimeter.ik_wasser,
        perimeter.ik_sturz,
        perimeter.ik_abs_ein,
        perimeter.ik_hangm,
        perimeter.ik_ru_spon,
        perimeter.ik_ru_kont,
        perimeter.gk_wasser,
        perimeter.gk_sturz,
        perimeter.gk_abs_ein,
        perimeter.gk_hangm,
        perimeter.gk_ru_spon,
        perimeter.gk_ru_kont,
        perimeter.geometrie,
        CASE
            WHEN perimeter.peri_name::text = 'Aare'::text THEN '[{"name": "200_Aare_2021.pdf", "url": "https://geo.so.ch/docs/ch.so.afu.naturgefahren/200_Aare_2021.pdf"}]'::text
            WHEN perimeter.peri_name::text = ANY (ARRAY['GK Duerrbach'::character varying::text, 'St. Katherinenbach'::character varying::text]) THEN '[{"name": "001_Solothurn_Wasser_Duerrbach_2009.pdf", "url": "https://geo.so.ch/docs/ch.so.afu.naturgefahren/001_Solothurn_Wasser_Duerrbach_2009.pdf"},{"name": "001_Solothurn_Wasser_Duerrbach_2009.pdf", "url": "https://geo.so.ch/docs/ch.so.afu.naturgefahren/001_Solothurn_Wasser_StKatharinenbach_2011.pdf"}]'::text
            WHEN perimeter.peri_name::text = 'Balm bei Guensberg Perimeter GK MB'::text THEN '[{"name": "002_Balm_bei_Guensberg_Rutsch_Stein_2011.pdf", "url": "https://geo.so.ch/docs/ch.so.afu.naturgefahren/002_Balm_bei_Guensberg_Rutsch_Stein_2011.pdf"}]'::text
            WHEN perimeter.peri_name::text = 'Objektgefahrenkarte Wildbach (Gemeinden Oberdorf, Langendorf, Bellach, Solothurn)'::text THEN '[{"name": "011_Langendorf_Wasser_Wildbach_2005.pdf", "url": "https://geo.so.ch/docs/ch.so.afu.naturgefahren/011_Langendorf_Wasser_Wildbach_2005.pdf"}]'::text
            WHEN perimeter.peri_name::text = 'Wangen bei Olten'::text THEN '[{"name": "097_Wangen_Wasser_2007.pdf", "url": "https://geo.so.ch/docs/ch.so.afu.naturgefahren/097_Wangen_Wasser_2007.pdf"}]'::text
            WHEN perimeter.peri_name::text = 'UPerimeter_Holzflue'::text OR perimeter.peri_name::text = 'UPerimeter_Klus'::text THEN '[{"name": "066_Balsthal_Sturz_2020.pdf", "url": "https://geo.so.ch/docs/ch.so.afu.naturgefahren/066_Balsthal_Sturz_2020.pdf"}]'::text
            ELSE ( SELECT ('['::text || string_agg(((('{"name": "'::text || dokumente.peri_gmde) || '", "url": "https://geo.so.ch/docs/ch.so.afu.naturgefahren/'::text) || dokumente.peri_gmde) || '"}'::text, ','::text)) || ']'::text)
        END AS dokument,
        '[{"name": "B_Lesehilfe_Gefahrenkarte_PLANAT_120309.pdf", "url": "https://geo.so.ch/docs/ch.so.afu.naturgefahren/B_Lesehilfe_Gefahrenkarte_PLANAT_120309.pdf"}]'::text AS lesehilfe
       FROM afu_gefahrenkartierung.gefahrenkartirung_perimeter_gefahrenkartierung perimeter
         LEFT JOIN ( SELECT perimeter_gemeinde.peri_gmde,
                "substring"(perimeter_gemeinde.peri_gmde, 5, "position"("substring"(perimeter_gemeinde.peri_gmde, 5), '_'::text) - 1) AS "substring"
               FROM ( VALUES ('001_Solothurn_Wasser_Duerrbach_2009.pdf'::text), ('001_Solothurn_Wasser_StKatharinenbach_2011.pdf'::text), ('001_Solothurn_Wasser_Wildbach_2005.pdf'::text), ('002_Balm_bei_Guensberg_Rutsch_Stein_2011.pdf'::text), ('003_Bellach_Rutsch_Stein_2005.pdf'::text), ('003_Bellach_Wasser_Haltenbach_Busletenbach_2007.pdf'::text), ('003_Bellach_Wasser_Wildbach_2005.pdf'::text), ('004_Bettlach_Wasser_2021.pdf'::text), ('007_Grenchen_Teil_Massenbewegungen_2005.pdf'::text), ('007_Grenchen_Wasser_2023.pdf'::text), ('009_Hubersdorf_Wasser_2012.pdf'::text), ('011_Langendorf_Wasser_Wildbach_2005.pdf'::text), ('014_Oberdorf_Wasser_2022.pdf'::text), ('015_Riedholz_Rutsch_2009.pdf'::text), ('016_Ruettenen_Wasser_2011.pdf'::text), ('017_Selzach_Rutsch_2009.pdf'::text), ('017_Selzach_Wasser_2009.pdf'::text), ('019_Aetingen_Rutsch_2009.pdf'::text), ('034_Messen_OT_Balm_Rutsch_2008.pdf'::text), ('040_Unterramsern_Vorabklaerung_Wasser_2007.pdf'::text), ('043_Biberist_Wasser ohne Emme_2022.pdf'::text), ('046_Deitingen_Wasser_2012.pdf'::text), ('047_Derendingen_Wasser_Gruettbach_2012.pdf'::text), ('049_Gerlafingen_Wasser_2008.pdf'::text), ('050_Halten_Wasser_2012.pdf'::text), ('055_Kriegstetten_Wasser_2012.pdf'::text), ('062_Subingen_Wasser_2011.pdf'::text), ('065_Aedermannsdorf_Duennern_2015.pdf'::text), ('065_Aedermannsdorf_Wasser_2009.pdf'::text), ('066_Balsthal_Duennern_2015.pdf'::text), ('066_Balsthal_Rutsch_2008.pdf'::text), ('066_Balsthal_Sturz_2020.pdf'::text), ('066_Balsthal_Wasser_2009.pdf'::text), ('068_Herbetswil_Duennern_2015.pdf'::text), ('069_Holderbank_Sturz_Talflueli_2018.pdf'::text), ('069_Holderbank_Wasser_2008.pdf'::text), ('070_Laupersdorf_Duennern_2015.pdf'::text), ('070_Laupersdorf_Wasser_2009.pdf'::text), ('071_Matzedorf_Duennern_2015.pdf'::text), ('071_Matzendorf_Wasser_2009.pdf'::text), ('072_Muemliswil_Ramiswil_Rutsch_Stein_Wasser_2000.pdf'::text), ('073_Welschenrohr_Rutsch_2009.pdf'::text), ('073_Welschenrohr_Wasser_2009.pdf'::text), ('074_Egerkingen_Duennern_2015.pdf'::text), ('074_Egerkingen_Rutsch_Stein_2008.pdf'::text), ('074_Egerkingen_Wasser_2008.pdf'::text), ('074_Egerkingen_Duennern_2015.pdf'::text), ('075_Haerkingen_Duennern_2015.pdf'::text), ('076_Kestenholz_Duennern_2015.pdf'::text), ('077_Neuendorf_Duennern_2015.pdf'::text), ('077_Neuendorf_Wasser_2007.pdf'::text), ('078_Niederbuchsiten_Duennern_2015.pdf'::text), ('078_Niederbuchsiten_Wasser_2008.pdf'::text), ('079_Oberbuchsiten_Duennern_2015.pdf'::text), ('079_Oberbuchsiten_Sturz_Rutsch_2008.pdf'::text), ('079_Oberbuchsiten_Wasser_2009.pdf'::text), ('080_Oensingen_Duennern_2015.pdf'::text), ('080_Oensingen_Rutsch_Stein_2009.pdf'::text), ('080_Oensingen_Wasser_2008.pdf'::text), ('084_Dulliken_Rutsch_1_2006.pdf'::text), ('084_Dulliken_Rutsch_2_2006.pdf'::text), ('084_Dulliken_Wasser_2022.pdf'::text), ('085_Eppenberg_Woeschnau_Sturz_Rutsch_2003.pdf'::text), ('087_Gretzenbach_Wasser_Rutsch_2021.pdf'::text), ('089_Gunzgen_Duennern_2015.pdf'::text), ('090_Haegendorf_Duennern_2015.pdf'::text), ('090_Haegendorf_Wasser_2012.pdf'::text), ('091_Kappel_Duennern_2015.pdf'::text), ('092_Olten_Duennern_2015.pdf'::text), ('092_Olten_Rutsch_Stein_2008.pdf'::text), ('092_Olten_Wasser_2009.pdf'::text), ('093_Rickenbach_Duennern_2015.pdf'::text), ('093_Rickenbach_Rutsch_2020.pdf'::text), ('093_Rickenbach_Wasser_Duennern_2015.pdf'::text), ('094_Schoenenwerd_Vorabklaerung_Rutsch_Stein_2007.pdf'::text), ('094_Schoenenwerd_Wasser_2016.pdf'::text), ('097_Wangen_Duennern_2015.pdf'::text), ('097_Wangen_Wasser_2007.pdf'::text), ('100_Lostorf_Wasser_2013.pdf'::text), ('101_Erlinsbach_Rutsch_2011.pdf'::text), ('101_Erlinsbach_Wasser_2023.pdf'::text), ('104_Obergoesgen_Wasser_2008.pdf'::text), ('105_Rohr_Wasser_2021.pdf'::text), ('106_Stuesslingen_Rutsch_Stein_2009.pdf'::text), ('106_Stuesslingen_Wasser_2022.pdf'::text), ('107_Trimbach_2021.pdf'::text), ('107_Trimbach_Sturz_Baslerstrasse_Schlussbericht_2023.pdf'::text), ('107_Trimbach_Sturz_Baslerstrasse_Bauprojekt_2022.pdf'::text), ('108_Winznau_Wasser_Rutsch_Stein_2008.pdf'::text), ('109_Winznau_SB_Baslerstrasse_2021.pdf'::text), ('110_Baettwil_Wasser_2005.pdf'::text), ('111_Bueren_Wasser_Rutsch_Sturz_2008.pdf'::text), ('112_Dornach_Wasser_2010.pdf'::text), ('115_Hofstetten_Flueh_Rutsch_Stein_2007.pdf'::text), ('115_Hofstetten_Flueh_Wasser_2010.pdf'::text), ('119_Seewen_Sturz_Gauggema_2020.pdf'::text), ('119_Seewen_Wasser_Rutsch_Stein_2002.pdf'::text), ('120_Witterswil_Wasser_Rutsch_2003.pdf'::text), ('121_Baerschwil_Sturz_SBB_2016.pdf'::text), ('121_Baerschwil_Wasser_2021.pdf'::text), ('121_Baerschwil_Wasser_Rutsch_2008.pdf'::text), ('123_Breitenbach_Rutsch_2013.pdf'::text), ('123_Breitenbach_Wasser_2009.pdf'::text), ('125_Erschwil_Wasser_Rutsch_Stein_2008.pdf'::text), ('127_Grindel_Wasser_2014.pdf'::text), ('128_Himmelried_Wasser_2008.pdf'::text), ('129_Kleinluetzel_Stein_Fluefels_2010.pdf'::text), ('129_Kleinluetzel_Wasser_Rutsch_Stein_2007.pdf'::text), ('131_Nunningen_GK_Wasser_Rutsch 2009.pdf'::text), ('132_Zullwil_Rutschung_2009.pdf'::text), ('132_Zullwil_TB_Wasser_2009.pdf'::text), ('201_Emme_2021.pdf'::text), ('B_Lesehilfe_Gefahrenkarte_PLANAT_120309.pdf'::text)) perimeter_gemeinde(peri_gmde)) dokumente ON "position"(perimeter.peri_name::text, "substring"(dokumente.peri_gmde, 5, "position"("substring"(dokumente.peri_gmde, 5), '_'::text) - 1)) > 0
      GROUP BY perimeter.t_id, perimeter.t_ili_tid, perimeter.peri_name
),

dokumente_pre_process AS (
    SELECT 
        ST_Union(st_multi(geometrie)) AS geometrie,
        dokument,
        bool_or(ik_wasser) AS ik_wasser,
        bool_or(ik_sturz) AS ik_sturz, 
        bool_or(ik_abs_ein) AS ik_abs_ein,
        bool_or(ik_hangm) AS ik_hangm,
        bool_or(ik_ru_spon) AS ik_ru_spon, 
        bool_or(ik_ru_kont) AS ik_ru_kont,
        bool_or(gk_wasser) AS gk_wasser,
        bool_or(gk_sturz) AS gk_sturz,
        bool_or(gk_abs_ein) AS gk_abs_ein,
        bool_or(gk_hangm) AS gk_hangm,
        bool_or(gk_ru_spon) AS gk_ru_spon,
        bool_or(gk_ru_kont) AS gk_ru_kont 
    FROM 
        alte_dokumente_view
    GROUP BY 
        dokument
)

,dokumente AS (
    SELECT 
        geometrie, 
        dokument AS dokument_array,
        json_array_elements(dokument::json) AS dokument,
        left(right((json_array_elements(dokument::json) ->'name')::text,9),4) AS jahr
    FROM 
        dokumente_pre_process
)

,gemeinden AS (
    SELECT
        gemeindename,
        geometrie, 
        bfs_gemeindenummer
    FROM 
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze
)

SELECT 
    gemeinden.bfs_gemeindenummer AS gemeinde_bfsnr, 
    gemeinden.gemeindename AS gemeinde_name,
    json_build_object('@type', 'SO_AFU_Naturgefahren_Publikation_20241025.Naturgefahren.Dokument',
                      'Titel', dokument->'name', 
                      'Dateiname', dokument->'name', 
                      'Link', dokument->'url',
                      'Hauptprozesse', 'obsolet',
                      'Jahr', jahr
                      ) AS dokument,
   gemeinden.geometrie AS geometrie
FROM 
    dokumente 
LEFT JOIN
    gemeinden 
    ON 
    ST_Dwithin(ST_Buffer(dokumente.geometrie,-10),gemeinden.geometrie,0)



