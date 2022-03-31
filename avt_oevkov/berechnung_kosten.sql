-- Tabelle avt_oevkov_avt_oevkov_${currentYear}_v1.sachdaten_oevkov_daten 

-- OeV Kosten Total
UPDATE
    avt_oevkov_avt_oevkov_${currentYear}_v1.sachdaten_oevkov_daten
SET
    total_oev_kosten = gesamtkosten_angebot + gesamtkosten_fabi_beitraege
;

-- Gemeindenanteil (37% der Totalkosten OeV)
UPDATE
    avt_oevkov_avt_oevkov_${currentYear}_v1.sachdaten_oevkov_daten
SET
    gemeindeanteil = (gesamtkosten_angebot + gesamtkosten_fabi_beitraege)   *  0.37
;

-- Einwohner Total
UPDATE
    avt_oevkov_avt_oevkov_${currentYear}_v1.sachdaten_oevkov_daten
SET
    total_einwohner = 
    (
    SELECT
        sum(einwohnerzahl)
     FROM
         avt_oevkov_avt_oevkov_${currentYear}_v1.auswertung_gemeinde_einwohner_kosten                                                                                                                           
     )
;

-- Gewichtete Haltestellenabfahrten Total
UPDATE
     avt_oevkov_avt_oevkov_${currentYear}_v1.sachdaten_oevkov_daten
SET
    total_gewichtete_haltestellenabfahrten =sum_abfahrten_gewichtet.total
FROM
    (
    SELECT
        sum(abfahrten_gewichtet) AS total
    FROM
        avt_oevkov_avt_oevkov_${currentYear}_v1.auswertung_gesamtauswertung
    ) AS sum_abfahrten_gewichtet
;

-- Kosten pro Haltestellenabfahrt (5/7)
UPDATE
    avt_oevkov_avt_oevkov_${currentYear}_v1.sachdaten_oevkov_daten
SET
    kosten_pro_haltestellenabfahrt = round(gemeindeanteil  /  total_gewichtete_haltestellenabfahrten  *  5  /  7, 1)
;

-- Kosten pro Einwohner (2/7)
UPDATE
    avt_oevkov_avt_oevkov_${currentYear}_v1.sachdaten_oevkov_daten
SET
    kosten_pro_einwohner = gemeindeanteil  /
       (
       SELECT
            sum(einwohnerzahl)
        FROM
            avt_oevkov_avt_oevkov_${currentYear}_v1.auswertung_gemeinde_einwohner_kosten
       )
;

-- Schwellenwert
UPDATE
    avt_oevkov_avt_oevkov_${currentYear}_v1.sachdaten_oevkov_daten
SET
    schwellenwert = gemeindeanteil  /
         (
         SELECT
             sum(einwohnerzahl)
         FROM
             avt_oevkov_avt_oevkov_${currentYear}_v1.auswertung_gemeinde_einwohner_kosten
         )  *  1.5
;

-- Tabelle avt_oevkov_avt_oevkov_${currentYear}_v1.auswertung_gemeinde_einwohner_kosten
-- Zuerst alle Werte 0 setzen für Neuberechnung
UPDATE
     avt_oevkov_avt_oevkov_${currentYear}_v1.auswertung_gemeinde_einwohner_kosten
SET
    gewichtete_haltestellenabfahrten = 0,
    kosten_angebot = 0,
    kosten_anzahl_einwohner = 0,
    kosten_pro_einwohner = 0,
    kosten_total = 0,
    kosten_minus_schwellenwert = 0,
    kosten_ueber_schwellenwert = 0
;

--  Gewichtete Haltestellenabfahrten schreiben
UPDATE
     avt_oevkov_avt_oevkov_${currentYear}_v1.auswertung_gemeinde_einwohner_kosten AS kosten
SET
    gewichtete_haltestellenabfahrten = gewichtete_abfahrten_gemeinde.abfahrten_gewichtet
FROM
    (
    SELECT
        gemeindename,
        sum(abfahrten_gewichtet) AS abfahrten_gewichtet
    FROM
         avt_oevkov_avt_oevkov_${currentYear}_v1.auswertung_gesamtauswertung AS auswertung
    GROUP BY
        gemeindename
    ) AS gewichtete_abfahrten_gemeinde
   WHERE
        kosten.gemeindename = gewichtete_abfahrten_gemeinde.gemeindename
;

-- Kosten gemäss Angebot
UPDATE
    avt_oevkov_avt_oevkov_${currentYear}_v1.auswertung_gemeinde_einwohner_kosten
SET
    kosten_angebot = (einwohnerzahl  *
        (
        SELECT
             gesamtkosten_angebot  /  7 * 2  /  total_einwohner  *  0.37
        FROM
            avt_oevkov_avt_oevkov_${currentYear}_v1.sachdaten_oevkov_daten
        )) 
        +  (gewichtete_haltestellenabfahrten *
               (
               SELECT
                   gesamtkosten_angebot  /  7 * 5  /  total_gewichtete_haltestellenabfahrten  *  0.37
               FROM
                   avt_oevkov_avt_oevkov_${currentYear}_v1.sachdaten_oevkov_daten
               )
           )
;

-- Kosten gemäss Anzahl Einwohner
UPDATE
    avt_oevkov_avt_oevkov_${currentYear}_v1.auswertung_gemeinde_einwohner_kosten
SET
    kosten_anzahl_einwohner = (einwohnerzahl  *
          (SELECT
               gesamtkosten_fabi_beitraege  /  7 *  2  /  total_einwohner  *  0.37
          FROM
            avt_oevkov_avt_oevkov_${currentYear}_v1.sachdaten_oevkov_daten)
        )  +   (gewichtete_haltestellenabfahrten  *
          (SELECT
             gesamtkosten_fabi_beitraege  / 7  *  5  /   total_gewichtete_haltestellenabfahrten  *  0.37
         FROM
            avt_oevkov_avt_oevkov_${currentYear}_v1.sachdaten_oevkov_daten)
        )
;

-- Total Kosten
UPDATE
    avt_oevkov_avt_oevkov_${currentYear}_v1.auswertung_gemeinde_einwohner_kosten
SET
    kosten_total = round(kosten_angebot, 0)  +  round(kosten_anzahl_einwohner, 0)
;

-- Kosten pro Einwohner
UPDATE
    avt_oevkov_avt_oevkov_${currentYear}_v1.auswertung_gemeinde_einwohner_kosten
SET
    kosten_pro_einwohner = kosten_total  /  einwohnerzahl
;

-- Kosten reduziert gemäss Schwellenwert
UPDATE
    avt_oevkov_avt_oevkov_${currentYear}_v1.auswertung_gemeinde_einwohner_kosten AS gemeindekosten
SET
    kosten_minus_schwellenwert = schwellenwert  *  einwohnerzahl
FROM
      avt_oevkov_avt_oevkov_${currentYear}_v1.sachdaten_oevkov_daten AS grunddaten
WHERE
    gemeindekosten.kosten_pro_einwohner > grunddaten.schwellenwert
;

-- Kosten über Schwellenwert
UPDATE
    avt_oevkov_avt_oevkov_${currentYear}_v1.auswertung_gemeinde_einwohner_kosten AS gemeindekosten
SET
    kosten_ueber_schwellenwert = kosten_total  -  kosten_minus_schwellenwert
FROM
      avt_oevkov_avt_oevkov_${currentYear}_v1.sachdaten_oevkov_daten AS grunddaten
WHERE
    gemeindekosten.kosten_pro_einwohner > grunddaten.schwellenwert
;
