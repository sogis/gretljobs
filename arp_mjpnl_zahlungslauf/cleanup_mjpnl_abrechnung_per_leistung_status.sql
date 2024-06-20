-- Setze die Status aller diesjährigen freigegeben-Leistungen, die einmalig oder migriert sind und *keine aktive* Vereinbarungen haben auf in_bearbeitung

UPDATE ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung l
SET status_abrechnung = 'in_bearbeitung'
FROM ${DB_Schema_MJPNL}.mjpnl_vereinbarung vbg
WHERE 
    l.vereinbarung = vbg.t_id
    AND NOT (
        vbg.status_vereinbarung = 'aktiv' AND vbg.bewe_id_geprueft IS TRUE AND vbg.ist_nutzungsvereinbarung IS NOT TRUE
    )
    AND l.auszahlungsjahr = ${AUSZAHLUNGSJAHR}::integer
    AND l.status_abrechnung = 'freigegeben'
    AND (
        l.einmalig = TRUE
        OR l.migriert = TRUE
    )
;
