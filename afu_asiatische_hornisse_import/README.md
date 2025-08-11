# Import von Sichtungsmeldungen der Asiatischen Hornisse

Dieser Job importiert Sichtungsmeldungen der Asiatischen Hornisse, bestehend aus Individuen und Nestern, vom Web Feature Service (WFS) [geoserver.infofauna.ch/geoserver/neovelutina/ows](https://geoserver.infofauna.ch/geoserver/neovelutina/ows), der von infofauna bereitgestellt wird.

Anhand der `materialentityid`, einer eindeutigen Record-ID von infofauna, werden vorhandene und heruntergeladene Records zusammengeführt. Dabei werden alle Felder überschrieben ausser seitens AfU in der Erfassungs-DB geführte Felder (`massnahmenstatus`, `bemerkung_massnahme`) und `t_ili_tid`. Die importierten Felder werden vom AfU und von Dritten über die Meldeplattform [www.asiatischehornisse.ch](https://www.asiatischehornisse.ch) geführt.

## Abhängigkeit: afu_asiatische_hornisse_pub

Die Ausführung dieses Import-Jobs erfolgt zeitgesteuert täglich zwischen 0:00 und 1:00 Uhr. Im Anschluss, zwischen 2:00 und 3:00 Uhr, erfolgt die Ausführung des Jobs [afu_asiatische_hornisse_pub](https://github.com/sogis/gretljobs/tree/main/afu_asiatische_hornisse_pub), der den aktuellen Stand der importierten und editierten Daten in die Publikations-DB überträgt.

# TODO

## Fehlende Attribute im Import

Aktuell (Juli 2025) liefert der WFS untenstehende Felder noch nicht, die vom Datenmodell vorgesehen sind. Sobald verfügbar, müssen die Felder in den Dateien `import_to_duckdb_infofauna_[individuals|nests].sql` und `upsert_duckdb_[individuals|nests].sql` eingepflegt werden.

Aktuell nicht importierbare Felder in der Tabelle asia_hornisse_sichtung / WFS Layer "individuals":

    import_bienenstand_nr
    import_vor_10_uhr
    import_zwischen_10_und_13_uhr
    import_zwischen_13_und_17_uhr
    import_nach_17_uhr
    import_kontakt_name
    import_kontakt_mail
    import_kontakt_tel
    import_url

Aktuell nicht importierbare Felder in der Tabelle asia_hornisse_nest / WFS Layer "active_nests" und "unactive_nests":

    import_datum_behandlung
    import_kontakt_name
    import_kontakt_mail
    import_kontakt_tel

## Automatischer Abschluss von Hornissen-Sichtungen

Ausserdem sollen Sichtungsmeldungen von Individuen auf Basis ihrer Distanz zu behandelten Nestern und des Behandlungsdatums (`import_datum_behandlung`) automatisch abgeschlossen werden. Diese Logik ist zu entwickeln, sobald das vorgenannte Feld verfügbar ist.

Auftrag: https://sogis.openproject.com/projects/task/work_packages/2671
