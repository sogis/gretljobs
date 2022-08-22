SELECT
    aname,
    so_str_id,
    eid,
    von_knoten,
    nach_knoten,
    dtv_gesamt,
    dtv_kategorie,
    dtv_personenwagen,
    dtv_motorraeder,
    dtv_lieferwagen,
    dtv_lastwagen,
    dtv_lastzuege,
    asp_gesamt,
    asp_personenwagen,
    asp_motorraeder,
    asp_lieferwagen,
    asp_lastwagen,
    asp_lastzuege,
    dwv_gesamt,
    dwv_personenwagen,
    dwv_motorraeder,
    dwv_lieferwagen,
    dwv_lastwagen,
    dwv_lastzuege,
    neigung_be,
    geschwindigkeit,
    laenge,
    kapazitaet,
    auslastung,
    typeno,
    geometrie
FROM
    avt_gesamtverkehrsmodell_2015_v1.gesamtverkehrsmodell_prognose_2040
;
