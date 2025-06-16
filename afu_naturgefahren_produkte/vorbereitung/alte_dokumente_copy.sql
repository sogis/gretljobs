WITH

map_perimeter_file AS (
    SELECT * FROM (VALUES
 ('0edb061d-6516-4808-a028-2690327ceba2','119_Seewen_Sturz_Gauggema_2020.pdf')
,('0123de4d-3a74-4f22-bdfb-38286414814c','097_Wangen_Duennern_2015.pdf')
,('1aebf943-7a71-4bb1-95ef-0311a27678ce','105_Rohr_Wasser_2021.pdf')
,('198c30af-5ada-45da-a67f-91b79aac991b','121_Baerschwil_Steinschlag_2012.pdf')
,('198c30af-5ada-45da-a67f-91b79aac991b','121_Baerschwil_Wasser_2021.pdf')
,('434bf8fb-a66c-4ffd-9692-11542f8f275a','093_Rickenbach_Rutsch_2020.pdf')
,('434bf8fb-a66c-4ffd-9692-11542f8f275a','093_Rickenbach_Duennern_2015.pdf')
,('8a709d46-b5bb-4639-a196-f7539534f1dc','111_Bueren_Wasser_Rutsch_Sturz_2008.pdf')
,('8f5c69ff-139d-4eb7-ae0e-9e00790d7eff','109_Winznau_SB_Baslerstrasse_2021.pdf')
,('8f5c69ff-139d-4eb7-ae0e-9e00790d7eff','108_Winznau_Wasser_Rutsch_Stein_2008.pdf')
,('a3199209-c239-43c7-adc1-c5edc6f801e6','001_Solothurn_Wasser_Duerrbach_2009.pdf')
,('6ff0204e-ee81-4803-b715-9f53858fdc1f','102_Niedergösgen_Sturz_2021.pdf')
,('7297d18b-96b3-4867-8789-cf995d114d0a','065_Aedermannsdorf_Duennern_2015.pdf')
,('7297d18b-96b3-4867-8789-cf995d114d0a','065_Aedermannsdorf_Wasser_2009.pdf')
,('a303c702-4e0b-4449-8704-5e80d0bcd67a','127_Grindel_Rutsch_Sturz_2007.pdf')
,('a303c702-4e0b-4449-8704-5e80d0bcd67a','127_Grindel_Wasser_2014.pdf')
,('6b99d319-bd16-430a-934d-f255459c7e5b','104_Obergoesgen_Wasser_2008.pdf')
,('0cf8601e-e5b6-448b-8642-b72a7b526b5b','072_Mümliswil_Ramiswil_Wasser_Sturz_Rutsch_2017.pdf')
,('f97b3c44-d811-4ae4-900d-c02a0ae664c1','112_Dornach_Birs_2017.pdf')
,('f97b3c44-d811-4ae4-900d-c02a0ae664c1','112_Dornach_Sturz_2024.pdf')
,('f97b3c44-d811-4ae4-900d-c02a0ae664c1','112_Dornach_Wasser_2010.pdf')
,('25277cde-271a-4e84-86d9-8ab55e3e4aa1','123_Breitenbach_Rutsch_2013.pdf')
,('25277cde-271a-4e84-86d9-8ab55e3e4aa1','123_Breitenbach_Wasser_2009.pdf')
,('80abf32d-7567-47ff-b326-060ea96c3e92','120_Witterswil_Wasser_2015.pdf')
,('80abf32d-7567-47ff-b326-060ea96c3e92','120_Witterswil_Wasser_Rutsch_2003.pdf')
,('14491ead-dfd3-4b38-8cfd-74dcf4696915','132_Zullwil_TB_Wasser_2009.pdf')
,('14491ead-dfd3-4b38-8cfd-74dcf4696915','132_Zullwil_Rutschung_2009.pdf')
,('415dc3bc-beb4-4b71-94cc-d304fda11992','090_Haegendorf_Duennern_2015.pdf')
,('e9c761fa-e2bc-44c3-854c-bf76b610f2e9','059_Oekingen_Wasser_2012.pdf')
,('a6f6569a-c2c9-4208-9b16-cd1e82866720','005_Feldbrunnen_St.Niklaus_Wasser_StKatharinenbach_2011.pdf')
,('4b200e58-3f87-4083-b8b6-a5be207adb99','015_Riedholz_Rutsch_2009.pdf')
,('db1bd810-d219-43fc-b972-fcffd8c7beae','034_Messen_OT_Balm_Rutsch_2008.pdf')
,('d6bbd082-bdab-43e9-8d29-c3b3fc48e827','031_Lüsslingen_Nennigkofen_Wasser_2025.pdf')
,('38440e0b-2e89-4197-a684-d29c132ad386','046_Deitingen_Wasser_2012.pdf')
,('85677796-bb79-4743-bb40-47f1e7670a5f','017_Selzach_Wasser_2009.pdf')
,('5b722360-336c-4554-869a-5aec2e74007b','002_Balm_bei_Guensberg_Rutsch_Stein_2011.pdf')
,('f4e6b216-3b45-4c83-be68-a18b559ed5bc','001_Solothurn_Wasser_StKatharinenbach_2011.pdf')
,('8fe6ee20-1f02-40a8-9c67-230b5bd1cd3e','009_Hubersdorf_Wasser_2012.pdf')
,('cffaae7c-d0c6-4bbe-9a63-a2048a9159f4','017_Selzach_Rutsch_2009.pdf')
,('c9caebab-2020-4fef-bf4d-90168eccc2b8','125_Erschwil_Wasser_Rutsch_Stein_2008.pdf')
,('9f64ddf4-7927-42df-8f70-7ca58f2ffbba','047_Derendingen_Wasser_Gruettbach_2012.pdf')
,('23973144-cc2b-4293-8e78-f0a8a011a43f','016_Ruettenen_Wasser_2011.pdf')
,('681626b8-138f-4a9b-b596-56b785cf6630','107_Trimbach_Sturz_Baslerstrasse_Schlussbericht_2023.pdf')
,('681626b8-138f-4a9b-b596-56b785cf6630','107_Trimbach_Sturz_Baslerstrasse_Bauprojekt_2022.pdf')
,('681626b8-138f-4a9b-b596-56b785cf6630','107_Trimbach_2021.pdf')
,('13a872bb-1fc4-4ca4-b35c-a9e903589757','077_Neuendorf_Duennern_2015.pdf')
,('13a872bb-1fc4-4ca4-b35c-a9e903589757','077_Neuendorf_Wasser_2007.pdf')
,('bf9ebebe-aedf-4114-b8a0-0d8a2adee5c7','062_Subingen_Wasser_2011.pdf')
,('5be5f175-e240-4f37-99e1-dc29574849cc','071_Matzendorf_Duennern_2015.pdf')
,('5be5f175-e240-4f37-99e1-dc29574849cc','071_Matzendorf_Wasser_2009.pdf')
,('ac3adb33-f32d-4c6c-9d25-f0482c06b7ef','087_Gretzenbach_Wasser_Rutsch_2021.pdf')
,('c1d8cd2a-18e8-4f23-8897-9e0ac0402ed9','119_Seewen_Sturz_Gauggema_2020.pdf')
,('c1d8cd2a-18e8-4f23-8897-9e0ac0402ed9','119_Seewen_Wasser_Rutsch_Stein_2002.pdf')
,('9e10824c-1a37-4880-bc66-5b030ac513bf','075_Haerkingen_Duennern_2015.pdf')
,('f43e3b1c-9069-4176-80f4-a151f1cfdd14','089_Gunzgen_Duennern_2015.pdf')
,('f7edbffb-0118-4e15-b637-a09fc4de041b','131_Nunningen_GK_Wasser_Rutsch 2009.pdf')
,('aa6e632c-c036-4372-9ed1-c832d488a847','121_Baerschwil_Wasser_Rutsch_2008.pdf')
,('c148f134-b81c-4d12-b756-315a841f0585','110_Baettwil_Sturz_2007.pdf')
,('c148f134-b81c-4d12-b756-315a841f0585','110_Baettwil_Wasser_2015.pdf')
,('768c771c-57bb-4ebf-8dbe-2d717ace6579','008_Günsberg_Rutsch_2007.pdf')
,('c7c48fbc-4e82-4bd3-86a5-8484dacc7f1c','073_Welschenrohr_Wasser_2009.pdf')
,('c7c48fbc-4e82-4bd3-86a5-8484dacc7f1c','073_Welschenrohr_Rutsch_2009.pdf')
,('0ba1736a-b4af-4c12-aa9c-55830f58dbc6','035_Buchegg_Wasser_2024.pdf')
,('c36d9fb0-edc2-451b-a98e-faf2ff639078','129_Kleinluetzel_Stein_Fluefels_2010.pdf')
,('c36d9fb0-edc2-451b-a98e-faf2ff639078','129_Kleinluetzel_Wasser_Rutsch_Stein_2007.pdf')
,('2bd5c6cc-3ae1-4e8d-b9df-289629a3316c','069_Holderbank_Sturz_Talflueli_2018.pdf')
,('2bd5c6cc-3ae1-4e8d-b9df-289629a3316c','069_Holderbank_Wasser_2008.pdf')
,('fbad49f7-c69e-476a-990d-e267a46f95f2','121_Baerschwil_Sturz_SBB_2016.pdf')
,('533b15f4-974e-40bb-af11-84808f526fe3','019_Aetingen_Rutsch_2009.pdf')
,('0f0d247f-453d-497f-a999-e4c225c4332d','099_Kienberg_Rutsch_2007.pdf')
,('0f0d247f-453d-497f-a999-e4c225c4332d','099_Kienberg_Sturz_2002.pdf')
,('42159c6d-8d56-4e05-9268-bc29faab3e12','096_Walterswil_Wasser_2024.pdf')
,('4605af6d-211e-4ecf-a878-e2f5f4d4af96','072_Mümliswil_Ramiswil_Wasser_Sturz_Rutsch_Reckenkien_2023.pdf')
,('cafd7d40-8594-422e-b0b9-247d27a177cf','094_Schoenenwerd_Wasser_2016.pdf')
,('c3d3bcd7-f048-4832-b838-542ea680649e','078_Niederbuchsiten_Duennern_2015.pdf')
,('c3d3bcd7-f048-4832-b838-542ea680649e','078_Niederbuchsiten_Wasser_2008.pdf')
,('5db0fea9-fc39-4c22-9bbf-ace65392b1f1','116_Metzerlen_Sturz_Rutsch_2023.pdf')
,('c528c956-9b55-4bad-a824-7752d38175b6','070_Laupersdorf_Duennern_2015.pdf')
,('c528c956-9b55-4bad-a824-7752d38175b6','070_Laupersdorf_Wasser_2009.pdf')
,('622ed030-ee81-4dea-bbde-7898ee263186','076_Kestenholz_Duennern_2015.pdf')
,('933099e2-b62e-4608-bf62-1c3b8ab80924','068_Herbetswil_Duennern_2015.pdf')
,('2f67a104-4e87-4ab4-9449-b9a93ee01951','084_Dulliken_Wasser_2022.pdf')
,('2f67a104-4e87-4ab4-9449-b9a93ee01951','084_Dulliken_Rutsch_2_2006.pdf')
,('2f67a104-4e87-4ab4-9449-b9a93ee01951','084_Dulliken_Rutsch_1_2006.pdf')
,('dce873a7-4713-48cc-9a91-62736ec2065a','106_Stuesslingen_Rutsch_Stein_2009.pdf')
,('e376c922-32dc-49ce-82c8-d980ccfd18da','124_Büsserach_Wasser_2005.pdf')
,('7e2239e3-329c-45bb-99b6-104f83fcd49c','087_Gretzenbach_Wasser_Rutsch_2021.pdf')
,('6fdd8c22-a13c-4cf1-b323-38192a74ef64','080_Oensingen_Duennern_2015.pdf')
,('6fdd8c22-a13c-4cf1-b323-38192a74ef64','080_Oensingen_Rutsch_Stein_2009.pdf')
,('6fdd8c22-a13c-4cf1-b323-38192a74ef64','080_Oensingen_Wasser_2008.pdf')
,('bb1c605b-bea7-4caa-bf54-ea02c35f08e9','199_Aare_2015.pdf')
,('3b384020-7f26-4d07-949f-63b0d08ed412','055_Kriegstetten_Wasser_2012.pdf')
,('5a6a4ca4-7ba7-4589-aa29-b812ea90adc0','200_Aare_2021.pdf')
,('8ef10451-c9c5-4056-844e-59140c28b837','050_Halten_Wasser_2012.pdf')
,('833ec247-cff2-4229-96a1-d781b1243644','001_Solothurn_Wasser_Wildbach_2005.pdf')
,('6c7f0a75-ce53-4b63-8edd-5e7128dce61b','092_Olten_Duennern_2015.pdf')
,('6c7f0a75-ce53-4b63-8edd-5e7128dce61b','092_Olten_Wasser_2009.pdf')
,('6c7f0a75-ce53-4b63-8edd-5e7128dce61b','092_Olten_Rutsch_Stein_2008.pdf')
,('386ba989-47e7-4f0b-8767-8c01eab210d8','199_Aare_2015.pdf')
,('bb0adfd5-13af-4c30-8391-2200dbc99a0a','201_Emme_2021.pdf')
,('65729e6a-7ad4-4337-b49f-0db69c36c170','043_Biberist_Wasser ohne Emme_2022.pdf')
,('71c20bf7-138d-4de2-8f11-6495e7357fb9','004_Bettlach_Wasser_2021.pdf')
,('11336cab-ed3d-4e87-b733-c6d8cc860023','003_Bellach_Wasser_Haltenbach_Busletenbach_2007.pdf')
,('11336cab-ed3d-4e87-b733-c6d8cc860023','003_Bellach_Wasser_Wildbach_2005.pdf')
,('11336cab-ed3d-4e87-b733-c6d8cc860023','003_Bellach_Rutsch_Stein_2005.pdf')
,('ba22ec19-f46b-4ba7-9167-f223e08f67d2','003_Bellach_Rutsch_Stein_2005.pdf')
,('17403378-fea8-48e1-b50b-f39c9f5b5ff0','007_Grenchen_Teil_Massenbewegungen_2005.pdf')
,('6c275650-eaf5-426a-a313-ed795caf815c','066_Balsthal_Rutsch_2008.pdf')
,('53154a86-9e7e-4ee4-a86d-1f19288b5d71','066_Balsthal_Wasser_2024.pdf')
,('d1f5f824-73ba-4e5a-a6d4-c2ab06c229b3','079_Oberbuchsiten_Duennern_2015.pdf')
,('d1f5f824-73ba-4e5a-a6d4-c2ab06c229b3','079_Oberbuchsiten_Wasser_2009.pdf')
,('d1f5f824-73ba-4e5a-a6d4-c2ab06c229b3','079_Oberbuchsiten_Sturz_Rutsch_2008.pdf')
,('9939c386-44a1-4c88-aa8e-82ed1124d115','074_Egerkingen_Duennern_2015.pdf')
,('9939c386-44a1-4c88-aa8e-82ed1124d115','074_Egerkingen_Wasser_2008.pdf')
,('9939c386-44a1-4c88-aa8e-82ed1124d115','074_Egerkingen_Rutsch_Stein_2008.pdf')
,('5140c717-2808-4674-8221-14e330b9a947','091_Kappel_Duennern_2015.pdf')
,('6d2a0d04-42c9-4825-a085-b87f2ae9a4d2','100_Lostorf_Sturz_Rutsch_2008.pdf')
,('6d2a0d04-42c9-4825-a085-b87f2ae9a4d2','100_Lostorf_Wasser_2013.pdf')
,('08286b65-d8b2-418f-8330-a17ed759df8c','106_Stuesslingen_Wasser_2022.pdf')
,('73a11ae4-efa9-499a-b8d9-8932ebe9a101','101_Erlinsbach_Wasser_2023.pdf')
,('73a11ae4-efa9-499a-b8d9-8932ebe9a101','101_Erlinsbach_Rutsch_2011.pdf')
,('628a8e99-c937-4fbe-90a0-679af526f88f','066_Balsthal_Sturz_2020.pdf')
,('628a8e99-c937-4fbe-90a0-679af526f88f','066_Balsthal_Duennern_2015.pdf')
,('f6f5602d-4830-4218-a226-4e8eaa9a2d5d','090_Haegendorf_Wasser_2012.pdf')
,('136c787c-e549-4c65-962d-6086647d402d','007_Grenchen_Wasser_2023.pdf')
,('2fc6166b-c778-4ae1-b69e-5b8f452a68b6','014_Oberdorf_Wasser_2022.pdf')
,('7474ae15-b146-450b-bc8b-1e1be307ccb2','011_Langendorf_Wasser_Wildbach_2005.pdf')
,('2512c926-1730-4b47-b7b2-c50f9d545817','115_Hofstetten_Flueh_Wasser_2010.pdf')
,('2512c926-1730-4b47-b7b2-c50f9d545817','115_Hofstetten_Flueh_Rutsch_Stein_2007.pdf')
    ) AS t(peri_t_ili_tid, file_name)
),

