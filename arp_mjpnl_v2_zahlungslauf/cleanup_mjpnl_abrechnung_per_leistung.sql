-- wir löschen alle diesjährigen Leitungen (ausser die einmaligen oder migrierten)
DELETE FROM
    ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung
WHERE 
    auszahlungsjahr = ${AUSZAHLUNGSJAHR}::integer
    AND (einmalig = FALSE OR einmalig IS NULL)  -- denn diese wurden manuell erfasst (also wir nehmen false und null)
    AND (migriert = FALSE OR migriert IS NULL); -- sind gültig und nicht kalkuliert (Berücksichtigung Migrationsjahr)
    
-- und alle andern (die einmaligen) möchten wir vom CASCADE delete bewahren, also FK auf NULL setzen
UPDATE
    ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung 
SET abrechnungpervereinbarung = NULL
WHERE 
    auszahlungsjahr = ${AUSZAHLUNGSJAHR}::integer;