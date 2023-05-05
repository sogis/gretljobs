-- Gewichtung schreiben
UPDATE
    avt_oevkov_${currentYear}_v1.auswertung_auswertung_gtfs AS auswertung
SET
    gewichtung = verkehrsmittel.gewichtung
FROM
    avt_oevkov_${currentYear}_v1.sachdaten_verkehrsmittel AS verkehrsmittel
WHERE
    auswertung.verkehrsmittel = verkehrsmittel.verkehrsmittel
;
