-- Haltestellen einfügen, welche in der Auswertung fehlen, für die aber eine Korrektur eingetragen wurde
INSERT INTO
    avt_oevkov_${currentYear}_v1.auswertung_gesamtauswertung
        (
         gemeindename,
         haltestellenname,
         unternehmer,
         linie,
         verkehrsmittel,
         gewichtung,
         anrechnung,
         abfahrten_gtfs_korrigiert,
         abfahrten_ungewichtet,
         abfahrten_gewichtet,
         bemerkungen
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
            abfahrten_korrigiert AS abfahrten_gtfs_korrigiert,
            abfahrten_korrigiert AS abfahrten_ungewichtet,
            (abfahrten_korrigiert  *  gewichtung  *  anrechnung  /  100)::numeric(5,1) AS abfahrten_gewichtet,
            bemerkungen
        FROM
            avt_oevkov_${currentYear}_v1.auswertung_abfahrten_korrigiert AS korrektur
            LEFT JOIN avt_oevkov_${currentYear}_v1.sachdaten_haltestelle_anrechnung AS anrechnung
                ON korrektur.haltestellenname = anrechnung.haltestellenname
        WHERE
            korrektur.haltestellenname||korrektur.linie NOT IN (
            SELECT
                haltestellenname||linie
            FROM
                avt_oevkov_${currentYear}_v1.auswertung_auswertung_gtfs
        )
        AND
            korrektur.haltestellenname <> '--- Alle'
        )
;
