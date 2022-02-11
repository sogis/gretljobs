SELECT 
    t_id, 
    fm_id AS flachmoor_id, 
    area, 
    nr_id AS nummer, 
    bezeichung AS bezeichnung, 
    geometrie
FROM 
    arp_naturschutz_pub_v1.flachmoor
;
