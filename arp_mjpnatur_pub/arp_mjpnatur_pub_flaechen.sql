WITH 
monate AS (
    SELECT unnest(ARRAY[
        'January', 'February', 'March', 'April', 'May', 'June', 
        'July', 'August', 'September', 'October', 'November', 'December'
    ]) AS en,
    unnest(ARRAY[
        'Januar', 'Februar', 'März', 'April', 'Mai', 'Juni', 
        'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember'
    ]) AS de
),

beurteilungs_metainfo_wiesen AS (
    SELECT 
        vereinbarung, 
        beurteilungsdatum,
        einstufungbeurteilungistzustand_wiesenkategorie,
        bewirtschaftabmachung_emdenbodenheu, 
        TO_CHAR(bewirtschaftabmachung_schnittzeitpunkt_1, 'DD.') || ' ' || monate.de AS bewirtschaftabmachung_schnittzeitpunkt_1,
        bewirtschaftabmachung_messerbalkenmaehgeraet, 
        -- ungenutzt, aber evtl. relevant: bewirtschaftabmachung_emdenbodenheu_nachbedarf, 
        -- ungenutzt, aber evtl. relevant: bewirtschaftabmachung_herbstschnitt,
        bewirtschaftabmachung_herbstweide,
        bewirtschaftabmachung_rueckzugstreifen
    FROM 
        arp_mjpnl_v2.mjpnl_beurteilung_wiese
        -- berücksichtige nur besprochene Beurteilungen => Wird nach Sandra Geiser (17.03.2025) nicht so benötigt. 
    --WHERE 
    --    mit_bewirtschafter_besprochen IS TRUE
    LEFT JOIN 
        monate 
        ON 
        monate.en = TRIM(TO_CHAR(bewirtschaftabmachung_schnittzeitpunkt_1, 'Month'))
    UNION 
    SELECT 
        vereinbarung, 
        beurteilungsdatum, 
        einstufungbeurteilungistzustand_wiesenkategorie,
        bewirtschaftabmachung_emdenbodenheu, 
        TO_CHAR(bewirtschaftabmachung_schnittzeitpunkt_1, 'DD.') || ' ' || monate.de AS bewirtschaftabmachung_schnittzeitpunkt_1,
        bewirtschaftabmachung_messerbalkenmaehgeraet, 
        -- ungenutzt, aber evtl. relevant: bewirtschaftabmachung_emdenbodenheu_nachbedarf, 
        -- ungenutzt, aber evtl. relevant: bewirtschaftabmachung_herbstschnitt,
        bewirtschaftabmachung_herbstweide,
        bewirtschaftabmachung_rueckzugstreifen
    FROM 
        arp_mjpnl_v2.mjpnl_beurteilung_wbl_wiese
         -- berücksichtige nur besprochene Beurteilungen => Wird nach Sandra Geiser (17.03.2025) nicht so benötigt. 
    --WHERE 
    --    mit_bewirtschafter_besprochen IS TRUE
    LEFT JOIN 
        monate 
        ON 
        monate.en = TRIM(TO_CHAR(bewirtschaftabmachung_schnittzeitpunkt_1, 'Month'))
),

