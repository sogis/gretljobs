# Import von Sichtungsmeldungen der Asiatischen Hornisse

Dieser Job importiert Sichtungsmeldungen der Asiatischen Hornisse von einem Web Feature Service (WFS), der von infofauna bereitgestellt wird ([geoserver.infofauna.ch/geoserver/neovelutina/ows](https://geoserver.infofauna.ch/geoserver/neovelutina/ows)). Importiert werden Individuen (Layer `neovelutina:individuals`) und Nester (Layer `neovelutina:active_nests`, `neovelutina:unactive_nests`). Die importierten Datenfelder werden vom AfU und von Dritten über die Meldeplattform [www.asiatischehornisse.ch](https://www.asiatischehornisse.ch) geführt.

Anhand der `materialentityid`, einer eindeutigen und stabilen Record-ID von infofauna, werden bereits in der Erfassungs-DB vorhandene und neu heruntergeladene Records zusammengeführt ("Upsert"). Dabei werden alle Datenfelder überschrieben, mit Ausnahme von `massnahmenstatus` und `bemerkung_massnahme` bei den Individuen (vom AfU in der Erfassungs-DB geführt) sowie `t_ili_tid` (Objekt-ID).

Auftrag: https://sogis.openproject.com/projects/task/work_packages/2671

## Abhängigkeit: afu_asiatische_hornisse_pub

infofauna importiert die Sichtungsmeldungen täglich um 02:00 (UTC oder MESZ?) von der Meldeplattform. Die Ausführung unseres Import-Jobs erfolgt zeitgesteuert täglich um 04:15 UTC. Im Anschluss, um 04:30 UTC, erfolgt die Ausführung des Jobs [afu_asiatische_hornisse_pub](https://github.com/sogis/gretljobs/tree/main/afu_asiatische_hornisse_pub), der den aktuellen Stand der importierten und editierten Daten in die Publikations-DB überträgt.

# Bekannte Fehler und offene ToDo's

## Fehler 1: Nest-Dubletten, weil die materialEntityId nicht stabil ist

Die `materialentityid` ändert sich, wenn auf der Meldeplattform der Status eines Nests von "actif" ("bestehend") auf "detruit" ("behandelt") umgestellt wird und das Nest somit seitens WFS von `neovelutina:active_nests` nach `neovelutina:unactive_nests` verschoben. Dieses unerwartete Verhalten führt auf unserer Seite zu duplizierten Nestern. Kurzfristig wurde das Problem rein optisch entschärft durch eine angepasste Symbolreihenfolge ("behandelt" über "bestehend"). Datenseitig wäre ein "Kill and Fill"-Import möglich anstelle eines Upserts, falls infofauna keine stabile ID bereitstellt.

## Fehler 2: Das Nest-Sichtungsdatum ändert sich bei der Zerstörung

Das WFS Feld `date_decouverte` wird beim Statuswechsel von "actif" auf "detruit" scheinbar mit dem (noch nicht, bzw. nur via `remarques` verfügbaren) `destroy_date` überschrieben.

## Fehler 3 (einmaliger Vorfall, gelöst per 24.09.2025): Nest-Status wechselt von "detruit" zurück auf "actif"

Mutmasslich mit dem Import vom 20. September 06:15 MESZ haben einige Nester unerwartet vom Status "detruit" auf "actif" gewechselt. Gleichzeitig werden seither zusätzliche Informationen im Kommentarfeld (`remarques`) mitgeliefert, weshalb der Verdacht besteht, dass der Statuswechsel ein ungewollter Nebeneffekt einer Änderung ist.  
Auch dieser Statuswechsel führte zu einer Veränderung der `materialentityid` und somit zu Dubletten, siehe Fehler 1.

Beispiel:

Für `nid_id` (Nest-ID) 6926 in Etziken existieren zwei Versionen in den importierten Nestern:

| WFS Feld | Wert |
|----------|------|
| `materialentityid` | _1649accd5d0f9f0ee2086d5147d6b75e_ |
| `statut`           |  _detruit_                         |
| `remarques`        | _Beobachter - [...] \| Fussballgross 5 meter höhe._ |

Dieser Record ist derzeit (23.09.2025) nicht mehr via WFS verfügbar.

| WFS Feld | Wert |
|----------|------|
| `materialentityid` | _23464835e91ea639e83c8562676b62fd_ |
| `statut`           | _actif_                            |
| `remarques`        | _Beobachter - [...] \| Fussballgross 5 meter höhe\'\|submission_id=13938\|date_destroyed=2025-8-12._ |

Dieser Record wird derzeit (23.09.2025) über WFS bereitgestellt.

## ToDo 1: Fehlende Attribute in den infofauna WFS aufnehmen

Aktuell (Juli 2025) liefert der WFS untenstehende Felder noch nicht, die vom Datenmodell vorgesehen sind. Sobald verfügbar, müssen die Felder in den Dateien `import_to_duckdb_infofauna_[individuals|nests].sql` und `upsert_duckdb_[individuals|nests].sql` eingepflegt werden.

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

## ToDo 2: Die ID der Meldeplattform in infofauna WFS und Datenmodell aufnehmen

Keine der vom WFS bereitgestellten IDs ist mit der ID identisch, die von der Meldeplattform angezeigt und per E-Mail verschickt wird (`submission_id` ?). Aber gerade diese ist relevant und muss in den WFS, das Datenmodell und die GRETL-Jobs aufgenommen werden.

## ToDo 3: Automatischer Abschluss von Hornissen-Sichtungen

Ausserdem sollen gemäss Auftrag 2671 Sichtungsmeldungen von Individuen auf Basis ihrer Distanz zu behandelten Nestern und des Behandlungsdatums (`import_datum_behandlung`) automatisch abgeschlossen werden. Diese Logik ist zu entwickeln, sobald das vorgenannte Feld verfügbar ist, siehe ToDo 1.
