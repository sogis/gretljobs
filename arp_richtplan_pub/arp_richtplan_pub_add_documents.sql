UPDATE arp_richtplan_pub_v1.richtplankarte_ueberlagernde_flaeche
    SET dokumente = '[{"t_id":null,"titel":"Richtplankapitel E-2.4 Windenergie","publiziertab":null,"bemerkung":null,"dokument":"https://geo.so.ch/docs/ch.so.arp.richtplan/E-2.4.pdf"}]'
WHERE     
    objekttyp = 'Windenergie'
;

UPDATE arp_richtplan_pub_v1.richtplankarte_ueberlagernde_flaeche
    SET dokumente = '[{"t_id":null,"titel":"Richtplankapitel E-3.2 Kies","publiziertab":null,"bemerkung":null,"dokument":"https://geo.so.ch/docs/ch.so.arp.richtplan/E-3_2.pdf"}]'
WHERE     
    objekttyp = 'Abbaustelle.Kies'
;

UPDATE arp_richtplan_pub_v1.richtplankarte_ueberlagernde_flaeche
    SET dokumente = '[{"t_id":null,"titel":"Richtplankapitel E-3.3 Kalkstein","publiziertab":null,"bemerkung":null,"dokument":"https://geo.so.ch/docs/ch.so.arp.richtplan/E-3_3.pdf"}]'
WHERE     
    objekttyp = 'Abbaustelle.Kalkstein'
;

UPDATE arp_richtplan_pub_v1.richtplankarte_ueberlagernde_flaeche
    SET dokumente = '[{"t_id":null,"titel":"Richtplankapitel E-3.4 Ton","publiziertab":null,"bemerkung":null,"dokument":"https://geo.so.ch/docs/ch.so.arp.richtplan/E-3_4.pdf"}]'
WHERE     
    objekttyp = 'Abbaustelle.Ton'
;

UPDATE arp_richtplan_pub_v1.richtplankarte_ueberlagernde_flaeche
    SET dokumente = '[{"t_id":null,"titel":"Richtplankapitel E-4.2 Deponien","publiziertab":null,"bemerkung":null,"dokument":"https://geo.so.ch/docs/ch.so.arp.richtplan/E-4_2.pdf"}]'
WHERE     
    objekttyp = 'Deponie'
;

UPDATE arp_richtplan_pub_v1.richtplankarte_ueberlagernde_flaeche
    SET dokumente = '[{"t_id":null,"titel":"Richtplankapitel L-1.2 Fruchtfolgeflächen","publiziertab":null,"bemerkung":null,"dokument":"https://geo.so.ch/docs/ch.so.arp.richtplan/L-1_2.pdf"}]'
WHERE     
    objekttyp = 'Fruchtfolgeflaeche'
;

UPDATE arp_richtplan_pub_v1.richtplankarte_ueberlagernde_linie
    SET dokumente = '[{"t_id":null,"titel":"Richtplankapitel S-2.3 Historische Verkehrswege","publiziertab":null,"bemerkung":null,"dokument":"https://geo.so.ch/docs/ch.so.arp.richtplan/S-2_3.pdf"}]'
WHERE     
    objekttyp = 'Historischer_Verkehrsweg'
;