beurteilungen_datum AS (
    SELECT 
        to_char(beurteilung.beurteilungsdatum, 'DD.MM.YYYY') AS beurteilungsdatum,
        NULL AS letzter_unterhalt,
        vereinbarung
    FROM 
        arp_mjpnl_v2.mjpnl_beurteilung_alr_buntbrache beurteilung 
    UNION ALL 
    SELECT 
        to_char(beurteilung.beurteilungsdatum, 'DD.MM.YYYY') AS beurteilungsdatum,
        NULL AS letzter_unterhalt,
        vereinbarung
    FROM 
        arp_mjpnl_v2.mjpnl_beurteilung_alr_saum beurteilung 
    UNION ALL 
    SELECT 
        to_char(beurteilung.beurteilungsdatum, 'DD.MM.YYYY') AS beurteilungsdatum,
        bewirtschaftung_hecke_letzterunterhalt::text AS letzter_unterhalt,
        vereinbarung
    FROM 
        arp_mjpnl_v2.mjpnl_beurteilung_hecke beurteilung 
    UNION ALL 
    SELECT 
        to_char(beurteilung.beurteilungsdatum, 'DD.MM.YYYY') AS beurteilungsdatum,
        NULL AS letzter_unterhalt,
        vereinbarung
    FROM 
        arp_mjpnl_v2.mjpnl_beurteilung_hostet beurteilung 
    UNION ALL 
    SELECT 
        to_char(beurteilung.beurteilungsdatum, 'DD.MM.YYYY') AS beurteilungsdatum,
        NULL AS letzter_unterhalt,
        vereinbarung
    FROM 
        arp_mjpnl_v2.mjpnl_beurteilung_obl beurteilung 
    UNION ALL 
    SELECT 
        to_char(beurteilung.beurteilungsdatum, 'DD.MM.YYYY') AS beurteilungsdatum,
        NULL AS letzter_unterhalt,
        vereinbarung
    FROM 
        arp_mjpnl_v2.mjpnl_beurteilung_wbl_weide beurteilung 
    UNION ALL 
    SELECT 
        to_char(beurteilung.beurteilungsdatum, 'DD.MM.YYYY') AS beurteilungsdatum,
        NULL AS letzter_unterhalt,
        vereinbarung
    FROM 
        arp_mjpnl_v2.mjpnl_beurteilung_wbl_wiese beurteilung 
    UNION ALL 
    SELECT 
        to_char(beurteilung.beurteilungsdatum, 'DD.MM.YYYY') AS beurteilungsdatum,
        NULL AS letzter_unterhalt,
        vereinbarung
    FROM 
        arp_mjpnl_v2.mjpnl_beurteilung_weide_ln beurteilung 
    UNION ALL 
    SELECT 
        to_char(beurteilung.beurteilungsdatum, 'DD.MM.YYYY') AS beurteilungsdatum,
        NULL AS letzter_unterhalt,
        vereinbarung
    FROM 
        arp_mjpnl_v2.mjpnl_beurteilung_weide_soeg beurteilung 
    UNION ALL 
    SELECT 
        to_char(beurteilung.beurteilungsdatum, 'DD.MM.YYYY') AS beurteilungsdatum,
        NULL AS letzter_unterhalt,
        vereinbarung
    FROM 
        arp_mjpnl_v2.mjpnl_beurteilung_wiese beurteilung 
),

laufmeter AS (
    SELECT 
        bewirtschaftung_lebhag_laufmeter AS laufmeter,
        vereinbarung
    FROM 
        arp_mjpnl_v2.mjpnl_beurteilung_hecke 
)

SELECT 
    geometrie,
    vereinbarungs_nr_alt AS alte_vereinbarungsnummer,
    vereinbarungs_nr AS neue_vereinbarungsnummer,
    vereinbarungsart,
    person.name_vorname AS bewirtschafter,
    flaeche,
    laufmeter.laufmeter AS laufmeter,
    flurname,
    bw.einstufungbeurteilungistzustand_wiesenkategorie AS wiesenkategorie,
    bewirtschaftabmachung_emdenbodenheu AS emden,
    bewirtschaftabmachung_schnittzeitpunkt_1 AS schnittzeitpunkt,
    bewirtschaftabmachung_messerbalkenmaehgeraet AS balkenmaeher,
    bewirtschaftabmachung_herbstweide AS herbstweide,
    bewirtschaftabmachung_rueckzugstreifen AS rueckzugsstreifen,
    beurteilungen_datum.letzter_unterhalt AS letzter_unterhalt,
    beurteilungen_datum.beurteilungsdatum AS datum_beurteilung,
    vereinbarung.status_vereinbarung AS vereinbarung_status
FROM 
    arp_mjpnl_v2.mjpnl_vereinbarung vereinbarung
LEFT JOIN 
    arp_mjpnl_v2.betrbsdttrktrdten_gelan_person person 
    ON 
    vereinbarung.gelan_pid_gelan = person.pid_gelan 
LEFT JOIN 
    beurteilungs_metainfo_wiesen bw
    ON 
    vereinbarung.t_id = bw.vereinbarung
     -- berücksichtige nur die neusten (sofern mehrere existieren)
    AND bw.beurteilungsdatum = (
                                SELECT 
                                    MAX(beurteilungsdatum) 
                                FROM 
                                    beurteilungs_metainfo_wiesen b 
                                WHERE 
                                    b.vereinbarung = vereinbarung.t_id
                               )
LEFT JOIN 
    beurteilungen_datum  
    ON 
    beurteilungen_datum.vereinbarung = vereinbarung.t_id
     -- berücksichtige nur die neusten (sofern mehrere existieren)
    AND beurteilungen_datum.beurteilungsdatum = (
                                SELECT 
                                    MAX(beurteilungsdatum) 
                                FROM 
                                    beurteilungen_datum b 
                                WHERE 
                                    b.vereinbarung = vereinbarung.t_id
                               )
LEFT JOIN 
    laufmeter 
    ON 
    laufmeter.vereinbarung = vereinbarung.t_id 
        
WHERE 
    --vereinbarung.bewe_id_geprueft IS TRUE  soll laut Sandra Geiser (05.03.2025) nicht mehr Filterkriterium sein.
    --AND 
    vereinbarung.ist_nutzungsvereinbarung IS NOT TRUE
    AND 
    person.name_vorname IS NOT NULL
