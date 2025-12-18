# Beschreibung GRETL-Job arp_sein_konfiguration

## Ziel GRETL-Job
Mit dem GRETL-Job sollen für die SEIn-App aus diversen Datenquellen (eigene PostGIS-Tabellen, xtf- und Shapefile-Dateien vom Bund) Daten zu bestimmten Themen (siehe arp_sein_konfiguration_grundlagen_v2.grundlagen_thema) zusammengetragen werden und so umgewandelt werden, damit die Aussage getätigt werden kann, ob eine Gemeinde von einem bestimmten Thema betroffen ist oder nicht und welche Objekte, bei Betroffenheit, vorhanden sind. Dazu werden die Geometrien der einzelnen Themen mit den Gemeindegeometrien verschnitten. Die Aussagen zu den einzelnen Themen werden in einem verschachtelten JSON-Attribut gespeichert. Zum Schluss wird auf Basis von arp_sein_konfiguration_grundlagen_v2.auswertung_thema ein xtf generiert, welches von geocloud in die SEIn-App eingelesen werden kann.

## Struktur GRETL-Job
Bei diesem GRETL-Job handelt es sich um ein Multi-Project-Build. Das heisst der Job besteht aus einem "Hauptprojekt" (root project) und mehreren Subprojekten. Konkret bedeutet dies, dass jedes Subprojekt ein eigenes build.gradle besitzt.

Die Ordnerstruktur des GRETL-Jobs sieht folgendermassen aus:

```
├── build.gradle (root project)
├── gradle.properties
├── job.properties
├── settings.gradle
├── various sql-files (project-wide use)
├── 01_setub_duckdb (subproject)
│   └── build.gradle    
├── 02_import_data
│   └── thema 1 (subproject)
│       └── build.gradle 
│   └── thema 2 (subproject)
│       └── build.gradle
│   └── thema x (subroject)
│       └── build.gradle
├── 03_collect_data (subproject)
│   └── build.gradle
└── 04_processing_data (subproject)
    └── build.gradle
```
Gesteuert wird der ganze GRETL-Job über das build.gradle, welches im root project liegt (also im "obersten" Verzeichnis). Im Root-Verzeichnis liegen ebenfalls einige sql-files. Diese können von allen Subprojekten genutzt werden.

Die einzelnen Subprojekte enthalten ebenfalls ihre eigenen sql-files, welche aber nur vom jeweils spezifischen Projekt verwendet werden.
02_import_data enthält mehre Subprojekte, und zwar eines zu jedem Thema, welches in arp_sein_konfiguration_grundlagen_v2.grundlagen_thema definiert wurde.

Der Ablauf des GRETL-Jobs sieht folgendermassen aus:

```
┌───────────────────────┐
│    01_setup_duckdb    │ subroject 1
└───────────────────────┘
     02_import_data
        │   │   │
      t1│ t2│ tx│         subrprojects 2 (various)
        │   │   │   
        ▼   ▼   ▼
┌───────────────────────┐
│    03_collect_data    │ subproject 3
└───────────────────────┘
            │               
            ▼
┌───────────────────────┐
│   04_processing_data  │ subproject 4
└───────────────────────┘
            │               
            ▼
    export & upload xtf
```
Neben der parallelen Abwicklung verschiedener Subjobs, bietet ein Multi-Project-Build auch eine bessere Übersicht (hier für jedes Thema ein Subjob, anstatt alle Themen in einem build.gradle) und erlaubt es wärend der Entwicklung einzelne Subjobs bzw. -Tasks auszuführen, ohne, dass jedes mal in das build.gradle eingegriffen werden muss. <br>
Ein Beispiel. Es soll nur der letzte Task für das Thema amphbiengebiete_ortsfest_shp2 ausgeführt werden:
```
GRETL_IMAGE_TAG=3.1 docker compose run --rm -u $UID gretl --project-dir=arp_sein_konfiguration_local :02_import_data:amphibiengebiete_ortsfest_shp2:last
```

<b>Kurze Erklärung der Subprojekte:<br></b>

