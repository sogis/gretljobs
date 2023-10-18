-- Setze die Status aller diesjährigen freigegeben-Leistungen, die einmalig oder migriert sind und *keine aktive* Vereinbarungen haben auf in_bearbeitung

UPDATE ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung l
SET status_abrechnung = 'in_bearbeitung'
FROM ${DB_Schema_MJPNL}.mjpnl_vereinbarung vbg
WHERE 
    l.vereinbarung = vbg.t_id
    AND vbg.status_vereinbarung != 'aktiv'
    AND l.auszahlungsjahr = ${AUSZAHLUNGSJAHR}::integer
    AND l.status_abrechnung = 'freigegeben'
    AND (
        l.einmalig = TRUE
        OR l.migriert = TRUE
    )
;

-- Setze die Status aller diesjährigen in_bearbeitung-Leistungen, die migriert sind und eine *aktive* Vereinbarungen haben auf freigegeben
-- Die einmaligen setzen wir nicht auf freigegeben (weil wir ja nicht wissen, ob sie absichtlich auf 'in_bearbeitung' standen vorher)
UPDATE ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung l
SET status_abrechnung = 'freigegeben'
FROM ${DB_Schema_MJPNL}.mjpnl_vereinbarung vbg
WHERE 
    l.vereinbarung = vbg.t_id
    AND vbg.status_vereinbarung = 'aktiv'
    AND l.auszahlungsjahr = ${AUSZAHLUNGSJAHR}::integer
    AND l.status_abrechnung = 'in_bearbeitung'
    AND l.migriert = TRUE
;