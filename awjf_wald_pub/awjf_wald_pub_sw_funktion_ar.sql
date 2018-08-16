SELECT 
    ogc_fid as t_id,
    CASE fk WHEN 1 THEN 'Bucheggberg / Lebern'
            WHEN 2 THEN 'Wasseramt' 
            WHEN 3 THEN 'Thal' 
            WHEN 4 THEN 'Gäu / Untergäu' 
            WHEN 5 THEN 'Olten / Niederamt' 
            WHEN 6 THEN 'Dorneck / Thierstein'
    END AS fk,
    CASE fr WHEN 1	THEN 'FR Grenchen'
         WHEN 2	THEN 'FR Leberberg'
         WHEN 3	THEN 'FR Bucheggberg'
	 WHEN 4	THEN 'FR Wasseramt'
	 WHEN 5	THEN 'FR BG Solothurn'
	 WHEN 6	THEN 'FR Balsthal-Mümliswil'                       
	 WHEN 7	THEN 'FR Laupersdorf/Matzendorf'
	 WHEN 8	THEN 'FR Hinteres Thal'                                          
	 WHEN 9	THEN 'FR Oberbuchsiten/Oensingen/Holderbank'
	 WHEN 10 THEN 'FR Oberes Gäu'
	 WHEN 11 THEN 'FR Neuendorf/Härkingen/Egerkingen'
	 WHEN 12 THEN 'FR Boningen-Fulenbach-Gunzgen'
	 WHEN 13 THEN 'FR Untergäu'
	 WHEN 14 THEN 'FR BG Olten'
	 WHEN 15 THEN 'FR Unterer Hauenstein'
	 WHEN 16 THEN 'FR Gösgeramt-Kienberg'                   
	 WHEN 17 THEN 'FR Obererlinsbach'
	 WHEN 18 THEN 'FR Werderamt'
	 WHEN 19 THEN 'FR Dorneckberg Nord'
	 WHEN 20 THEN 'FR Dorneckberg Süd'
	 WHEN 21 THEN 'FR Am Blauen'
	 WHEN 22 THEN 'FR Thierstein Süd'
	 WHEN 23 THEN 'FR Thierstein Mitte'
	 WHEN 24 THEN 'FR Thierstein West / Laufental'
     END AS fr,
    name,
    CASE WHEN sturz = 1 THEN 'Ja' ELSE 'Nein' END AS sturz,
    CASE WHEN rutsch = 1 THEN 'Ja' ELSE 'Nein' END AS rutsch,
    CASE WHEN grs = 1 THEN 'Ja' ELSE 'Nein' END AS grs,
    CASE WHEN lawine = 1 THEN 'Ja' ELSE 'Nein' END AS lawine,
    CASE WHEN anderekt = 1 THEN 'Ja' ELSE 'Nein' END AS anderekt,
    CASE obj_kat WHEN 2.2 THEN '2.2 Verkehrswege von kommunaler Bedeutung, Hofzufahrten'
                 WHEN 2.3 THEN '2.3 Einzelgebäude' 
                 WHEN 3.1 THEN '3.1 Kantonsstrassen / Bahnlinien' 
                 WHEN 3.2 THEN '3.2 Geschlossene  Siedlungen' 
                 WHEN 3.3 THEN '3.3 Sonderobjekte' 
    END AS obj_kat,
    schaden_po,
    CASE h_gef_pot WHEN 1 THEN 'Sturz' 
                   WHEN 2 THEN 'Rutschung'
                   WHEN 3 THEN 'gerinnerelevante Prozesse' 
                   WHEN 4 THEN 'Lawine' 
    END AS h_gef_pot,
    CASE igef_pot WHEN 1 THEN 'schwach' 
                  WHEN 2 THEN 'mittel' 
                  WHEN 3 THEN 'stark' 
    END AS igef_pot,
    bemerkunge,
    flaeche,
    st_multi(wkb_geometry) as geometrie,
    status,
    name_2,
    gem_name,
    gem_bfs
FROM 
    awjf.sw_funktion_ar
WHERE 
    archive = 0
;
