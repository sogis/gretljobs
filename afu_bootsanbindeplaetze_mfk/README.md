# Beschreibung GRETL-Job afu_bootsanbindeplaetze_mfk
Dieses Readme gibt zusätzliche Informationen zum GRETL-Job afu_bootsanbindeplaetze_mfk. Es ist komplementär zu den Kommentaren in den SQL-Files und build.gradle-File. Für tiefergehende fachliche Informationen kann zudem das Konzept beigezogen werden.

## Ziel GRETL-Job
Der GRETL-Job soll eine Hilfestellung zum Abgleich der MFK- und AfU-Daten liefern. Das AfU bezieht von der MFK bei Bedarf eine CSV-Liste, welche auf einem SQL-Template beruht. Mit dieser Liste können die Bootsdaten der MFK und des AfU verglichen werden.

## Funktionsweise des GRETL-Job
Die CSV-Liste des MFK kann mit dem GRETL-Job in Jenkins eingelesen werden. Die Daten aus dem CSV-File, sowie die AfU-Daten werden dann in DuckDB miteinander verglichen. Exportiert wird anschliessend eine gpkg-Datei, auf welche QGIS zugreiffen kann. Dafür wurde in QGIS bereits die entsprechende Symbolisierung erstellt. Die GPKG-Datei muss dafür immer mit dem gleichen Namen im gleichen Ordner abgelegt werden.
