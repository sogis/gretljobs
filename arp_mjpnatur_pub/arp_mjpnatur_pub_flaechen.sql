WITH 
beurteilungs_metainfo_wiesen AS (
SELECT vereinbarung, beurteilungsdatum,
   einstufungbeurteilungistzustand_wiesenkategorie,
   bewirtschaftabmachung_emdenbodenheu, 
   bewirtschaftabmachung_schnittzeitpunkt_1,
   bewirtschaftabmachung_messerbalkenmaehgeraet, 
   -- ungenutzt, aber evtl. relevant: bewirtschaftabmachung_emdenbodenheu_nachbedarf, 
   -- ungenutzt, aber evtl. relevant: bewirtschaftabmachung_herbstschnitt,
   bewirtschaftabmachung_herbstweide,
   bewirtschaftabmachung_rueckzugstreifen
   FROM arp_mjpnl_v2.mjpnl_beurteilung_wiese
   -- berücksichtige nur besprochene Beurteilungen
   WHERE mit_bewirtschafter_besprochen IS TRUE
   UNION 
   SELECT vereinbarung, beurteilungsdatum, 
   einstufungbeurteilungistzustand_wiesenkategorie,
   bewirtschaftabmachung_emdenbodenheu, 
   bewirtschaftabmachung_schnittzeitpunkt_1, 
   bewirtschaftabmachung_messerbalkenmaehgeraet, 
   -- ungenutzt, aber evtl. relevant: bewirtschaftabmachung_emdenbodenheu_nachbedarf, 
   -- ungenutzt, aber evtl. relevant: bewirtschaftabmachung_herbstschnitt,
   bewirtschaftabmachung_herbstweide,
   bewirtschaftabmachung_rueckzugstreifen
   FROM arp_mjpnl_v2.mjpnl_beurteilung_wbl_wiese
   -- berücksichtige nur besprochene Beurteilungen
   WHERE mit_bewirtschafter_besprochen IS TRUE
)SELECT 
    geometrie,
    vereinbarungs_nr_alt AS alte_vereinbarungsnummer,
    vereinbarungs_nr AS neue_vereinbarungsnummer,
    vereinbarungsart,
    person.name_vorname AS bewirtschafter,
    flaeche,
    NULL AS laufmeter,
    flurname,
    bw.einstufungbeurteilungistzustand_wiesenkategorie AS wiesenkategorie,
    bewirtschaftabmachung_emdenbodenheu AS emden,
    bewirtschaftabmachung_schnittzeitpunkt_1 AS schnittzeitpunkt,
    bewirtschaftabmachung_messerbalkenmaehgeraet AS balkenmaeher,
    bewirtschaftabmachung_herbstweide AS herbstweide,
    bewirtschaftabmachung_rueckzugstreifen AS rueckzugsstreifen,
    NULL AS letzter_unterhalt,
    NULL AS datum_beurteilung
FROM 
    arp_mjpnl_v2.mjpnl_vereinbarung vereinbarung
LEFT JOIN arp_mjpnl_v2.betrbsdttrktrdten_gelan_person person 
    ON vereinbarung.gelan_pid_gelan = person.pid_gelan 
LEFT JOIN beurteilungs_metainfo_wiesen bw
     ON vereinbarung.t_id = bw.vereinbarung
     -- berücksichtige nur die neusten (sofern mehrere existieren)
     AND bw.beurteilungsdatum = (SELECT MAX(beurteilungsdatum) FROM beurteilungs_metainfo_wiesen b WHERE b.vereinbarung = vereinbarung.t_id)
WHERE 
-- nur die "gültigen" Vereinbarungen
vereinbarung.status_vereinbarung = 'aktiv' AND vereinbarung.bewe_id_geprueft IS TRUE AND vereinbarung.ist_nutzungsvereinbarung IS NOT TRUE
