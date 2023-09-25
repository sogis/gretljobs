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
    kurzbeschreibung, 
    gemeindename_ablage, 
    rrb_nummer,
    g.amultipolygon 
FROM 
    ada_archaeologie_v1.geo_flaeche g
JOIN
    ada_archaeologie_v1.fachapplikation_fundstelle f ON g.fundstelle_role = f.t_id 
WHERE 
    oereb_flaeche IS FALSE
;
