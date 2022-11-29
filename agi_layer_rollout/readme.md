# Rollout der Metadaten aus der Integration

Kopiert die Metadaten von der Integration in die Zielumgebung.
Ausser der drei Tabellen simitheme_sub_area, simitheme_published_sub_area
und simitheme_published_sub_area_helper werden alle Daten kopiert 1:1.

Master für die drei Tabellen ist nicht die Integration, sondern die Zielumgebung. Die Verknüpfung durch Befüllen von simitheme_published_sub_area erfolgt ganz am Schluss dieses Jobs durch den Task **restorePubDates**.

## Zielumgebung

Diese richtet sich nach der GRETL-Ausführungsumgebung. Sprich bei Auslösen auf GRETL-Prod erfolgt ein Rollout Integration -> Produktion.

Ein Ausführungsversuch auf GRETL-Integration wird mit Fehler abgebrochen.

## Fehlerbehandlung bei gebrochenen Referenzen

Bei inkonsistenzen zwischen den Identifieren auf Integration und Produktion
bricht der Job beim restorePubDates-Task mit Referenz-Fehler ab.

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

Ursache wird typischerweise die Umbenennung des Identifikators der Themenbereitstellung sein.

## Vorgehen bei Schemaänderungen der SIMI-DB

1. Schemaänderung auf der Integration anwenden (typischerweise kurz nach erfolgreichem vergangenem Rollout)
1. Diesen Job nachführen (Sofern die Anzahl der zu kopierenden Tabellen verändert wurde).
1. Schemaänderung auf der Produktion anwenden (typischerweise als erster Schritt des aktuellen Rollout)
1. Rollout mittels diesem Job
