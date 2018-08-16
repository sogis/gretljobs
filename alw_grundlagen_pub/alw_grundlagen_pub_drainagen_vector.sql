SELECT 
    gid, 
    tid, 
    name_nummer, 
    nutzungsart, 
    funktionhi, 
    profilart, 
    breite_durchmesser, 
    lichte_hoehe, 
    anfangshoehe, 
    endhoehe, 
    hoehenbest, 
    CASE 
        WHEN material = 0 
            THEN 'unbekannt' 
        WHEN material = 1 
            THEN 'Beton' 
        WHEN material = 2 
            THEN 'Beton_unbekannt' 
        WHEN material = 3 
            THEN 'Beton_armiert' 
        WHEN material = 4 
            THEN 'Beton_vorgespannt' 
        WHEN material = 5 
            THEN 'Beton_Fertigteil' 
        WHEN material = 6 
            THEN 'Beton_unarmiert' 
        WHEN material = 7 
            THEN 'Beton_Ortsbeton' 
        WHEN material = 8 
            THEN 'Beton_schleuderbeton' 
        WHEN material = 9 
            THEN 'Beton_Spezialzement_armiert' 
        WHEN material = 10 
            THEN 'Beton_Spezialzement_unarmiert'
        WHEN material = 11 
            THEN 'Faserzement'
        WHEN material = 12 
            THEN 'Asbestzement'
        WHEN material = 13 
            THEN 'gebrannte Steine'
        WHEN material = 14 
            THEN 'Guss' 
        WHEN material = 15 
            THEN 'Guss_unbekannt' 
        WHEN material = 16 
            THEN 'Guss_Grauguss'
        WHEN material = 17 
            THEN 'Guss_Guss_duktil'
        WHEN material = 18 
            THEN 'Guss_Gussbeton' 
        WHEN material = 19 
            THEN 'GUP_Fertigteil'
        WHEN material = 20 
            THEN 'Kies' 
        WHEN material = 21 
            THEN 'Kunststoff'
        WHEN material = 22 
            THEN 'Kunststoff_unbekannt' 
        WHEN material = 23 
            THEN 'Kunststoff_Hartpolyethylen_HDPE' 
        WHEN material = 24 
            THEN 'Kunststoff_Polyester_GUP'
        WHEN material = 25 
            THEN 'Kunststoff_Polyvinilchlorid_PVC' 
        WHEN material = 26 
            THEN 'Kunststoff_Polyvinilchlorid_hart'
        WHEN material = 27 
            THEN 'Kunststoff_Epoxidharz_EP'
        WHEN material = 28 
            THEN 'Stahl'
        WHEN material = 29 
            THEN 'Stahl_unbekannt' 
        WHEN material = 30 
            THEN 'Stahl_nicht_rostbestaendig'
        WHEN material = 31 
            THEN 'Stahl_rostbestaendig'
        WHEN material = 32 
            THEN 'Steinzeug' 
        WHEN material = 33 
            THEN 'Ton' 
        WHEN material = 34 
            THEN 'Verschiedene'
        WHEN material = 35 
            THEN 'Zement' 
        WHEN material = 36 
            THEN 'Kunststoff_Polyethylen_PE'
        WHEN material = 37 
            THEN 'Kunststoff_Polypropylen_PP'
    END AS material, 
    CASE 
        WHEN material_e = 0 
            THEN 'unbekannt'
        WHEN material_e = 1 
            THEN 'Rohr_gesteckt'
        WHEN material_e = 2 
            THEN 'Rohr_stumpf'
        WHEN material_e = 3 
            THEN 'Sickerrohr'
        WHEN material_e = 4 
            THEN 'Sickerrohr_geschlitzt'
        WHEN material_e = 5 
            THEN 'Schlitz'
        WHEN material_e = 6 
            THEN 'Rinne'
        WHEN material_e = 7 
            THEN 'Rinnschale'
        WHEN material_e = 8 
            THEN 'Querrinne'
    END AS material_e, 
    lagebestimmung, 
    status, 
    baujahr, 
    gefaelle, 
    laenge, 
    eigentuemer, 
    bemerkung, 
    strangref, 
    wkb_geometry
FROM 
    alw_grundlagen.drainagen_vector
;
