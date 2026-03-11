UPDATE 
   arp_kulturgueterschutzobjekte_pub_v1.objekte
SET 
    kategorie_txt = (SELECT 
                         dispname 
                     FROM 
                        arp_kulturgueterschutzobjekte_pub_v1.objekte_kategorie
                     WHERE 
                         objekte.kategorie = objekte_kategorie.ilicode)
;

