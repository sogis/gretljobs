WITH flaeche_beruert_siedlung AS (
    SELECT 
        f.t_id AS flaeche_tid
    FROM 
        ada_archaeologie_pub_v1.restricted_flaechenfundstelle f
    JOIN
        arp_bauzonengrenzen_pub.bauzonengrenzen_bauzonengrenze s ON public.ST_INTERSECTS(s.geometrie, f.amultipolygon)  
    WHERE
        public.ST_Area(public.ST_INTERSECTION(s.geometrie, f.amultipolygon)) > 5
    GROUP BY 
        f.t_id
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
    rrb_nummer
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
    rrb_nummer
FROM 
    ada_archaeologie_pub_v1.restricted_flaechenfundstelle f
JOIN
    flaeche_beruert_siedlung s ON f.t_id = s.flaeche_tid
;
