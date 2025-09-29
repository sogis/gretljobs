# Import von Sichtungsmeldungen der Asiatischen Hornisse

Dieser Job importiert Sichtungsmeldungen der Asiatischen Hornisse von einem Web Feature Service (WFS), der von infofauna bereitgestellt wird ([geoserver.infofauna.ch/geoserver/neovelutina/ows](https://geoserver.infofauna.ch/geoserver/neovelutina/ows)). Importiert werden Individuen (Layer `neovelutina:individuals`) und Nester (Layer `neovelutina:active_nests`, `neovelutina:unactive_nests`). Die importierten Datenfelder werden vom AfU und von Dritten über die Meldeplattform [www.asiatischehornisse.ch](https://www.asiatischehornisse.ch) geführt.

Nester werden nach dem "Kill & Fill"-Prinzip mit jedem Job-Durchlauf gelöscht und neu vom infofauna WFS geladen. Individuen werden vom AfU in der Erfassungs-DB editiert, daher werden über einen behelfsmässigen Primary Key (siehe [ToDo 1](#todo-1--infofauna-eindeutige-und-stabile-object-id)) bereits in der Erfassungs-DB vorhandene Records nach dem "Upsert"-Prinzip mit den heruntergeladenen Records zusammengeführt. Dabei werden alle Datenfelder überschrieben, mit Ausnahme der vom AfU in der Erfassungs-DB geführten Felder `massnahmenstatus` und `bemerkung_massnahme` sowie der INTERLIS Objekt-ID (`t_ili_tid`).

Auftrag: [2671](https://sogis.openproject.com/projects/task/work_packages/2671)

## Abhängigkeit: afu_asiatische_hornisse_pub

infofauna importiert die Sichtungsmeldungen täglich um 02:00 (UTC oder MESZ?) von der Meldeplattform. Die Ausführung unseres Import-Jobs erfolgt zeitgesteuert täglich um 04:15 UTC. Im Anschluss, um 04:30 UTC, erfolgt die Ausführung des Jobs [afu_asiatische_hornisse_pub](https://github.com/sogis/gretljobs/tree/main/afu_asiatische_hornisse_pub), der den aktuellen Stand der importierten und editierten Daten in die Publikations-DB überträgt.

# Bekannte Probleme und offene ToDo's

## ToDo 1 @ infofauna: Eindeutige und stabile Object ID

#### Problem

Der Importmechanismus nach dem "Upsert"-Prinzip bedingt eine eindeutige und stabile Object-ID, damit Änderungen durch das AfU in der Erfassungs-DB nicht überschrieben werden. Gemäss einer früheren Auskunft von infofauna (Nils Arrigo, 07.05.2025) ist die `materialentityid` eine eindeutige und stabile ID, daher wurde der Import-Job zunächst darauf aufgebaut. Nach Inbetriebnahme des Jobs stellte sich heraus, dass sich die vermeintliche ID ändert, wenn auf der Meldeplattform der Status eines Nests von "actif" ("bestehend") auf "detruit" ("behandelt") umgestellt wird. Dieses unerwartete Verhalten führte auf unserer Seite zu duplizierten Nestern. Auf Nachfrage erfuhren wir von infofauna (Jules Gottraux, 24.09.2025), dass es sich bei `materialentityid` tatsächlich um einen Hashwert handelt, nicht um eine ID.

#### Workaround seitens Kanton Solothurn

Kurzfristig wurde das Problem am 26.08.2025 rein visuell entschärft durch eine angepasste Symbolreihenfolge bei Nestern ("behandelt" über "bestehend"). Datenseitig wurden am 29.09.2025 folgende Änderungen vorgenommen:

- Nester: Umstellung vom "Upsert"-Prinzip auf "Kill & Fill", das heisst, mit jedem Import werden alle Nester gelöscht und neu vom infofauna WFS abgefragt.
- Individuen: Verwendung eines kombinierten Primary Keys aus `occurence_id` \[sic!\], `lv95_east_x` und `lv95_north_y` anstelle der `materialentityid`.

#### Erwartete Lösung

Eindeutige und stabile Object-ID für alle Objekte (Nester und Individuen).

## ToDo 2 @ infofauna: Fehlende Attribute in den WFS aufnehmen

#### Problem

Aktuell (Juli 2025) liefert der WFS untenstehende Felder noch nicht, die vom Datenmodell vorgesehen sind. Sobald verfügbar, müssen die Felder in den Dateien `import_to_duckdb_infofauna_[individuals|nests].sql` und `upsert_duckdb_individuals.sql` eingepflegt werden.

Aktuell nicht importierbare Felder in der Tabelle `asia_hornisse_sichtung`:

    import_bienenstand_nr
    import_vor_10_uhr
    import_zwischen_10_und_13_uhr
    import_zwischen_13_und_17_uhr
    import_nach_17_uhr
    import_kontakt_name
    import_kontakt_mail
    import_kontakt_tel
    import_url

Aktuell nicht importierbare Felder in der Tabelle `asia_hornisse_nest`:

    import_datum_behandlung
    import_kontakt_name
    import_kontakt_mail
    import_kontakt_tel

#### Erwartete Lösung

Alle Informationen, welche für Nutzende der Meldeplattform zugänglich sind und per E-Mail an die Kantone versendet werden, müssen via WFS verfügbar sein.

## ToDo 3 @ infofauna: Das Nest-Sichtungsdatum ändert sich bei Zerstörung

#### Problem

Das Feld `date_decouverte` wird beim Statuswechsel von "actif" auf "detruit" mit `date_destroyed` überschrieben.

#### Erwartete Lösung

`date_decouverte` und `date_destroyed` sind unterschiedliche Informationen und sollen unabhängig voneinander geführt werden.

## ToDo 4 @ infofauna: Das Nest-Behandlungsdatum ist inkonsistent formatiert

#### Problem

Das seit 27.09.2025 im WFS verfügbare Feld `date_destroyed` ist ein Freitextfeld und teilweise nicht in ein Datum konvertierbar aufgrund inkonsistenter Formatierung. Mögliche Ausprägungen sind beispielsweise "2024-8-9", "2024", "20", "date_destroyed", "date_des", "da" und weitere anscheinend inkorrekt geparste Variationen von Datum und "date_destroyed".

#### Erwartung

`date_destroyed` ist ein Feld vom Typ `xsd:date` analog `date_decouverte` und dementsprechend als Datum formatiert.

## ToDo @ Kt. SO: Die ID der Meldeplattform implementieren

Sobald der infofauna WFS die ID übermittelt, welche von der Meldeplattform angezeigt und per E-Mail verschickt wird (`submission_id`) (siehe [ToDo 2](#todo-2--infofauna-fehlende-attribute-in-den-wfs-aufnehmen)), muss diese in das Datenmodell und die GRETL-Jobs aufgenommen werden.

## ToDo @ Kt. SO: Automatischer Abschluss von Hornissen-Sichtungen

Ausserdem sollen gemäss [Auftrag 2671](https://sogis.openproject.com/projects/task/work_packages/2671) Sichtungsmeldungen von Individuen auf Basis ihrer Distanz zu behandelten Nestern und des Behandlungsdatums (`import_datum_behandlung`) automatisch abgeschlossen werden. Diese Logik ist zu entwickeln, sobald das vorgenannte Feld verfügbar ist, siehe [ToDo 3](#todo-3--infofauna-das-nest-sichtungsdatum-ändert-sich-bei-zerstörung).
