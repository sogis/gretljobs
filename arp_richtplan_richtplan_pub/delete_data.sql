DELETE FROM 
    arp_richtplan_pub_v2.raumkonzept_flaeche
WHERE
    datenquelle = 'Richtplan'
;

DELETE FROM 
    arp_richtplan_pub_v2.raumkonzept_linie
WHERE
    datenquelle = 'Richtplan'
;

DELETE FROM 
    arp_richtplan_pub_v2.raumkonzept_punkt
WHERE
    datenquelle = 'Richtplan'
;

DELETE FROM 
    arp_richtplan_pub_v2.richtplankarte_ueberlagernde_flaeche
WHERE
    datenquelle = 'Richtplan'
;

DELETE FROM 
    arp_richtplan_pub_v2.richtplankarte_ueberlagernde_linie
WHERE
    datenquelle = 'Richtplan'
;

DELETE FROM 
    arp_richtplan_pub_v2.richtplankarte_ueberlagernder_punkt
WHERE
    datenquelle = 'Richtplan'
;

DELETE FROM 
    arp_richtplan_pub_v2.detailkarten_flaeche
WHERE
    datenquelle = 'Richtplan'
;

DELETE FROM 
    arp_richtplan_pub_v2.detailkarten_linie
WHERE
    datenquelle = 'Richtplan'
;

DELETE FROM 
    arp_richtplan_pub_v2.detailkarten_punkt
WHERE
    datenquelle = 'Richtplan'
;