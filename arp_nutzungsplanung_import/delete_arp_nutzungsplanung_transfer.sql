-- Grundnutzung
DELETE FROM
    arp_nutzungsplanung_transfer_v1.nutzungsplanung_typ_grundnutzung_dokument
;
DELETE FROM
    arp_nutzungsplanung_transfer_v1.nutzungsplanung_grundnutzung
;
DELETE FROM
    arp_nutzungsplanung_transfer_v1.nutzungsplanung_typ_grundnutzung
;
--überlagernde Fläche
DELETE FROM
    arp_nutzungsplanung_transfer_v1.nutzungsplanung_typ_ueberlagernd_flaeche_dokument
;
DELETE FROM
    arp_nutzungsplanung_transfer_v1.nutzungsplanung_ueberlagernd_flaeche
;
DELETE FROM
    arp_nutzungsplanung_transfer_v1.nutzungsplanung_typ_ueberlagernd_flaeche
;
--überlagernde Linie
DELETE FROM
    arp_nutzungsplanung_transfer_v1.nutzungsplanung_typ_ueberlagernd_linie_dokument
;
DELETE FROM
    arp_nutzungsplanung_transfer_v1.nutzungsplanung_ueberlagernd_linie
;
DELETE FROM
    arp_nutzungsplanung_transfer_v1.nutzungsplanung_typ_ueberlagernd_linie
;
--überlagernde Punkt
DELETE FROM
    arp_nutzungsplanung_transfer_v1.nutzungsplanung_typ_ueberlagernd_punkt_dokument
;
DELETE FROM
    arp_nutzungsplanung_transfer_v1.nutzungsplanung_ueberlagernd_punkt
;
DELETE FROM
    arp_nutzungsplanung_transfer_v1.nutzungsplanung_typ_ueberlagernd_punkt
;
--Erschliessung Fläche
DELETE FROM
    arp_nutzungsplanung_transfer_v1.erschlssngsplnung_typ_erschliessung_flaechenobjekt_dokument
;
DELETE FROM
    arp_nutzungsplanung_transfer_v1.erschlssngsplnung_erschliessung_flaechenobjekt
;
DELETE FROM
    arp_nutzungsplanung_transfer_v1.erschlssngsplnung_typ_erschliessung_flaechenobjekt
;
--Erschliessung Linie
DELETE FROM
    arp_nutzungsplanung_transfer_v1.erschlssngsplnung_typ_erschliessung_linienobjekt_dokument
;
DELETE FROM
    arp_nutzungsplanung_transfer_v1.erschlssngsplnung_erschliessung_linienobjekt
;
DELETE FROM
    arp_nutzungsplanung_transfer_v1.erschlssngsplnung_typ_erschliessung_linienobjekt
;
--Erschliessung Punkt
DELETE FROM
    arp_nutzungsplanung_transfer_v1.erschlssngsplnung_typ_erschliessung_punktobjekt_dokument
;
DELETE FROM
    arp_nutzungsplanung_transfer_v1.erschlssngsplnung_erschliessung_punktobjekt
;
DELETE FROM
    arp_nutzungsplanung_transfer_v1.erschlssngsplnung_typ_erschliessung_punktobjekt
;
-- Lärmempfindlichkeitsstufen
DELETE FROM
    arp_nutzungsplanung_transfer_v1.laermmpfhktsstfen_typ_empfindlichkeitsstufe_dokument
;
DELETE FROM
    arp_nutzungsplanung_transfer_v1.laermmpfhktsstfen_empfindlichkeitsstufe
;
DELETE FROM
    arp_nutzungsplanung_transfer_v1.laermmpfhktsstfen_typ_empfindlichkeitsstufe
;
-- Dokument
DELETE FROM
    arp_nutzungsplanung_transfer_v1.rechtsvorschrften_dokument
;
-- Basket / Dataset 
DELETE FROM
    arp_nutzungsplanung_transfer_v1.t_ili2db_basket
;
DELETE FROM
    arp_nutzungsplanung_transfer_v1.t_ili2db_dataset
;