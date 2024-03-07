DELETE FROM 
    arp_richtplan_pub_v2.richtplankarte_ueberlagernde_linie
WHERE
    datenquelle = 'inventar_historische_verkehrswege'
;

DELETE FROM 
    arp_richtplan_pub_v2.richtplankarte_ueberlagernde_linie
WHERE
    datenquelle = 'inventar_historischer_verkehrsweg'
