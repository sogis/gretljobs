# Rollout der Metadaten aus der Integration

Kopiert die Metadaten von der Integration in die Zielumgebung.
Ausser der drei Tabellen simitheme_sub_area, simitheme_published_sub_area
und simitheme_published_sub_area_helper werden alle Daten 1:1 kopiert.

## Erhalt des produktiven Publikationsdatums

Master für die drei Tabellen ist nicht die Integration, sondern die Zielumgebung. Ablauf der Verknüpfung Integration -> Zielumgebung

Auf Zielumgebung:
* Delete * from simitheme_published_sub_area_helper
* Kopieren der Attribute und Identifier von simitheme_published_sub_area und den verknüpften Tabellen nach simitheme_published_sub_area_helper 
* Delete * from simitheme_published_sub_area
* Aktualisierung aller anderen Tabellen aus Integration
* Ermittlung der technischen ID's von Themenbereitstellung und SubArea aufgrund der Indentifier. "Rückinsert" des Inhalts von simitheme_published_sub_area_helper nach simitheme_published_sub_area.

## Gebrochene Referenzen

Im Kontext des Publikationsdatums können gebrochene Referenzen aus zwei Gründen entstehen:
* Das Umbenennen des Identifiers einer Themenbereitstellung wurde nicht via Admin-Ticket bekanntgemacht.
* Auf der Integration wird eine Gebietseinteilung referenziert, welche auf der Prod nicht existiert.

### Themenbereitstellungs-Identifier auf Prod, welche auf Integration nicht vorkommen

Beispielsweise aufgrund Umbenennung eines Themen-Identifiers ohne Admin-Ticket. Der Job bricht bei Task __"failOnMissingThemepubs"__ ab. 

    ...
    Execution failed for task ':failOnMissingThemepubs'.
    ...

#### Korrektur während Rollout

Aus der Ausgabe des Tasks "logMissingThemepubs" notieren, welche Themenbereitstellung nur auf der Produktion vorkommen. Im Beispiel unten kommt "ch.so.awjf.jagdreviere" nur auf der Produktion vor:

    ...
    > Task :logMissingThemepubs
    Bei Themenbereitstellungs-Inkonsistenzen werden folgend die produktiven Bereitstellungen ausgegeben, welche auf der Integration nicht vorhanden sind.
    logMissingThemepubs: Start SqlExecutor
    logMissingThemepubs: Given parameters DB-URL: jdbc:postgresql://databases:5432/simi, DB-User: postgres, Files: [/home/gradle/project/agi_layer_rollout/assert_consistent/missing_themepubs.sql]
    logMissingThemepubs: ch.so.awjf.jagdreviere
    logMissingThemepubs: End SqlExecutor (successful)
    ...

Modifikation auf Produktion:

* Falls Bezug auf Themenbereitstellung auf der Integration klar ist: Auf Produktion via Simi die Themenbereitstellung umbenennen, damit diese wieder mit der Integration übereinstimmt (Über Maske "Themen-Verwaltung -> Themen" respektive "Themen-Verwaltung -> Themen-Bereitstellungen").
* Falls Bezug nicht klar ist: Auf der Produktion die Themenbereitstellung durch Löschen der Gebiet-Verknüpfungen des Themas depublizieren (Über Maske "Themen-Verwaltung -> Gebiet-Verknüpfungen").

Rollout-Job erneut ausführen.

Ggf. Aufräumarbeiten nach Rollout veranlassen.

### Fehlende Gebietseinteilung

Der Job bricht bei Task __"failOnMissingSubareas"__ ab.

    ...
    Execution failed for task ':failOnMissingSubareas'.
    ...

#### Korrektur während Rollout

Notieren, welche Gebietseinteilungen auf der Prod fehlen. Dies wird von Task __"logMissingSubareas"__ im Log vor Task "failOnMissingSubareas" ausgegeben. Im Beispiel-Log unten fehlt die Gebietseinteilungsfläche "kanton:so":

    ...
    > Task :logMissingSubareas
    Bei Subarea-Inkonsistenzen werden folgend die auf der Produktion fehlenden Subareas ausgegeben.
    logMissingSubareas: Start SqlExecutor
    logMissingSubareas: Given parameters DB-URL: jdbc:postgresql://databases:5432/simi, DB-User: postgres, Files: [/home/gradle/project/agi_layer_rollout/assert_consistent/missing_subareas.sql]
    logMissingSubareas: kanton:so
    logMissingSubareas: End SqlExecutor (successful)
    ...

Mittels GRETL-Job "agi_simi_regions" die Gebietseinteilungen auf SIMI-Produktion aktualisieren (via gretl.so.ch).

Rollout-Job erneut ausführen.

## Bei Anpassung des Schemas der betroffenen Simi-Tabellen angehen:

Abwägen, ob eine Vereinfachung möglich ist durch:
* Neue Attribute für die Identifier direkt in der Tabelle simitheme_published_sub_area (oder in einer 1:0..1 verknüpften Hilfstabelle simitheme_published_sub_area_identifier).
* Entfernen der Hilfstabelle simitheme_published_sub_area_helper
* Vorteil einfachere Queries, weniger Schemaredundanz
* Nachteil FK's in simitheme_published_sub_area müssen (temporär) nullable sein.
* Entscheiden, ob besser drei anstelle einer Hilfstabelle verwendet werden soll, damit der Code klarer ist.

## Vorgehen bei Schemaänderungen der SIMI-DB

1. Schemaänderung auf der Integration anwenden (typischerweise kurz nach erfolgreichem vergangenem Rollout)
1. Diesen Job nachführen (Sofern die Anzahl der zu kopierenden Tabellen verändert wurde).
1. Schemaänderung auf der Produktion anwenden (typischerweise als erster Schritt des aktuellen Rollout)
1. Rollout mittels diesem Job

## Shell-Skript für das lokale Ausführen

Für die lokale Ausführung die Datenbanken mit profil "rollout" starten / stoppen:

    docker compose --profile rollout up

    docker compose --profile rollout down

In build.gradle die url der write-connection gemäss docker-compose.yml konfigurieren:

    ...
    def readUri = "jdbc:postgresql://dbs_int:5432/simi"
    def writeUri = "jdbc:postgresql://dbs_prod:5432/simi"
    ...

GRETL lokal starten (in Verzeichnis simi/webapp/devenv)

    docker compose run --rm -u $UID gretl --project-dir=agi_layer_rollout

