INSERT INTO 
    arp_richtplan_v2.t_ili2db_basket (
        t_id,
        dataset,
        topic,
        attachmentkey 
        )
    
VALUES
    (2, '1', 'SO_ARP_Richtplan_20231018.Detailkarten', 'datenmigration'),
    (129, '1', 'SO_ARP_Richtplan_20231018.Richtplankarte', 'datenmigration'),
    (nextval('arp_richtplan_v2.t_ili2db_seq'), '1', 'SO_ARP_Richtplan_20231018.Raumkonzept', 'datenmigration')
;