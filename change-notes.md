# Dokumentation von allgemeinen Änderungen

## 08.06.2026: Änderungen bei der Entwicklung und lokalen Ausführung von GRETL-Jobs
Im letzten Monatsmeeting habe ich einige Änderungen bei der Entwicklung und lokalen Ausführung von GRETL-Jobs angekündigt.
Diese Änderungen sind ab heute aktiv.

### Änderung 1: Jobs werden neu in einem ständig laufenden GRETL-Container ausgeführt
Wegen dieser Neuerung ändern folgende Punkte beim Ausführen von Jobs:

* Mit dem Befehl `docker compose up -d` wird neu neben den DB-Containern auch ein GRETL-Container (Name: _gretl-service_) gestartet, der ständig läuft.
  https://github.com/sogis/gretljobs/blob/adfedef93a78d4cb353e1e8562a438f38ca07b7d/README.md?plain=1#L393

* GRETL-Jobs werden neu mit `docker compose exec` im bereits laufenden GRETL-Container ausgeführt
  (statt wie bisher mit `docker compose run` in einem jeweils neuen GRETL-Container):
  https://github.com/sogis/gretljobs/blob/adfedef93a78d4cb353e1e8562a438f38ca07b7d/README.md?plain=1#L479

* Auch Schema-Jobs werden neu mit `docker compose exec` im bereits laufenden GRETL-Container ausgeführt:
  https://github.com/sogis/gretljobs/blob/adfedef93a78d4cb353e1e8562a438f38ca07b7d/README.md?plain=1#L519-L520

Dies hat den Vorteil, dass die Jobs ab der zweiten Ausführung schneller durchlaufen, weil im bereits laufenden GRETL-Container der Gradle-Daemon für die Ausführung genutzt werden kann.
Es wird nun also nicht mehr jedes Mal ein frischer Container gestartet.

Falls ihr den Eindruck habt, dass sich ein Job deswegen neuerdings unerwartet verhaltet, könnt ihr ihn ohne den Daemon ausführen, indem ihr die Option `--no-daemon` mitgebt:
https://github.com/sogis/gretljobs/blob/adfedef93a78d4cb353e1e8562a438f38ca07b7d/README.md?plain=1#L503
Ich gehe nicht davon aus, dass dies tatsächlich nötig werden sollte.
Falls doch, gebt mir bitte entsprechendes Feedback.

### Änderung 2: `docker-compose.yml` ist neu auf mehrere Compose Files aufgeteilt
Das zentrale _Compose File_ heisst neu `compose.yaml`, und die Definition für die Processing-DB ist neu in einem separaten File `compose.processing.yaml`.
Daher ändern zudem folgende Punkte beim Ausführen von Jobs:

* Wenn man die Compose-Befehle aus dem Schema-Jobs-Verzeichnis heraus ausführt, muss man neu mit `-f ../gretljobs/compose.yaml` auf das Compose File verweisen, z.B.
  https://github.com/sogis/gretljobs/blob/adfedef93a78d4cb353e1e8562a438f38ca07b7d/README.md?plain=1#L391
  https://github.com/sogis/gretljobs/blob/adfedef93a78d4cb353e1e8562a438f38ca07b7d/README.md?plain=1#L524-L525
  https://github.com/sogis/gretljobs/blob/adfedef93a78d4cb353e1e8562a438f38ca07b7d/README.md?plain=1#L422

* Wenn man zusätzlich eine Processing-DB benötigt, muss man neu mit `-f compose.yaml -f compose.processing.yaml` auf zwei Compose Files verweisen, z.B.
  https://github.com/sogis/gretljobs/blob/adfedef93a78d4cb353e1e8562a438f38ca07b7d/README.md?plain=1#L406
  
### Änderung 3: Build Directory statt tmp-Verzeichnis verwenden

* Als (temporäres) Verzeichnis für Zwischenresultate, beim Herunterladen von Dateien etc. das _Build Directory_ verwenden und mit der Variablen `$buildDir` darauf zugreifen.
  (Standardmässig zeigt diese auf den Ordner `build` innerhalb des Projektverzeichnis.)<br/>
  https://github.com/sogis/gretljobs/blob/main/README.md#buildgradle, vierter Aufzählungspunkt<br/>
  Bestehende Jobs ändern wir nicht, oder nur dann, wenn wir sowieso daran arbeiten.

* Für Jobs mit File Upload: Die hochzuladende Datei soll im Unterordner `in` des *Build Directory* platziert werden (`$buildDir/in`).<br/>
  https://github.com/sogis/gretljobs/blob/main/README.md#buildgradle, fünfter Aufzählungspunkt<br/>
  Bestehende Jobs ändern wir nicht, oder nur dann, wenn wir sowieso daran arbeiten.

* Weil die Jobs neu in einem ständig laufenden GRETL-Container ausgeführt werden, ist es sinnvoll, von Zeit zu Zeit den Inhalt des _Build Directory_ (`$buildDir`) zu leeren:
  https://github.com/sogis/gretljobs/blob/adfedef93a78d4cb353e1e8562a438f38ca07b7d/README.md?plain=1#L495


## 15.06.2026: Weitere kleine Änderungen bei der Entwicklung und lokalen Ausführung von GRETL-Jobs (Anpassungen im Nachgang zum 08.06.2026)

* Die Processing-DB ist neu auf _localhost_ unter **Port 54324** (bisher 54323) erreichbar

* Das Compose File für die Processing-DB heisst neu `compose.processing.yaml` (bisher `compose.processing-db.yaml`)

* Mit `docker compose -f compose.yaml -f compose.oereb_v2.yaml up -d` kann neu zusätzlich eine lokale ÖREB-DB gestartet werden

* Um GRETL mit einem spezifischen Image Tag zu verwenden, muss man neu `GRETL_IMAGE_TAG=xy` in der Datei `.env` platzieren.
