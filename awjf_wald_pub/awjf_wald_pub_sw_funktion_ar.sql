SELECT 
    ogc_fid AS t_id,
    CASE
        WHEN fk = 1
            THEN 'Bucheggberg / Lebern'
        WHEN fk = 2
            THEN 'Wasseramt'
        WHEN fk = 3
            THEN 'Thal'
        WHEN fk = 4
            THEN 'Gäu / Untergäu'
        WHEN fk = 5
            THEN 'Olten / Niederamt'
        WHEN fk = 6
            THEN 'Dorneck / Thierstein'
    END AS fk,
    CASE
        WHEN fr = 1
            THEN 'FR Grenchen'
         WHEN fr = 2
            THEN 'FR Leberberg'
         WHEN fr = 3
            THEN 'FR Bucheggberg'
        WHEN fr = 4
            THEN 'FR Wasseramt'
        WHEN fr = 5
            THEN 'FR BG Solothurn'
        WHEN fr = 6
            THEN 'FR Balsthal-Mümliswil'
        WHEN fr = 7
            THEN 'FR Laupersdorf/Matzendorf'
        WHEN fr = 8
            THEN 'FR Hinteres Thal'
        WHEN fr = 9
            THEN 'FR Oberbuchsiten/Oensingen/Holderbank'
        WHEN fr = 10
            THEN 'FR Oberes Gäu'
        WHEN fr = 11
            THEN 'FR Neuendorf/Härkingen/Egerkingen'
        WHEN fr = 12
            THEN 'FR Boningen-Fulenbach-Gunzgen'
        WHEN fr = 13
            THEN 'FR Untergäu'
        WHEN fr = 14
            THEN 'FR BG Olten'
        WHEN fr = 15
            THEN 'FR Unterer Hauenstein'
        WHEN fr = 16
            THEN 'FR Gösgeramt-Kienberg'
        WHEN fr = 17
            THEN 'FR Obererlinsbach'
        WHEN fr = 18
            THEN 'FR Werderamt'
        WHEN fr = 19
            THEN 'FR Dorneckberg Nord'
        WHEN fr = 20
            THEN 'FR Dorneckberg Süd'
        WHEN fr = 21
            THEN 'FR Am Blauen'
        WHEN fr = 22
            THEN 'FR Thierstein Süd'
        WHEN fr = 23
            THEN 'FR Thierstein Mitte'
        WHEN fr = 24
            THEN 'FR Thierstein West / Laufental'
    END AS fr,
    name,
    CASE
        WHEN sturz = 1
            THEN 'Ja'
        ELSE 'Nein'
    END AS sturz,
    CASE
        WHEN rutsch = 1
            THEN 'Ja'
        ELSE 'Nein'
    END AS rutsch,
    CASE
        WHEN grs = 1
            THEN 'Ja'
        ELSE 'Nein'
    END AS grs,
    CASE
        WHEN lawine = 1
            THEN 'Ja'
        ELSE 'Nein'
    END AS lawine,
    CASE 
        WHEN anderekt = 1
            THEN 'Ja'
        ELSE 'Nein'
    END AS anderekt,
    CASE
        WHEN obj_kat = 2.2
            THEN '2.2 Verkehrswege von kommunaler Bedeutung, Hofzufahrten'
        WHEN obj_kat = 2.3
            THEN '2.3 Einzelgebäude'
        WHEN obj_kat = 3.1
            THEN '3.1 Kantonsstrassen / Bahnlinien'
        WHEN obj_kat = 3.2
            THEN '3.2 Geschlossene Siedlungen'
        WHEN obj_kat = 3.3
            THEN '3.3 Sonderobjekte'
    END AS obj_kat,
    schaden_po,
    CASE
        WHEN h_gef_pot = 1
            THEN 'Sturz'
        WHEN h_gef_pot = 2
            THEN 'Rutschung'
        WHEN h_gef_pot = 3
            THEN 'gerinnerelevante Prozesse' 
        WHEN h_gef_pot = 4
            THEN 'Lawine'
    END AS h_gef_pot,
    CASE
        WHEN igef_pot = 1
            THEN 'schwach'
        WHEN igef_pot = 2
            THEN 'mittel'
        WHEN igef_pot = 3
            THEN 'stark'
    END AS igef_pot,
    bemerkunge,
    flaeche,
    ST_Multi(wkb_geometry) AS geometrie,
    status,
    name_2,
    gem_name,
    gem_bfs
FROM 
    awjf.sw_funktion_ar
WHERE 
    archive = 0
;