- <b>01_setup_duckdb:</b> Die Datenverarbeitung erfolgt innerhalb von DuckDB. Daher wird in einem ersten Schritt eine Datenbank generiert und eine Sammeltabelle erstellt. Diese dient, wie der Name vermuten lässt, zum Sammeln der Themendaten.
- <b>02_import_data:</b> Importiert die Daten aller Themen. Jedes Thema ist ein eigenes Subprojekt. Jedes Subprojekt kopiert die in 01_setub_duckdb erstellte Datenbank in das eigene build-Verzeichnis. Hier werden dann die (heruntergeladenen) Daten in die Sammeltabelle eingefüllt. Das heisst am Ende bestehen dann rund 50 Datenbanken. So kann sichergestellt werden, dass der Import parallel stattfinden kann. Zudem sind sämtliche Subprojekte hier sind nur von 01_setup_duckdb abhängig und können unabhängig voneinander funktionieren. Zum Schluss exportiert jedes Subprojekt den Inhalt ihrer Sammeltabelle in ein parquet-file. 
- <b>03_collect_data:</b> Auch hier wird zuerst die Datenbank aus 01_setup_duckdb kopiert. Danach werden sämtliche parquet-files aus 02_import_data in eine Sammeltabelle importiert. Nun werden die Daten durch eine spatial-Funktion gefiltert (es sollen nur die Daten verwendet werden, welche sich auch auf einem Gemeindegebiet im Kanton Solothurn befinden) und in eine zweite Sammeltabelle eingefüllt.<br>
Einige Themen besitzen keine Geometrien oder sind immer betroffen und könne bzw. müssen nicht nach ihrer Geometrie gefiltert werden. Diese werden direkt in die zweite Sammeltabelle abgefüllt.
- <b>04_processing_data:</b> Hier wird die Datenbank aus 03_collect_data kopiert und zusätzlich das Schema arp_sein_konfiguration_grundlagen_v2 anglegt. Nun werden die Daten aus der zweiten Sammeltabelle in so prozessiert, dass sie in die Tabelle auswertung_gemeinde eingefügt werden können. Anschliessend wird daraus ein xtf generiert und dieses auf den ftp-Server hochgeladen.

## Ausführlichere Erklärung Subprojekte
Im Folgenden werden die einzelnen Subprojekte etwas detaillierter erklärt.
Jeds Subprojekt besitzt ein eigenes build.gradle. Die darin enthaltenen Tasks werden jeweils von einem "first" und einem "last" task umschlossen. Dadurch können Subprojekte bei Abhängigkeiten (dependsON) sich jeweils einheitlich auf diese tasks beziehen.

### Root-Projekt (Hauptverzeichnis)
Im Root-Proejt bzw. im Hauptverzeichnis liegen alle Dateien, welche für das ganze Projekt von Bedeutung sind und/oder von allen Subprojekten benötigt werden.

- <b>build.gradle:</b> Enthält Variablen welche von allen Subprojekten genutzt werden können.
Dazu gehören unter anderem sql-Files, welche in erster Linie für DuckDB-Funktionen genutzt werden und die Definiton der Datenbank-Variablen, damit das Anfügen (Attach) der Edit- und Pub-DB funktioniert.
- <b>gradel.properties:</b> Definiert, dass Subprojekte, wo möglich, parallel abgehandelt werden drüfen.
- <b>settings.gradle:</b> Listet auf, welche Subprojekte in den GRETL-Job integriert sind. Ohne diese Auflistung können die einzelnen Subprojekte nicht ausgeführt werden.
- <b>job.properties:</b> Wichtig hier ist vor allem die Zeile "nodeLabel=gretl-3.1", damit in Jenkins duckdb-Funktionen verwendet werden können, da diese im GRETL-image 3.1 vorhanden sind (Stand Juli 2025).

### 01_setup_duckdb
Dies ist das erste Subprojekt, von dem alle weiteren Subprojekte abhängig sind (direkt oder indirekt). Hier wird die DuckDB-Datenbank und darin die Sammeltabelle für die einzelnen Themen erstellt.

