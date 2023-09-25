# Bodenfaktor

## Inhalt

Für das Emissionsmodell Strassenlärm "sonROAD18" wird der Bodenfaktor G benötigt. Dieser Faktor beschreibt die Bodenabsorption basierend auf der Bodenbedeckung gemäss amtlicher Vermessung.

## Umsetzung

### Datenbank und GRETL Job

- Datenbank: **edit**
- Schema: **avt_bodenfaktor**
- Modell: **SO_AVT_Bodenabsorption_20230824.ili**

In einem ersten Schritt im Task _selectLandCoverFeatures_ wird die Tabelle _bodenfaktor_ geleert und mittels einer Abfrage der Bodenbedeckung aus der amtlichen Vermessung wieder neu gefüllt. Jeder Bodenbedeckungsart wird der entsprechende Bodenfaktor als Wert zwischen 0 und 1 zugeordnet. Es findet keine Verschmelzung der Fläche statt.

Die Zuordnungstabelle Bodenbedeckungsart zu Bodenfaktor ist direkt in die SQL Abfrage eingebaut.

Der zweite Task _publishData_ publiziert die Daten. Es findet keine Validierung mehr statt, weil die Daten der AV beim Import ebenfalls nicht validiert werden.

### Spezielles

- die Publikation der Daten findet pro Gemeinde statt
- der Publisher Task findet direkt aus der _edit_ Datenbank statt, da nur in dieser Datenbank die AV im Solothurner Modell zur Verfügung steht
- ändert sich die Liste der Gemeinden (nach Fusionen o.Ä.) müssen die vorhandenen Datasets nachgeführt werden, siehe dazu den dazugehörigen Schema-Job, ansonsten läuft der Job nicht durch

### Ausführung

Der Job wird wöchentlich am Wochenende ausgeführt.


