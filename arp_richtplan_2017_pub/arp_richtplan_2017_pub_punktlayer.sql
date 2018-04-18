SELECT
    gemeinde,
    "name",
    spezifikation,
    bedeutung,
    nummer,
    abstimmungskategorie,
    stand,
    x_koord,
    y_koord,
    o_art,
    CASE   
        WHEN o_art = 'V31'
            THEN 'Autobahnanschluss Vorhaben'
        WHEN o_art = 'V3'
            THEN 'Autobahnanschluss'
        WHEN o_art = 'V2'
            THEN 'Flugplatz/Flugfeld'
        WHEN o_art = 'V1'
            THEN 'Bahnhaltestelle Vorhaben'
        WHEN o_art = 'S9'
            THEN 'Erweiterung Siedlungsgebiet Vorhaben'
        WHEN o_art = 'S8'
            THEN 'Öffentliche Bauten und Anlagen Vorhaben'
        WHEN o_art = 'S6'
            THEN 'Umstrukturierungsgebiet'
        WHEN o_art = 'S5'
            THEN 'Regionale Arbeitsplatzzone Vorhaben'
        WHEN o_art = 'S4'
            THEN 'Ortsbild von nationaler oder regionaler Bedeutung'
        WHEN o_art = 'S22'
            THEN 'Einkaufszentrum Vorhaben'
        WHEN o_art = 'S21'  
            THEN 'Einkaufszentrum Erweiterung'
        WHEN o_art = 'S2'
            THEN 'Einkaufszentrum bestehend'
        WHEN o_art = 'S12'
            THEN 'Bahnhofgebiet Vorhaben'
        WHEN o_art = 'S10'
            THEN 'UNESCO-Weltkulturerbe-Pallafittes'
        WHEN o_art = 'S1'
            THEN 'Bahnhofgebiet bestehend'
        WHEN o_art = 'L2'
            THEN 'Güterregulierung Vorhaben'
        WHEN o_art = 'L12'
            THEN 'Anlage für Freizeit und Sport Vorhaben'
        WHEN o_art = 'L1'
            THEN 'Anlage für Freizeit und Sport bestehend'
        WHEN o_art = 'E7'
            THEN 'Windpark'
        WHEN o_art = 'E61'
            THEN 'Wasserkraftwerk Erweiterung'
        WHEN o_art = 'E6'
            THEN 'Wasserkraftwerk bestehend'
        WHEN o_art = 'E5'
            THEN 'Militärische Schiess- und Übungsanlage'
        WHEN o_art = 'E4'
            THEN 'Kernkraftwerk'
        WHEN o_art = 'E3'
            THEN 'Kehrrichtsverbrennungsanlage Erweiterung'
        WHEN o_art = 'E22'
            THEN 'Deponiestandort Vorhaben'
        WHEN o_art = 'E21'
            THEN 'Deponiestandort Erweiterung'
        WHEN o_art = 'E2'
            THEN 'Deponiestandort bestehend'
        WHEN o_art = 'E12'
            THEN 'Abbaugebiet Vorhaben'
        WHEN o_art = 'E11'
            THEN 'Abbaugebiet Erweiterung'
        WHEN o_art = 'E1'
            THEN 'Abbaugebiet bestehend'
    END AS o_art_txt,
    geometrie,
    ogc_fid AS t_id 
FROM
    arp_richtplan_2017.punktlayer
;