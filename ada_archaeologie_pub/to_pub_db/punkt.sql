SELECT
    f.fundstellen_nummer, 
    f.x_koordinate,
    f.y_koordinate,
    fundst_adresse_flurname, 
    fundstellen_art, 
    CAST(geschuetzt as boolean) as geschuetzt, 
    geschuetzt::varchar as geschuetzt_txt, -- Attribut wird von schema-job angelegt. Setzen auf dummy-wert.
    qualitaet_lokalisierung, 
    qualitaet_lokalisierung as qualitaet_lokalisierung_txt,
    substring(kurzbeschreibung FOR 3000) as kurzbeschreibung, 
    gemeindename_ablage, 
    rrb_nummer,
    public.ST_Point(x_koordinate::float, y_koordinate::float) AS punkt
FROM 
    ada_archaeologie_v1.fachapplikation_fundstelle f
LEFT JOIN 
    ada_archaeologie_v1.geo_flaeche g ON f.t_id = g.fundstelle_role 
WHERE 
    g.t_id IS NULL 
;
