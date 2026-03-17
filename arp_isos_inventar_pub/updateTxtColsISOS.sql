UPDATE 
   arp_isos_inventar_pub_v2.isos_inventar
SET 
    art_txt = (SELECT 
                         dispname 
                     FROM 
                        arp_isos_inventar_pub_v2.isos_inventar_art
                     WHERE 
                         isos_inventar.art = isos_inventar_art.ilicode)
;


UPDATE 
   arp_isos_inventar_pub_v2.isos_inventar
SET 
    erhaltungsziel_txt = (SELECT 
                         dispname 
                     FROM 
                        arp_isos_inventar_pub_v2.isos_inventar_erhaltungsziel
                     WHERE 
                         isos_inventar.erhaltungsziel = isos_inventar_erhaltungsziel.ilicode)
;

UPDATE 
   arp_isos_inventar_pub_v2.isos_inventar
SET 
    bedeutung_txt = (SELECT 
                         dispname 
                     FROM 
                        arp_isos_inventar_pub_v2.qualitaet
                     WHERE 
                         isos_inventar.bedeutung = qualitaet.ilicode)
;

UPDATE 
   arp_isos_inventar_pub_v2.isos_inventar
SET 
    architeckturhistorische_qualitaet_txt = (SELECT 
                         dispname 
                     FROM 
                        arp_isos_inventar_pub_v2.qualitaet
                     WHERE 
                         isos_inventar.architeckturhistorische_qualitaet = qualitaet.ilicode)
;


