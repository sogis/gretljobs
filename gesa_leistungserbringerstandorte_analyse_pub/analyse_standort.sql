
--Wohnbevölkerung: Summe aus Hektarraster = 274710:

--SELECT 
--    sum(wohnbevoelkerung_staendig)
--FROM 
--    gesa_leistungserbringerstandorte_analyse_v1.stammdaten_hektarraster;


WITH standorte AS 
(
    SELECT     
        standort.t_id,
        standort.lage,
        standort.aname,
        standort.strasse_hausnummer,
        standort.plz_ortschaft,
        standort.leistungen,
        ssl.dispname AS leistungen_txt,
        standort.kanton,
        institut.aname AS institut 
    FROM 
        gesa_leistungserbringerstandorte_analyse_v1.stammdaten_standort AS standort
        LEFT JOIN gesa_leistungserbringerstandorte_analyse_v1.stammdaten_institut AS institut 
        ON standort.institut_r = institut.t_id 
        LEFT JOIN gesa_leistungserbringerstandorte_analyse_v1.stammdaten_standort_leistungen AS ssl 
        ON ssl.ilicode = standort.leistungen
)
,
fahrzeiten AS 
(
    SELECT 
        standort_r,
        erreichbarkeit::jsonb
    FROM 
    (
        SELECT 
            standort_r,
            jsonb_build_object(
                '@type', 'SO_GESA_Leistungserbringerstandorte_Analyse_Publikation_20231117.Analyse.Erreichbarkeit_Prozent',
                'Fahrzeit_kleiner_10', COALESCE(CAST(jsonobj->'min_0_10' AS NUMERIC) / 274710 * 100, 0),
                'Fahrzeit_kleiner_15', COALESCE(CAST(jsonobj->'min_0_10' AS NUMERIC) / 274710 * 100, 0)  
                    + COALESCE(CAST(jsonobj->'min_10_15' AS NUMERIC) / 274710 * 100, 0),
                'Fahrzeit_kleiner_30', COALESCE(CAST(jsonobj->'min_0_10' AS NUMERIC) / 274710 * 100, 0) 
                    + COALESCE(CAST(jsonobj->'min_10_15' AS NUMERIC) / 274710 * 100, 0)
                    + COALESCE(CAST(jsonobj->'min_15_30' AS NUMERIC) / 274710 * 100, 0),
                'Fahrzeit_kleiner_60', COALESCE(CAST(jsonobj->'min_0_10' AS NUMERIC) / 274710 * 100, 0) 
                    + COALESCE(CAST(jsonobj->'min_10_15' AS NUMERIC) / 274710 * 100, 0)
                    + COALESCE(CAST(jsonobj->'min_15_30' AS NUMERIC) / 274710 * 100, 0)
                    + COALESCE(CAST(jsonobj->'min_30_60' AS NUMERIC) / 274710 * 100, 0)  
            ) AS erreichbarkeit
        FROM 
        (
            SELECT 
                standort_r, jsonb_object_agg(auswertung_versorgung_leistungserbringer.fahrzeit, auswertung_versorgung_leistungserbringer.wohnbevoelkerung_staendig) AS jsonobj
            FROM 
                gesa_leistungserbringerstandorte_analyse_v1.auswertung_versorgung_leistungserbringer 
            GROUP BY 
                standort_r
        ) AS a     
    ) AS b
)
SELECT 
    --standorte.t_id,
    standorte.lage,
    standorte.aname,
    standorte.strasse_hausnummer,
    standorte.plz_ortschaft,
    standorte.leistungen,
    standorte.leistungen_txt,
    standorte.kanton,
    standorte.kanton AS kanton_txt,
    standorte.institut,
    fahrzeiten.erreichbarkeit AS erreichbarkeit_aggregiert
FROM 
    standorte 
    LEFT JOIN fahrzeiten 
    ON standorte.t_id = fahrzeiten.standort_r
;
