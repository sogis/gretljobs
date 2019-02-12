SELECT
auswertung_19.gemeindename, auswertung_19.haltestellenname, auswertung_19.linie, auswertung_18.abfahrten_ungewichtet, auswertung_19.abfahrten_ungewichtet, (auswertung_19.abfahrten_ungewichtet - auswertung_18.abfahrten_ungewichtet) AS differenz
FROM
    avt_oevkov_2019_190107.auswertung_gesamtauswertung AS auswertung_19
    LEFT JOIN
        avt_oevkov_2018.auswertung_gesamtauswertung AS auswertung_18
        ON
            auswertung_19.haltestellenname = auswertung_18.haltestellenname
        AND
             auswertung_19.linie = auswertung_18.linie
GROUP BY
     auswertung_19.gemeindename,
     auswertung_19.haltestellenname,
     auswertung_19.linie,
     auswertung_18.abfahrten_ungewichtet,
     auswertung_19.abfahrten_ungewichtet
ORDER BY
--     abs(auswertung_19.abfahrten_ungewichtet - auswertung_18.abfahrten_ungewichtet),
    auswertung_19.haltestellenname
;



-- SELECT
-- auswertung_19.gemeindename, (auswertung_18.gewichtete_haltestellenabfahrten - auswertung_19.gewichtete_haltestellenabfahrten) AS diff
-- FROM
--     avt_oevkov_2018.auswertung_gemeinde_einwohner_kosten AS auswertung_18,
--      avt_oevkov_2019_190107.auswertung_gemeinde_einwohner_kosten AS auswertung_19
-- WHERE
--     auswertung_18.gemeindename = auswertung_19.gemeindename
-- ORDER BY
--     diff,
--     auswertung_19.gemeindename
-- ;