-- wir löschen alle diesjährigen Leitungen (ausser die einmaligen oder migrierten)
DELETE FROM
    ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung
WHERE 
    auszahlungsjahr = ${AUSZAHLUNGSJAHR}::integer
    AND (einmalig = FALSE OR einmalig IS NULL)  -- denn diese wurden manuell erfasst (also wir nehmen false und null)
    AND (migriert = FALSE OR migriert IS NULL); -- sind gültig und nicht kalkuliert (Berücksichtigung Migrationsjahr)
    AND (
        -- prüft, ob es bereits ausbezahlte nicht-einmalige und nicht-migrierte Leistungen gibt - wenn ja, dann wurde die Auszahlung bereits gemacht und es soll nicht erneut kalkulieren
        SELECT COUNT(*) 
        FROM ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung 
        WHERE auszahlungsjahr = ${AUSZAHLUNGSJAHR}::integer 
        AND status_abrechnung = 'ausbezahlt' 
        AND (einmalig = FALSE OR einmalig IS NULL)
        AND (migriert = FALSE OR migriert IS NULL)
        ) < 5; --Tolleranz, falls fälschlicherweise nicht-einmalige ausbezahlt wurden