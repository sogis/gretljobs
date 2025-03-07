WITH

map_perimeter_file AS (
    SELECT * FROM (VALUES
        (62489,'200_Aare_2021.pdf')
		,(32251,'199_Aare_2015.pdf')
		,(31970,'199_Aare_2015.pdf')
        ,(31994,'065_Aedermannsdorf_Wasser_2009.pdf')
        ,(31994,'065_Aedermannsdorf_Duennern_2015.pdf')
        ,(127572,'019_Aetingen_Rutsch_2009.pdf')
        ,(31943,'121_Baerschwil_Wasser_Rutsch_2008.pdf')
        ,(32272,'121_Baerschwil_Sturz_SBB_2016.pdf')
        ,(31944,'121_Baerschwil_Wasser_2021.pdf')
		,(31944,'121_Baerschwil_Steinschlag_2012.pdf')
        ,(32236,'110_Baettwil_Wasser_2015.pdf')
		,(32236,'110_Baettwil_Sturz_2007.pdf')
		,(32244,'008_Günsberg_Rutsch_2007.pdf')
        ,(32131,'002_Balm_bei_Guensberg_Rutsch_Stein_2011.pdf')
        ,(32124,'034_Messen_OT_Balm_Rutsch_2008.pdf')
        ,(134109,'066_Balsthal_Wasser_2024.pdf')
        ,(134108,'066_Balsthal_Rutsch_2008.pdf')
        ,(107986,'066_Balsthal_Duennern_2015.pdf')
        ,(107986,'066_Balsthal_Sturz_2020.pdf')
        ,(32138,'003_Bellach_Rutsch_Stein_2005.pdf')
        ,(32138,'003_Bellach_Wasser_Wildbach_2005.pdf')
        ,(32138,'003_Bellach_Wasser_Haltenbach_Busletenbach_2007.pdf')
        ,(134107,'003_Bellach_Rutsch_Stein_2005.pdf')
        ,(103935,'004_Bettlach_Wasser_2021.pdf')
        ,(32035,'123_Breitenbach_Wasser_2009.pdf')
        ,(32035,'123_Breitenbach_Rutsch_2013.pdf')
		,(32299,'124_Büsserach_Wasser_2005.pdf')
        ,(32129,'046_Deitingen_Wasser_2012.pdf')
		,(32126,'031_Lüsslingen_Nennigkofen_Wasser_2025.pdf')
		,(127543,'035_Buchegg_Wasser_2024.pdf')
        ,(32017,'112_Dornach_Wasser_2010.pdf')
		,(32017,'112_Dornach_Sturz_2024.pdf')
		,(32017,'112_Dornach_Birs_2017.pdf')
        ,(32086,'074_Egerkingen_Rutsch_Stein_2008.pdf')
        ,(32086,'074_Egerkingen_Wasser_2008.pdf')
        ,(32086,'074_Egerkingen_Duennern_2015.pdf')
        ,(106619,'101_Erlinsbach_Rutsch_2011.pdf')
        ,(106619,'101_Erlinsbach_Wasser_2023.pdf')
        ,(94939,'014_Oberdorf_Wasser_2022.pdf')
        ,(97090,'043_Biberist_Wasser ohne Emme_2022.pdf')
        ,(31977,'108_Winznau_Wasser_Rutsch_Stein_2008.pdf')
        ,(31977,'109_Winznau_SB_Baslerstrasse_2021.pdf')
        ,(84141,'087_Gretzenbach_Wasser_Rutsch_2021.pdf')
        ,(84143,'087_Gretzenbach_Wasser_Rutsch_2021.pdf')
        ,(32000,'127_Grindel_Wasser_2014.pdf')
		,(32000,'127_Grindel_Rutsch_Sturz_2007.pdf')
        ,(32153,'047_Derendingen_Wasser_Gruettbach_2012.pdf')
        ,(32074,'090_Haegendorf_Duennern_2015.pdf')
        ,(108255,'090_Haegendorf_Wasser_2012.pdf')
        ,(32294,'068_Herbetswil_Duennern_2015.pdf')
        ,(32267,'115_Hofstetten_Flueh_Rutsch_Stein_2007.pdf')
        ,(32267,'115_Hofstetten_Flueh_Wasser_2010.pdf')
        ,(32264,'069_Holderbank_Wasser_2008.pdf')
        ,(32264,'069_Holderbank_Sturz_Talflueli_2018.pdf')
        ,(32133,'009_Hubersdorf_Wasser_2012.pdf')
        ,(32266,'091_Kappel_Duennern_2015.pdf')
        ,(32293,'076_Kestenholz_Duennern_2015.pdf')
        ,(31959,'111_Bueren_Wasser_Rutsch_Sturz_2008.pdf')
        ,(32248,'125_Erschwil_Wasser_Rutsch_Stein_2008.pdf')
        ,(32234,'007_Grenchen_Teil_Massenbewegungen_2005.pdf')
        ,(108430,'007_Grenchen_Wasser_2023.pdf')
        ,(32219,'089_Gunzgen_Duennern_2015.pdf')
        ,(32214,'075_Haerkingen_Duennern_2015.pdf')
        ,(32261,'129_Kleinluetzel_Wasser_Rutsch_Stein_2007.pdf')
        ,(32261,'129_Kleinluetzel_Stein_Fluefels_2010.pdf')
        ,(32211,'119_Seewen_Wasser_Rutsch_Stein_2002.pdf')
        ,(32211,'119_Seewen_Sturz_Gauggema_2020.pdf')
        ,(31939,'119_Seewen_Sturz_Gauggema_2020.pdf')
		,(32057,'120_Witterswil_Wasser_Rutsch_2003.pdf')
		,(32057,'120_Witterswil_Wasser_2015.pdf')
        ,(32292,'070_Laupersdorf_Wasser_2009.pdf')
        ,(32292,'070_Laupersdorf_Duennern_2015.pdf')
        ,(32270,'100_Lostorf_Wasser_2013.pdf')
		,(32270,'100_Lostorf_Sturz_Rutsch_2008.pdf')
        ,(32176,'071_Matzendorf_Wasser_2009.pdf')
		,(32176,'071_Matzendorf_Duennern_2015.pdf')
        ,(32013,'072_Mümliswil_Ramiswil_Wasser_Sturz_Rutsch_2017.pdf')
        ,(134113,'072_Mümliswil_Ramiswil_Wasser_Sturz_Rutsch_Reckenkien_2023.pdf')
        ,(134111,'077_Neuendorf_Wasser_2007.pdf')
        ,(134111,'077_Neuendorf_Duennern_2015.pdf')
        ,(32287,'078_Niederbuchsiten_Wasser_2008.pdf')
        ,(32287,'078_Niederbuchsiten_Duennern_2015.pdf')
        ,(32221,'131_Nunningen_GK_Wasser_Rutsch 2009.pdf')
        ,(134110,'079_Oberbuchsiten_Sturz_Rutsch_2008.pdf')
        ,(134110,'079_Oberbuchsiten_Wasser_2009.pdf')
        ,(134110,'079_Oberbuchsiten_Duennern_2015.pdf')
        ,(32001,'104_Obergoesgen_Wasser_2008.pdf')
		,(31983,'102_Niedergösgen_Sturz_2021.pdf')
		,(32282,'099_Kienberg_Sturz_2002.pdf')
		,(32282,'099_Kienberg_Rutsch_2007.pdf')
        ,(96538,'084_Dulliken_Rutsch_1_2006.pdf')
        ,(96538,'084_Dulliken_Rutsch_2_2006.pdf')
        ,(96538,'084_Dulliken_Wasser_2022.pdf')
        ,(32155,'016_Ruettenen_Wasser_2011.pdf')
        ,(32130,'011_Langendorf_Wasser_Wildbach_2005.pdf')
        ,(32300,'080_Oensingen_Wasser_2008.pdf')
        ,(32300,'080_Oensingen_Rutsch_Stein_2009.pdf')
        ,(32300,'080_Oensingen_Duennern_2015.pdf')
        ,(32093,'059_Oekingen_Wasser_2012.pdf')
        ,(134103,'055_Kriegstetten_Wasser_2012.pdf')
        ,(134104,'050_Halten_Wasser_2012.pdf')
        ,(134362,'092_Olten_Rutsch_Stein_2008.pdf')
        ,(134362,'092_Olten_Wasser_2009.pdf')
        ,(134362,'092_Olten_Duennern_2015.pdf')
        ,(32055,'093_Rickenbach_Duennern_2015.pdf')
        ,(32055,'093_Rickenbach_Rutsch_2020.pdf')
        ,(32111,'015_Riedholz_Rutsch_2009.pdf')
        ,(31941,'105_Rohr_Wasser_2021.pdf')
        ,(32284,'094_Schoenenwerd_Wasser_2016.pdf')
        ,(32062,'017_Selzach_Wasser_2009.pdf')
        ,(32139,'017_Selzach_Rutsch_2009.pdf')
        ,(32132,'001_Solothurn_Wasser_StKatharinenbach_2011.pdf')
		,(31972,'001_Solothurn_Wasser_Duerrbach_2009.pdf')
		,(134105,'001_Solothurn_Wasser_Wildbach_2005.pdf')
		,(32095,'005_Feldbrunnen_St.Niklaus_Wasser_StKatharinenbach_2011.pdf')
        ,(105802,'106_Stuesslingen_Rutsch_Stein_2009.pdf')
        ,(105313,'106_Stuesslingen_Wasser_2022.pdf')
        ,(32169,'062_Subingen_Wasser_2011.pdf')
        ,(77102,'201_Emme_2021.pdf')
        ,(75735,'107_Trimbach_2021.pdf')
        ,(75735,'107_Trimbach_Sturz_Baslerstrasse_Bauprojekt_2022.pdf')
        ,(75735,'107_Trimbach_Sturz_Baslerstrasse_Schlussbericht_2023.pdf')
        ,(32212,'097_Wangen_Wasser_2007.pdf')
		,(32212,'097_Wangen_Duennern_2015.pdf')
        ,(32256,'073_Welschenrohr_Rutsch_2009.pdf')
        ,(32256,'073_Welschenrohr_Wasser_2009.pdf')
        ,(32064,'132_Zullwil_Rutschung_2009.pdf')
        ,(32064,'132_Zullwil_TB_Wasser_2009.pdf')
		,(134311,'116_Metzerlen_Sturz_Rutsch_2023.pdf')
		,(130277,'096_Walterswil_Wasser_2024.pdf')
    ) AS t(peri_tid, file_name)
),

