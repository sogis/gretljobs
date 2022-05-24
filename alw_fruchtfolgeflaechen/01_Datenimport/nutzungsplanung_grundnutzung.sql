SELECT 
    typ_bezeichnung, 
    typ_abkuerzung, 
    typ_verbindlichkeit, 
    typ_bemerkungen, 
    typ_kt, 
    typ_code_kommunal, 
    typ_nutzungsziffer, 
    typ_nutzungsziffer_art, 
    typ_geschosszahl, 
    geometrie, 
    name_nummer, 
    rechtsstatus, 
    publiziert_ab, 
    bemerkungen, 
    erfasser, 
    datum_erfassung, 
    dokumente, 
    bfs_nr
FROM 
    arp_nutzungsplanung_pub_v1.nutzungsplanung_grundnutzung
;
