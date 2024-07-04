-- wir löschen alle diesjährigen Leitungen ohne Vereinbarung
-- denn die Leistungen sind nicht über CASCADE abhängig von Vereinbarungen und bleiben so auch bei manuellem Löschen einer Vereinbarung bestehen
-- eigentlich wird zwar eine Vereinbarung nicht gelöscht, sondern auf inaktiv gesetzt, doch es kann dennoch der Fall sein (e.g. Bereinigung nach Migration)
DELETE FROM
    ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung
WHERE 
    auszahlungsjahr = ${AUSZAHLUNGSJAHR}::integer
    AND (
        -- wenn NULL oder nicht in vereinbarungen
        vereinbarung IS NULL
        OR vereinbarung NOT IN (SELECT t_id FROM ${DB_Schema_MJPNL}.mjpnl_vereinbarung)
    )