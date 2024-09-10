INSERT INTO arp_mjpnl_gelan_v1.mehrjahresprgramm_vereinbarungensflaechen (
    geometrie, 
    artcode, 
    ueberlagernd, 
    vereinbarungsstart, 
    baumanzahl, 
    aenderungsdatum, 
    bemerkung
)

SELECT 
    vereinbarung.geometrie,
    CASE 
        WHEN vereinbarungsart IN ('Wiese', 'WBL_Wiese') THEN 42055 --Wiesen
        WHEN vereinbarungsart IN ('WBL_Weide', 'Weide_LN', 'Weide_SOEG') THEN 42060 --Weiden
        WHEN vereinbarungsart IN ('Hecke', 'Lebhag') THEN 42065 --Hecken
        WHEN vereinbarungsart IN ('OBL', 'Hostet') THEN 42070 --Bäume
        WHEN vereinbarungsart IN ('ALR_Saum', 'ALR_Buntbrache') THEN 42050 --Unbestimmt
    END AS artcode,
    CASE 
        WHEN vereinbarungsart IN ('OBL', 'Hostet') THEN TRUE 
        ELSE FALSE 
    END AS ueberlappungueberlagernd,
    vereinbarung.startdatum AS vereinbarungsstart,
    hostet.grundbeitrag_baum_anzahl AS baumanzahl,
    coalesce(vereinbarung.aenderungsdatum, vereinbarung.erstellungsdatum) AS aenderungsdatum, 
    vereinbarung.vereinbarungs_nr||' '||vereinbarung.vereinbarungsart AS bemerkung
FROM 
    arp_mjpnl_v2.mjpnl_vereinbarung vereinbarung
LEFT JOIN 
    arp_mjpnl_v2.mjpnl_beurteilung_hostet hostet
    ON 
    hostet.vereinbarung = vereinbarung.t_id
WHERE 
    vereinbarung.status_vereinbarung = 'aktiv' 
    AND 
    vereinbarung.bewe_id_geprueft IS TRUE 
    AND 
    vereinbarung.ist_nutzungsvereinbarung IS NOT TRUE
;
