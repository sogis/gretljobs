SELECT 
    typ_bezeichnung, 
    typ_abkuerzung, 
    typ_verbindlichkeit, 
    typ_bemerkungen, 
    typ_kt, 
    typ_code_kommunal, 
    geometrie, 
    geschaefts_nummer AS name_nummer, 
    rechtsstatus, 
    publiziertab AS publiziert_ab, 
    bemerkungen, 
    erfasser, 
    datum_erfassung, 
    dokumente, 
    bfs_nr
FROM 
    arp_nutzungsplanung_pub_v1.nutzungsplanung_erschliessung_flaechenobjekt
;

