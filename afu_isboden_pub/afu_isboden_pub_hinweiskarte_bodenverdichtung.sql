SELECT
    ogc_fid AS t_id,
    risk_final,
    CASE
        WHEN risk_final = 1
            THEN 'geringes Verdichtungsrisiko; befahren mit üblicher Sorgfalt, weiter Rückegassenabstand empfohlen'
        WHEN risk_final = 2
            THEN 'mittleres Verdichtungsrisiko; nach Abtrocknungsphase gut mechanisch belastbar, weiter Rückegassenabstand empfohlen'
        WHEN risk_final = 3
            THEN 'hohes Verdichtungsrisiko (wechselfeucht); erhöhte Sorgfalt beim Befahren notwendig, Trockenphasen optimal nutzen, sehr weiter Rückegassenabstand empfohlen'
        WHEN risk_final = 4
            THEN 'sehr hohes Verdichtungsrisiko; nur eingeschränkt mechanisch belastbar, längere Trockenphasen abwarten, ergänzend lastreduzierende und lastverteilende Massnahmen ergreifen, sehr weiter Rückegassenabstand empfohlen'
        WHEN risk_final = 5
            THEN 'nicht befahrbar: Standort zu nass für Befahrung'
        WHEN risk_final = 6
            THEN 'Befahrung nicht empfohlen wegen Topographie (zu steil)'
        WHEN risk_final = 7
            THEN 'seltener Waldstandort: Befahrung nicht abgebracht'
        WHEN risk_final = 8
            THEN 'Ruderalflächen / fehlende Angaben'
    END AS verdempf_t,
    wkb_geometry AS geometrie
FROM
    afu_isboden.hinweiskarte_bodenverdichtung_qgis_server_client_t
;