SELECT 
    t_id, 
    flachmoor_id, 
    flaeche as area, 
    nummer, 
    bezeichnung, 
    geometrie
FROM 
    arp_naturschutzobjekte_pub_v1.flachmoor
;
