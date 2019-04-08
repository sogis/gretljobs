TRUNCATE TABLE avt_oevkov_${currentYear}.auswertung_gesamtauswertung
;

INSERT INTO
    avt_oevkov_${currentYear}.auswertung_gesamtauswertung
        (
         gemeindename,
         haltestellenname,
         unternehmer,
         linie,
         verkehrsmittel,
         gewichtung,
         gewichtung_korrigiert,
         anrechnung,
         abfahrten_gtfs,
         abfahrten_gtfs_korrigiert,
         abfahrten_ungewichtet,
         abfahrten_gewichtet,
         bemerkungen
        )
        (
        WITH gtfs_abfahrten AS (
        SELECT
            auswertung.haltestellenname,
            auswertung.unternehmer,
            auswertung.linie,
            auswertung.verkehrsmittel,
            auswertung.gewichtung,
            CASE
                WHEN  korrektur.linie = auswertung.linie
                     AND
                         korrektur.haltestellenname = '--- Alle'
                    THEN
                         korrektur.gewichtung
                ELSE
                    NULL
            END AS gewichtung_korrigiert,
            auswertung.anzahl_abfahrten_linie,
            korrektur.abfahrten_korrigiert,
            bemerkungen
         FROM
             avt_oevkov_${currentYear}.auswertung_auswertung_gtfs AS auswertung
             LEFT JOIN avt_oevkov_${currentYear}.auswertung_abfahrten_korrigiert AS korrektur
                 ON (auswertung.haltestellenname = korrektur.haltestellenname
                       AND
                          auswertung.linie = korrektur.linie)
                      OR (auswertung.linie = korrektur.linie AND korrektur.haltestellenname = '--- Alle')
                          
        GROUP BY
            auswertung.haltestellenname,
            korrektur.haltestellenname,
            auswertung.unternehmer,
            auswertung.linie,
            korrektur.linie,
            auswertung.verkehrsmittel,
            auswertung.gewichtung,
            korrektur.gewichtung,
            auswertung.anzahl_abfahrten_linie,
            korrektur.abfahrten_korrigiert,
            bemerkungen
        ORDER BY
             haltestellenname
        )
        SELECT
            anrechnung.gemeindename,
            gtfs_abfahrten.haltestellenname,
            unternehmer,
            linie,
            verkehrsmittel,
            gewichtung,
            gewichtung_korrigiert,
            anrechnung.anrechnung,
            anzahl_abfahrten_linie AS abfahrten_gtfs,
            CASE                                                                                        -- sollen hier nur die einfach korrgierten Werte stehen?
                WHEN
	                (abfahrten_korrigiert = 0 OR abfahrten_korrigiert IS NULL)
                    THEN NULL
                WHEN gewichtung_korrigiert >= 0
                    THEN anzahl_abfahrten_linie  *  gewichtung_korrigiert
                ELSE
	                abfahrten_korrigiert
            END AS abfahrten_gtfs_korrigiert,
            CASE
                WHEN
	                (abfahrten_korrigiert = 0 OR abfahrten_korrigiert IS NULL)
                    THEN anzahl_abfahrten_linie
               ELSE
	               (anzahl_abfahrten_linie  +  abfahrten_korrigiert)
            END AS abfahrten_ungewichtet,
            CASE
                WHEN
                    (abfahrten_korrigiert IS NOT NULL  AND abfahrten_korrigiert <> 0 AND gewichtung_korrigiert > 0)
	            THEN
                   ((anzahl_abfahrten_linie  +  abfahrten_korrigiert)  *  gewichtung_korrigiert  *  anrechnung  /  100)::numeric(5,1)
                WHEN
                (abfahrten_korrigiert IS NOT NULL AND abfahrten_korrigiert <> 0 AND (gewichtung_korrigiert = 0 OR gewichtung_korrigiert IS NULL))
	            THEN
                    ((anzahl_abfahrten_linie  +  abfahrten_korrigiert)   *  gewichtung  *  anrechnung  /  100)::numeric(5,1)
                WHEN
                    (gewichtung_korrigiert > 0 AND (abfahrten_korrigiert = 0 OR abfahrten_korrigiert IS NULL))
                THEN
                    (anzahl_abfahrten_linie  *  gewichtung_korrigiert  *  anrechnung  /  100)::numeric(5,1)
                ELSE
                    (anzahl_abfahrten_linie  *  gewichtung  *  anrechnung  /  100)::numeric(5,1)
            END AS abfahrten_gewichtet,
            bemerkungen
        FROM
            avt_oevkov_${currentYear}.sachdaten_haltestelle_anrechnung AS anrechnung
            LEFT JOIN gtfs_abfahrten
                ON anrechnung.haltestellenname = gtfs_abfahrten.haltestellenname
        WHERE
            anrechnung.haltestellenname IN (
                SELECT
                    haltestellenname
                FROM
                    avt_oevkov_${currentYear}.auswertung_auswertung_gtfs
              )   
        ORDER BY
            anrechnung.haltestellenname,
            linie,
            anrechnung DESC,
            anrechnung.gemeindename
        )
;

-- Haltestellen einfügen, welche in der Auswertung fehlen, aber korrigert werden müssen
INSERT INTO
    avt_oevkov_${currentYear}.auswertung_gesamtauswertung
        (
         gemeindename,
         haltestellenname,
         unternehmer,
         linie,
         verkehrsmittel,
         gewichtung,
         anrechnung,
         abfahrten_ungewichtet,
         abfahrten_gewichtet
        )
        (
        SELECT
            gemeindename,
            korrektur.haltestellenname,
            unternehmer,
            linie,
            verkehrsmittel,
            gewichtung,
            anrechnung,
            abfahrten_korrigiert AS abfahrten_ungewichtet,
            (abfahrten_korrigiert *  gewichtung  *  anrechnung  /  100)::numeric(5,1) AS abfahrten_gewichtet
        FROM
            avt_oevkov_${currentYear}.auswertung_abfahrten_korrigiert AS korrektur
            LEFT JOIN avt_oevkov_${currentYear}.sachdaten_haltestelle_anrechnung AS anrechnung
            ON
                korrektur.haltestellenname = anrechnung.haltestellenname
        WHERE korrektur.haltestellenname||korrektur.linie NOT IN (
            SELECT
                haltestellenname||linie
            FROM
                avt_oevkov_${currentYear}.auswertung_auswertung_gtfs
        )
        AND
            korrektur.haltestellenname <> '--- Alle'
        )

;
-- 
-- -- Korrektur für ganze Linien (z.Bsp. gewichtung = 0 setzen, da Linie durch Gemeinde finanziert)
-- UPDATE
--      avt_oevkov_${currentYear}.auswertung_gesamtauswertung AS auswertung
--  SET
--     verkehrsmittel = korrektur.verkehrsmittel,
--     gewichtung = korrektur.gewichtung,
--     abfahrten_gewichtet = (abfahrten_ungewichtet  *  korrektur.gewichtung)
--  FROM
--      avt_oevkov_${currentYear}.auswertung_abfahrten_korrigiert AS korrektur
-- WHERE
--     auswertung.linie = korrektur.linie
-- AND
--     korrektur.haltestellenname = '--- Alle'
-- ; 