WITH punkt_in_siedlung AS (
    SELECT 
        p.t_id AS punkt_tid
    FROM 
        ada_archaeologie_pub_v1.restricted_punktfundstelle p
    JOIN
        arp_bauzonengrenzen_pub.bauzonengrenzen_bauzonengrenze s ON public.ST_CONTAINS(s.geometrie, p.punkt)  
    GROUP BY 
        p.t_id
)

INSERT INTO ada_archaeologie_pub_v1.public_punktfundstelle_siedlungsgebiet (
    punkt, 
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
    punkt, 
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
    ada_archaeologie_pub_v1.restricted_punktfundstelle p
JOIN 
    punkt_in_siedlung s ON p.t_id = s.punkt_tid
;