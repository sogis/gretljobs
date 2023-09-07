SELECT 
    substring(fst_nr FOR 10) AS fundstellen_nummer, 
    substring(flurname_adresse FOR 30) AS fundst_adresse_flurname, 
    substring(art_der_fundstelle FOR 100) AS fundstellen_art, 
    CAST(COALESCE(geschuetzt, 0) AS boolean) AS geschuetzt, 
    qualitaet_lokalisierung, 
    koord_x AS x_koordinate, 
    koord_y AS y_koordinate, 
    substring(kurzbeschreibung FOR 3000) as kurzbeschreibung, 
    substring(gemeinde FOR 30) AS gemeindename_ablage, 
    rrb_nummer
FROM 
    public.rep_view_fundstellen
;