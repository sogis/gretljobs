-- löscht migrierte diesjährige leistungen mit aktiver vereinbarungen mit besprochenen beurteilungen (Berücksichtigung Migrationsjahr)
DELETE 
FROM ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung l
WHERE 
    migriert 
    AND l.auszahlungsjahr = ${AUSZAHLUNGSJAHR}
    AND l.vereinbarung IN (
        WITH alle_beurteilungen AS (
            -- alle beurteilungen
            SELECT mit_bewirtschafter_besprochen, vereinbarung
            FROM ${DB_Schema_MJPNL}.mjpnl_beurteilung_alr_buntbrache
            UNION
            SELECT mit_bewirtschafter_besprochen, vereinbarung
            FROM ${DB_Schema_MJPNL}.mjpnl_beurteilung_alr_saum
            UNION
            SELECT mit_bewirtschafter_besprochen, vereinbarung
            FROM ${DB_Schema_MJPNL}.mjpnl_beurteilung_hecke
            UNION
            SELECT mit_bewirtschafter_besprochen, vereinbarung
            FROM ${DB_Schema_MJPNL}.mjpnl_beurteilung_hostet
            UNION
            SELECT mit_bewirtschafter_besprochen, vereinbarung
            FROM ${DB_Schema_MJPNL}.mjpnl_beurteilung_obl
            UNION
            SELECT mit_bewirtschafter_besprochen, vereinbarung
            FROM ${DB_Schema_MJPNL}.mjpnl_beurteilung_wbl_weide
            UNION
            SELECT mit_bewirtschafter_besprochen, vereinbarung
            FROM ${DB_Schema_MJPNL}.mjpnl_beurteilung_wbl_wiese
            UNION
            SELECT mit_bewirtschafter_besprochen, vereinbarung
            FROM ${DB_Schema_MJPNL}.mjpnl_beurteilung_weide_ln
            UNION
            SELECT mit_bewirtschafter_besprochen, vereinbarung
            FROM ${DB_Schema_MJPNL}.mjpnl_beurteilung_weide_soeg
            UNION
            SELECT mit_bewirtschafter_besprochen, vereinbarung
            FROM ${DB_Schema_MJPNL}.mjpnl_beurteilung_wiese
        )
        --alle aktiven vereinbarungen mit besprochener beurteilung
        SELECT vbg.t_id
        FROM ${DB_Schema_MJPNL}.mjpnl_vereinbarung vbg
        LEFT JOIN alle_beurteilungen be
            ON be.vereinbarung = vbg.t_id
        WHERE vbg.status_vereinbarung = 'aktiv' AND vbg.bewe_id_geprueft IS TRUE
            AND be.mit_bewirtschafter_besprochen IS TRUE
    )