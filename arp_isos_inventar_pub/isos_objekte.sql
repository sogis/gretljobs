SELECT 
    geometrie, 
    objektname, 
    art, 
    nummer, 
    benennung, 
    aufnahmekategorie, 
    architeckturhistorische_qualitaet, 
    bedeutung, 
    erhaltungsziel, 
    erhaltungsziel as erhaltungsziel_txt,
    hinweis, 
    stoerend, 
    bild_nummer, 
    link_objektblatt

FROM arp_isos_inventar_v2.isos_inventar;

