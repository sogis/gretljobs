SELECT 
    t_id, 
    flachmoor_id, 
    flaeche as area, 
    nummer, 
    bezeichnung, 
    st_multi(geometrie)
FROM 
    arp_naturschutzobjekte_pub_v1.flachmoor
;
