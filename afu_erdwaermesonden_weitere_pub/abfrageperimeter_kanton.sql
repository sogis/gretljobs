SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    dn,
    colorid,
    CASE
        WHEN colorid = 0 
            THEN 'Die Prüfung der Anfrage hat für den Standort $mapX$ / $mapY$ folgendes ergeben (siehe Objektblatt): '
        ELSE 'Eine Online-Abfrage ist an diesem Standort nicht möglich. Bitte setzen Sie sich mit dem zuständigen Sachbearbeiter im Amt für Umwelt in Verbindung, Kontakt siehe <a href="https://www.afu.so.ch/geothermie" target="_blank">https://www.afu.so.ch/geothermie</a>' 
    END AS html_text,
    CASE
        WHEN colorid = 0 
            THEN 'Online-Abfrage möglich'
        ELSE 'Keine Online-Abfrage möglich' 
    END AS abfrage
FROM
    auszug_akt_altlasten17785.abfrageperimeter_kanton
;