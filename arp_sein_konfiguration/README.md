# Beschreibung GRETL-Job arp_sein_konfiguration

## Ziel GRETL-Job
Mit dem GRETL-Job sollen für die SEIn-App aus diversen Datenquellen (eigene PostGIS-Tabellen, xtf- und Shapefile-Dateien vom Bund) Daten zu bestimmten Themen (siehe arp_sein_konfiguration_grundlagen_v2.grundlagen_thema) zusammengetragen werden und so umgewandelt werden, damit die Aussage getätigt werden kann, ob eine Gemeinde von einem bestimmten Thema betroffen ist oder nicht und welche Objekte, bei Betroffenheit, vorhanden sind. Dazu werden die Geometrien der einzelnen Themen mit den Gemeindegeometrien verschnitten. Die Ausagen zu den einzelnen Themen werden in einem verschachtelten JSON-Attribut gespeichert. Zum Schluss wird auf Basis von arp_sein_konfiguration_grundlagen_v2.auswertung_thema ein xtf generiert, welches von geocloud in die SEIn-App eingelesen werden kann.

## Struktur GRETL-Job
Bei diesem GRETL-Job handelt es sich um ein Multi-Project-Build. Das heisst der Job besteht aus einem "Muterprojekt" (root project) und mehreren Subprojekten. Konkret beduetet dies, dass jedes Subprojekt ein eigenes build.gradle besitzt.

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
Gesteuert wird der ganze GRETL-Job über das build.gradle, welches im root project liegt (also im "obersten" Verzeichnis). Ebenfalls im Root-Verzeichnis vorhanden sind folgende Dateien:
- settings.gradle: Listet auf, welche Subprojekte in den GRETL-Job integriert sind. Ohne diese Auflistung können die einzelnen Subprojekte nicht ausgeführt werden.
- gradle.properties: Enthält den Befehl, dass die Subprojekte parallel ausgeführt werden können.
- job.properties: Wichtig hier ist vor allem die Zeile "nodeLabel=gretl-3.1", damit in Jenkins duckdb-Funktionen verwendet werden können, da diese im GRETL-image 3.1 vorhanden sind (Stand Juli 2025).
- Diverse sql-files. Die hier aufgeführten sql-files sollen von allen Subprojekten angesteuert werden können.

Die einzelnen Subprojekte enthalten ebenfalls noch ihre eigenen sql-files, welche aber nur vom jeweils spezifischen Projekt verwendet werden.
02_import_data enthält mehre Subprojekte und zwar eines zu jedem Thema, welches in arp_sein_konfiguration_grundlagen_v2.grundlagen_thema definiert wurde.

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
- <b>01_setup_duckdb:</b> Die Datenverarbeitung erfolgt innerhalb von DuckDB. Daher wird in einem ersten Schritt eine Datenbank generiert und eine Sammeltabelle erstellt. Diese dient, wie der Name vermuten lässt, zum Sammeln der Themendaten.
- <b>02_import_data:</b> Importiert die Daten aller Themen. Jedes Thema ist ein eigenes Subprojekt. Jedes Subprojekt kopiert die in 01_setub_duckdb erstellte Datenbank in das eigene build-Verzeichnis. Hier werden dann die (heruntergeladenen) Daten in die Sammeltabelle eingefüllt. Das heisst am Ende bestehen dann rund 50 Datenbanken. So kann sichergestellt werden, dass der Import parallel stattfinden kann. Zudem sind sämtliche Subprojekte hier sind nur von 01_setup_duckdb abhängig und können unabhängig voneinander funkionieren. Zum Schluss exportiert jedes Subprojekt den Inhalt ihrer Sammeltabelle in ein parquet-file. Parquet ist ein spaltenbasiertes Speicherformat welches die Daten binär kodiert. Es ist ein praktisches Format um Daten aus DuckDB zu exportieren und importieren. 
- <b>03_collect_data:</b> Auch hier wird zuerst die Datenbank aus 01_setup_duckdb kopiert. Danach werden sämtliche parquet-files aus 02_import_data in eine Sammeltabelle importiert. Nun werden die Daten durch eine spatial-Funktion gefiltert (es sollen nur die Daten verwendet werden, welche sich auch auf einem Gemeindegeibt im Kanton Solothurn befinden) und in eine zweite Sammeltabelle eingefüllt.<br>
Einige Themen besitzten keine Geometrien oder sind immer betroffen und könne bzw. müssen nicht nach ihrer Geometrie gefiltert werden. Diese werden direkt in die zweite Sammeltabelle abgefüllt.
- <b>04_processing_data:</b> Hier wird die Datenbank aus 03_collect_data kopiert und zusätzlich das Schema arp_sein_konfiguration_grundlagen_v2 anglegt. Nun werden die Daten aus der zweiten Sammeltabelle in so prozessiert, dass sie in die Tabelle auswertung_gemeinde eingefügt werden können. Anschliessend wird daraus ein xtf generiert und dieses auf dem ftp-Server hochgeladen.

## Dauer GRETL-Job
Der ganze GRETL-Job sollte ungfähr 14 Minuten dauern. Den Grossteil der Zeit beansprucht der Import der xtf-Daten (rund 12 Minuten).