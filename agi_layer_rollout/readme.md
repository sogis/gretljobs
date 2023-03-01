# Rollout der Metadaten aus der Integration

Kopiert die Metadaten von der Integration in die Zielumgebung.
Ausser der drei Tabellen simitheme_sub_area, simitheme_published_sub_area
und simitheme_published_sub_area_helper werden alle Daten kopiert 1:1.

## Erhalt des produktiven Publikationsdatums

Master für die drei Tabellen ist nicht die Integration, sondern die Zielumgebung. Ablauf der Verknüpfung Integration -> Zielumgebung

Auf Zielumgebung:
* Delete * from simitheme_published_sub_area_helper
* Kopieren der Attribute und Identifier von simitheme_published_sub_area und den verknüpften Tabellen nach simitheme_published_sub_area_helper 
* Delete * from simitheme_published_sub_area
* Aktualisierung aller anderen Tabellen aus Integration
* Ermittlung der technischen ID's von Themenbereitstellung und SubArea aufgrund der Indentifier. "Rückinsert" des Inhalts von simitheme_published_sub_area_helper nach simitheme_published_sub_area.

### Bei Anpassung

Abwägen, ob eine Vereinfachung möglich ist durch:
* Neue Attribute für die Identifier direkt in der Tabelle simitheme_published_sub_area (oder in einer 1:0..1 verknüpften Hilfstabelle simitheme_published_sub_area_identifier).
* Entfernen der Hilfstabelle simitheme_published_sub_area_helper
* Vorteil einfachere Queries, weniger Schemaredundanz
* Nachteil FK's in simitheme_published_sub_area müssen (temporär) nullable sein.

## Zielumgebung

Diese richtet sich nach der GRETL-Ausführungsumgebung. Sprich bei Auslösen auf GRETL-Prod erfolgt ein Rollout Integration -> Produktion.

Ein Ausführungsversuch auf GRETL-Integration wird mit Fehler abgebrochen.

## Fehlerbehandlung bei gebrochenen Referenzen

Bei inkonsistenzen zwischen den Identifikatoren auf Integration und Produktion
bricht der Job beim restorePubDates-Task mit Referenz-Fehler ab.

### Während Rollout

Die auskommentierte Where-Bedingung am Ende der [SQL-Datei](post_copy/restore_pub_dates.sql) des restorePubDates-Task "aktivieren". Damit wird der Fehler während dem Rollout "unterdrückt".

### Kurz nach Rollout

Bei gebrochenen Referenzen den Inhalt der [SQL-Datei](post_copy/restore_pub_dates.sql) des restorePubDates-Task
kopieren. In der Kopie das CTE mit dem auskommentierten SELECT anstelle des
INSERT abschliessen:

    ...
    SELECT * FROM leftjoin; -- Zwecks finden, welche fk-beziehung (a_id, tp_id) gebrochen ist.

    /*
    INSERT INTO 
      simi.simitheme_published_sub_area(
    ...
    */

Resultat von `SELECT * FROM leftjoin`

|tp_broken|tp_fullident|area_broken|area_fullident|...|
|---------|------------|-----------|--------------|---------|
|true|ch.so.afu.fliessgewaesser.revitalisierung:broken_tp_ref|false|av_kt:SO|...|
|false|ch.so.awjf.waldpflege:relational.erfassung|false|av_kt:SO|...|
|false|ch.so.afu.gewaesserschutz:VOID|false|av_kt:SO|...|
|false|ch.so.avt.kantonsstrassen:VOID|false|av_kt:SO|...|
|false|ch.so.afu.fliessgewaesser:VOID|true|av_kt:broken_area_ref|...|

Anhand der Boolean-Spalten **tp_broken** und **area_broken** wird klar, welche Referenzen gebrochen sind.

Ursache wird typischerweise die Umbenennung des Identifikators der Themenbereitstellung sein. Nach dem manuellen Abgleich der Identifikatoren kann der Rollout-Job erneut ausgeführt werden. Das Query SELECT * FROM leftjoin sollte nun keine Zeilen mehr generieren.

## Vorgehen bei Schemaänderungen der SIMI-DB

1. Schemaänderung auf der Integration anwenden (typischerweise kurz nach erfolgreichem vergangenem Rollout)
1. Diesen Job nachführen (Sofern die Anzahl der zu kopierenden Tabellen verändert wurde).
1. Schemaänderung auf der Produktion anwenden (typischerweise als erster Schritt des aktuellen Rollout)
1. Rollout mittels diesem Job

## Shell-Skript für das lokale Ausführen

    export ORG_GRADLE_PROJECT_dbUriSimi=jdbc:postgresql://localhost:5433/simi
    export ORG_GRADLE_PROJECT_dbUserSimi=postgres
    export ORG_GRADLE_PROJECT_dbPwdSimi=postgres
    export ORG_GRADLE_PROJECT_gretlEnvironment=test
    ./start-gretl.sh --docker-image sogis/gretl:latest --docker-network host --job-directory $PWD/agi_layer_rollout

