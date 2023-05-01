INSERT INTO
    avt_oevkov_${currentYear}_v1.auswertung_gesamtauswertung
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
            sum(auswertung.anzahl_abfahrten_linie) AS anzahl_abfahrten_linie,
            korrektur.abfahrten_korrigiert,
            bemerkungen
         FROM
             avt_oevkov_${currentYear}_v1.auswertung_auswertung_gtfs AS auswertung
             LEFT JOIN avt_oevkov_${currentYear}_v1.auswertung_abfahrten_korrigiert AS korrektur
                 ON (auswertung.haltestellenname = korrektur.haltestellenname
                       AND
                          auswertung.linie = korrektur.linie)
                      OR
                          (auswertung.linie = korrektur.linie
                           AND
                               korrektur.haltestellenname = '--- Alle')
                          
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
        ),
        avt_verkehrsmittel AS (
        SELECT
            verkehrsmittel,
            verkehrsmittel_text
        FROM
            avt_oevkov_${currentYear}_v1.sachdaten_verkehrsmittel
        )
        SELECT
            anrechnung.gemeindename,
            gtfs_abfahrten.haltestellenname,
            CASE
                WHEN
                     korrektur.unternehmer <> gtfs_abfahrten.unternehmer
                     THEN
                         korrektur.unternehmer
                ELSE
                    gtfs_abfahrten.unternehmer
            END AS unternehmer,
            gtfs_abfahrten.linie,
            gtfs_abfahrten.verkehrsmittel,
            gtfs_abfahrten.gewichtung,
            gtfs_abfahrten.gewichtung_korrigiert,
            anrechnung.anrechnung,
            anzahl_abfahrten_linie AS abfahrten_gtfs,
            CASE
                 WHEN
                    ((gtfs_abfahrten.abfahrten_korrigiert = 0
                     OR
                         gtfs_abfahrten.abfahrten_korrigiert IS NULL)
                     AND
                         gewichtung_korrigiert <> 0
                     AND
                         gewichtung_korrigiert IS NOT NULL)
                    THEN
                        NULL
                 WHEN
                    ((gtfs_abfahrten.abfahrten_korrigiert = 0
                     OR
                         gtfs_abfahrten.abfahrten_korrigiert IS NULL)
                     AND
                         gewichtung_korrigiert = 0)
                    THEN
                      0  - anzahl_abfahrten_linie
                ELSE
                    gtfs_abfahrten.abfahrten_korrigiert
            END AS abfahrten_gtfs_korrigiert,
            CASE
                WHEN
                    ((gtfs_abfahrten.abfahrten_korrigiert = 0
                     OR
                         gtfs_abfahrten.abfahrten_korrigiert IS NULL)
                     AND
                         gewichtung_korrigiert <> 0
                     AND
                         gewichtung_korrigiert IS NOT NULL
                         )
                    THEN
                        anzahl_abfahrten_linie
                WHEN
                    gewichtung_korrigiert = 0
                    THEN
                        0
                WHEN
                   gtfs_abfahrten.abfahrten_korrigiert  <> 0
                   AND
                       gtfs_abfahrten.abfahrten_korrigiert  IS NOT NULL 
                       THEN
                            (anzahl_abfahrten_linie  +  gtfs_abfahrten.abfahrten_korrigiert)
               ELSE
                   anzahl_abfahrten_linie
            END AS abfahrten_ungewichtet,
            CASE
                WHEN
                    gtfs_abfahrten.abfahrten_korrigiert IS NOT NULL 
                     AND
                         gtfs_abfahrten.abfahrten_korrigiert <> 0
                     AND
                         gewichtung_korrigiert > 0
                    THEN
                       ((anzahl_abfahrten_linie  +  gtfs_abfahrten.abfahrten_korrigiert)
                              *  gewichtung_korrigiert  *  anrechnung  /  100)::numeric(5,1)
                WHEN
                    gtfs_abfahrten.abfahrten_korrigiert IS NOT NULL
                    AND
                        gtfs_abfahrten.abfahrten_korrigiert <> 0
                    AND
                    gewichtung_korrigiert IS NULL
                   THEN
                    ((anzahl_abfahrten_linie  +  gtfs_abfahrten.abfahrten_korrigiert)
                         *  gtfs_abfahrten.gewichtung  *  anrechnung  /  100)::numeric(5,1)
                WHEN
                    (gewichtung_korrigiert > 0
                     AND (gtfs_abfahrten.abfahrten_korrigiert = 0
                         OR gtfs_abfahrten.abfahrten_korrigiert IS NULL))
                    THEN
                        (anzahl_abfahrten_linie  *  gewichtung_korrigiert  *  anrechnung  /  100)::numeric(5,1)
                 WHEN
                    gewichtung_korrigiert = 0
                    THEN
                        0
                ELSE
                    (anzahl_abfahrten_linie  *  gtfs_abfahrten.gewichtung  *  anrechnung  /  100)::numeric(5,1)
            END AS abfahrten_gewichtet,
            CASE
                WHEN
                     (korrektur.unternehmer <> gtfs_abfahrten.unternehmer
                     AND
                         korrektur.verkehrsmittel <> gtfs_abfahrten.verkehrsmittel)
                   THEN
                       CASE
                           WHEN
                               gtfs_abfahrten.bemerkungen IS NULL
                               THEN
                                   E'Unternehmer geändert: GTFS: '||gtfs_abfahrten.unternehmer||
                                   E'\nVerkehrsmittel geändert: GTFS: '|| avt_verkehrsmittel.verkehrsmittel_text
                          WHEN
                             gtfs_abfahrten.bemerkungen IS NOT NULL
                             THEN
                                 gtfs_abfahrten.bemerkungen||
                                 E'Unternehmer geändert: GTFS: '||gtfs_abfahrten.unternehmer||
                                 E'\nVerkehrsmittel geändert: GTFS: '|| avt_verkehrsmittel.verkehrsmittel_text
                       END
               WHEN
                     korrektur.unternehmer <> gtfs_abfahrten.unternehmer
                   THEN
                       CASE
                           WHEN
                               gtfs_abfahrten.bemerkungen IS NULL
                               THEN
                                   'Unternehmer geändert: GTFS = '||gtfs_abfahrten.unternehmer
                          WHEN
                             gtfs_abfahrten.bemerkungen IS NOT NULL
                             THEN
                                 gtfs_abfahrten.bemerkungen||
                                 E'\nUnternehmer geändert: GTFS = '||gtfs_abfahrten.unternehmer
                       END                        
               WHEN
                     korrektur.verkehrsmittel <> gtfs_abfahrten.verkehrsmittel
                   THEN
                       CASE
                           WHEN
                               gtfs_abfahrten.bemerkungen IS NULL
                               THEN
                                   'Verkehrsmittel geändert: GTFS: '|| avt_verkehrsmittel.verkehrsmittel_text
                          WHEN
                             gtfs_abfahrten.bemerkungen IS NOT NULL
                             THEN
                                 gtfs_abfahrten.bemerkungen||
                                 E'\nVerkehrsmittel geändert: GTFS: '|| avt_verkehrsmittel.verkehrsmittel_text
                       END
                ELSE
                    gtfs_abfahrten.bemerkungen
            END AS bemerkungen    
        FROM
            avt_oevkov_${currentYear}_v1.sachdaten_haltestelle_anrechnung AS anrechnung
            LEFT JOIN gtfs_abfahrten
                ON anrechnung.haltestellenname = gtfs_abfahrten.haltestellenname
            LEFT JOIN avt_verkehrsmittel
                ON avt_verkehrsmittel.verkehrsmittel = gtfs_abfahrten.verkehrsmittel
           LEFT JOIN avt_oevkov_${currentYear}_v1.auswertung_abfahrten_korrigiert AS korrektur
                 ON ((anrechnung.haltestellenname = korrektur.haltestellenname
                       AND
                          gtfs_abfahrten.linie = korrektur.linie)
                       OR
                          (gtfs_abfahrten.linie = korrektur.linie
                           AND
                               korrektur.haltestellenname = '--- Alle'))
                       AND 
                           (anrechnung.haltestellenname = korrektur.haltestellenname
                            OR korrektur.haltestellenname = '--- Alle')
        WHERE
            anrechnung.haltestellenname IN (
                SELECT
                    haltestellenname
                FROM
                    avt_oevkov_${currentYear}_v1.auswertung_auswertung_gtfs
              )
        )
;