### 02_import_data
Hier ist zu jedem Thema ein eigenes Subprojekt enthalten. Jedes Subprojekt kopiert die Datenbank aus 01_setup_duckdb in das eigene build-Verzeichnis und importiert die eigenen Daten in die Sammeltabelle. Zum Schluss wird aus der Sammeltabelle eine parquet-Datei exportiert. Parquet ist ein spaltenbasiertes Speicherformat welches die Daten binär kodiert. Es ist ein praktisches und schnelles Format um Daten in DuckDB zu lesen und schreiben. <br>
Die einzelnen Themen sind im Schema arp_sein_konfiguration_grundlagen_v2.grundlagen_thema festgehalten.
Beim Import wird zudem hart kodiert das Attribut thema_sql abgefüllt. Der Wert sollte dabei genau dem entsprechen was in arp_sein_konfiguration_grundlagen_v2.grundlagen_thema festgelegt wurde. In 03_collect_data wird dies dann abgeglichen.

Grob kann zwischen folgenden Datenquellen unterschieden werden:
- Shapefiles, welche vom Bund bezogen werden und direkt in die Datenbank importiert werden können (shp1). Beispiel: auengebiete_shp1
- Shapefiles, welche zuerst beim Bund heruntergeladen, entzippt und dann in die Datenbank importiert werden (shp2). Beispiel: amphibiengebiete_ortsfest_shp2
- Xtf-Datein, welche beim Bund heruntergeladen, enzippt und dann in die Datenbank importiert werden (xtf). Damit der Import funktionieren kann, muss zudem ein Schema auf der Datenbank angelegt werden. Der Import dieser Daten nimmt mit Abstand am meisten Zeit in Anspruch, besonders dort, wo viele Daten vorhanden sind (insbesondere IVS). Beispiel: ivs_national_xtf

Daneben existieren auch noch Themen, welche keine Geometrien besitzen oder, welche jede Gemeinde betreffen. Diese werden anders gehandhabt und erst in 03_collect_data importiert. Der Vollständigkeit halber sind die Themen, welche jede Gemeinde betreffen aber auch in diesem Verzeichnis aufgelistet. Beispiel: grundnutzung_d. 

Die Objekte ohne Geometrien werden in 03_collect_data erklärt.

### 03_collect_data
Auch hier wird zuerst die Datenbank aus 01_setup_duckdb kopiert.
Nun werden sämtliche parquet-files aus den verschiedenen Themen in die Sammeltabelle importiert. Damit wären alle Daten nun in einer Tabelle.

In der Datenbank wird ebenfalls das Schema arp_sein_konfiguration_grundlagen_v2 angelegt. Zusätzlich wird eine zweite Sammeltabelle ohne Geometrien erstellt (Sammeltabelle_filtered). Unter Anwendung eine spatial-filters (st_intersects) werden nun die Daten aus der ersten Sammeltabelle in die zweite überführt. Somit sind dann nur noch diejenigen vorhanden, welche für die Gemeinden im Kanton Solothurn relevant sind.

In diese zweite Sammeltabelle werden nun auch die Daten importiert, welche auf der Edit-DB im Schema arp_sein_konfiguration_grundlagen_v2.grundlagen_objektinfo durch das ARP erfasst wurden (besitzen keine Geometrien) und diejenigen Themendaten, welche für alle Gemeinden immer relevant sind. Diese Themen enden alle mit einem _d. Wie alle Themen, sind auch diese im Ordner 02_import_data hinterlegt.

Zur Kontrolle der Themenbezeichnungen werden nun die aktualisierten Themen mit thema_sql verglichen. Sollten hier Unregelmässigkeiten auftreten, bricht der Job ab. Unregelmässigkeiten deuten darauf hin, dass ein Thema entweder geändert oder gelöscht wurde.

### 04_processing_data
Hier wird die Datenbank aus 03_collect_data kopiert. Anschliessend werden die Daten so prozessiert, dass sie in arp_sein_konfiguration_grundlagen.auswertung_gemeinde eingefügt werden können. Die Themen werden dabei in ein verschachteltes JSON-Format gebracht.

Anschliessend wird aus dem Schema ein xtf exportiert und dieses auf den ftp-Server hochgeladen.

## Dauer GRETL-Job
Der ganze GRETL-Job hat eine Laufzeit von ca. 15 Minuten. Den Grossteil der Zeit beansprucht der Import der xtf-Daten, insbesondere der IVS-Daten (rund 12 Minuten).