files_per_perimeter_t_ili_tid AS (
    SELECT 
        peri_t_ili_tid,
        array_to_string( 
            array_agg(file_name),
            E'\r\n'
        ) AS files 
    FROM 
        map_perimeter_file
    GROUP BY 
        peri_t_ili_tid
),

files_per_perimeter AS (
    SELECT
        fp.files,
        peri_t_ili_tid::text AS ident,
        COALESCE(p.t_ili_tid::text, '-77'::text) AS id,
        COALESCE(st_buffer(p.geometrie,-1), ST_BUFFER(ST_POINT(2615735,1233468,2056),1000,1)) AS geom
    FROM 
        files_per_perimeter_t_ili_tid fp
    LEFT JOIN 
        afu_gefahrenkartierung.gefahrenkartirung_perimeter_gefahrenkartierung p ON fp.peri_t_ili_tid::text = p.t_ili_tid::text
),

file_gemeinde AS ( -- Attr JOIN auf Perimeter, spatial JOIN auf gemeinde
    SELECT
        file_name,
        COALESCE(bfs_gemeindenummer, -99) AS gem_bfs,
        COALESCE(gemeindename, 'FEHLZUWEISUNG') AS gem_name,
        left(right(file_name,8),4) AS jahr,
        LEFT(file_name, LENGTH(file_name) - 4) AS titel,
        'https://geo.so.ch/docs/ch.so.afu.naturgefahren/'||file_name AS url
    FROM 
        map_perimeter_file m
    LEFT JOIN 
        afu_gefahrenkartierung.gefahrenkartirung_perimeter_gefahrenkartierung p ON m.peri_t_ili_tid::text = p.t_ili_tid::text  
    LEFT JOIN 
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze g ON ST_Intersects(st_buffer(p.geometrie,-1), g.geometrie)
),

files_per_gemeinde_bfs AS (
    SELECT 
        gem_bfs,
        gem_name,
        json_build_object('@type', 'SO_AFU_Naturgefahren_Publikation_20241025.Naturgefahren.Dokument',
                      'Titel', titel, 
                      'Dateiname', file_name, 
                      'Link', url,
                      'Hauptprozesse', 'obsolet',
                      'Jahr', jahr
        ) AS dokument
    FROM 
        file_gemeinde
),

files_per_gemeinde AS (
    SELECT
        fg.gem_bfs AS gemeinde_bfsnr,
        gem_name AS gemeinde_name,
        fg.dokument AS dokument,
        COALESCE(g.geometrie, st_multi(ST_BUFFER(ST_POINT(2615735,1233468,2056),1000,1))) AS geometrie
    FROM 
        files_per_gemeinde_bfs fg
    LEFT JOIN 
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze g ON fg.gem_bfs = g.bfs_gemeindenummer
)

SELECT * FROM files_per_gemeinde
