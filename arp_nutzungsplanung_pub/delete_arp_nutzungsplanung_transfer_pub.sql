-- Grundnutzung
DELETE FROM
    arp_nutzungsplanung_transfer_pub_v1.nutzungsplanung_grundnutzung
;

--überlagernde Fläche
DELETE FROM
    arp_nutzungsplanung_transfer_pub_v1.nutzungsplanung_ueberlagernd_flaeche
;

--überlagernde Linie
DELETE FROM
    arp_nutzungsplanung_transfer_pub_v1.nutzungsplanung_ueberlagernd_linie
;

--überlagernde Punkt
DELETE FROM
    arp_nutzungsplanung_transfer_pub_v1.nutzungsplanung_ueberlagernd_punkt
;
--Erschliessung Fläche
DELETE FROM
    arp_nutzungsplanung_transfer_pub_v1.erschlssngsplnung_erschliessung_flaechenobjekt
;
--Erschliessung Linie
DELETE FROM
    arp_nutzungsplanung_transfer_pub_v1.erschlssngsplnung_erschliessung_linienobjekt
;

--Erschliessung Punkt
DELETE FROM
    arp_nutzungsplanung_transfer_pub_v1.erschlssngsplnung_erschliessung_punktobjekt
;

-- Lärmempfindlichkeitsstufen
DELETE FROM
    arp_nutzungsplanung_transfer_pub_v1.laermmpfhktsstfen_empfindlichkeitsstufe
;

-- Basket / Dataset 
DELETE FROM
    arp_nutzungsplanung_transfer_pub_v1.t_ili2db_basket
;
DELETE FROM
    arp_nutzungsplanung_transfer_pub_v1.t_ili2db_dataset
;