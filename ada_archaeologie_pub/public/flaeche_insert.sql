WITH flaeche_beruert_siedlung AS (
    SELECT 
        f.amultipolygon, 
        x_koordinate,
        y_koordinate,
        fundstellen_nummer, 
        fundst_adresse_flurname, 
        fundstellen_art, 
        geschuetzt, 
        geschuetzt_txt, 
        qualitaet_lokalisierung, 
        qualitaet_lokalisierung_txt, 
        gemeindename_ablage, 
        rrb_nummer
    FROM 
        ada_archaeologie_pub_v1.restricted_flaechenfundstelle f
    JOIN
        arp_bauzonengrenzen_pub.bauzonengrenzen_bauzonengrenze s ON public.ST_INTERSECTS(s.geometrie, f.amultipolygon)  
    WHERE
        public.ST_Area(public.ST_INTERSECTION(s.geometrie, f.amultipolygon)) > 5
)

INSERT INTO ada_archaeologie_pub_v1.public_flaechenfundstelle_siedlungsgebiet(
    amultipolygon, 
    fundstellen_nummer, 
    fundst_adresse_flurname, 
    fundstellen_art, 
    geschuetzt, 
    geschuetzt_txt, 
    qualitaet_lokalisierung, 
    qualitaet_lokalisierung_txt, 
    gemeindename_ablage, 
    rrb_nummer,
    x_koordinate,
    y_koordinate
)
SELECT
    amultipolygon, 
    fundstellen_nummer, 
    fundst_adresse_flurname, 
    fundstellen_art, 
    geschuetzt, 
    geschuetzt_txt, 
    qualitaet_lokalisierung, 
    qualitaet_lokalisierung_txt, 
    gemeindename_ablage, 
    rrb_nummer,
    x_koordinate,
    y_koordinate
FROM flaeche_beruert_siedlung
;
