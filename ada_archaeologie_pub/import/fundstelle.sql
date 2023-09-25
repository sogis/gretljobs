SELECT 
    fst_nr AS fundstellen_nummer, 
    flurname_adresse AS fundst_adresse_flurname, 
    art_der_fundstelle AS fundstellen_art, 
    geschuetzt, 
    -- Sofern replace(..) auf imdas-db nicht mehr verfügar: 
    -- In nachfolgendem update-statement ausfueren
    replace(qualitaet_lokalisierung, ' ', '_') AS qualitaet_lokalisierung, 
    koord_x AS x_koordinate, 
    koord_y AS y_koordinate, 
    kurzbeschreibung, 
    gemeinde AS gemeindename_ablage, 
    rrb_nummer
FROM 
    public.rep_view_fundstellen
;