files_per_perimeter_tid AS (
    SELECT 
        peri_tid,
        array_to_string( 
            array_agg(file_name),
            E'\r\n'
        ) AS files 
    FROM 
        map_perimeter_file
    GROUP BY 
        peri_tid
),

files_per_perimeter AS (
    SELECT
        fp.files,
        peri_tid::text AS ident,
        COALESCE(p.t_id, -77) AS id,
        COALESCE(st_buffer(p.geometrie,-1), ST_BUFFER(ST_POINT(2615735,1233468,2056),1000,1)) AS geom
    FROM 
        files_per_perimeter_tid fp
    LEFT JOIN 
        afu_gefahrenkartierung.gefahrenkartirung_perimeter_gefahrenkartierung p ON fp.peri_tid = p.t_id
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
        afu_gefahrenkartierung.gefahrenkartirung_perimeter_gefahrenkartierung p ON m.peri_tid = p.t_id  
    LEFT JOIN 
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze g ON ST_Intersects(st_buffer(p.geometrie,-1), g.geometrie)
),

files_per_gemeinde_bfs AS (
    SELECT 
        gem_bfs,
        gem_name,
        json_agg(json_build_object('@type', 'SO_AFU_Naturgefahren_Publikation_20241025.Naturgefahren.Dokument',
                      'Titel', titel, 
                      'Dateiname', file_name, 
                      'Link', url,
                      'Hauptprozesse', 'obsolet',
                      'Jahr', jahr
        )) AS dokument
    FROM 
        file_gemeinde
    GROUP BY 
        gem_bfs,
        gem_name
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

