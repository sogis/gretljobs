# gretljobs
Enthält sämtliche Konfigurationsdateien (`*.gradle`, `*.sql`) der GRETL-Jobs und eine GRETL-Entwicklungsumgebung.


## Best Practice für das Erstellen von Jobs

* Für jeden neuen Job oder für jede Änderung an einem Job muss ein neuer Entwicklungsbranch erstellt werden:

```
git checkout -b branchname
```

* Änderungen müssen immer per Pull Request in den master-Branch eingepflegt werden

### build.gradle

* `import`-Statements zuoberst einfügen
* Danach das `apply plugin`-Statement einfügen
* Als `targetDbUser` bei AGI-Datenbanken `gretl` verwenden.
* Als (temporäres) Verzeichnis beim Herunterladen von Dateien etc. ```System.getProperty("java.io.tmpdir")``` verwenden. Dies ist das temp-Verzeichnis des Betriebssystems. Heruntergeladene und temporäre Dateien bitte trotzdem mittels abschliessenden Task wieder löschen.
* Immer mindestens einen DefaultTask setzen mit dem das Skript startet. Dadurch muss kein Task beim Aufruf von GRETL mitgegeben werden (Bsp ```defaultTasks 'transferAgiHoheitsgrenzen'```).
* `println` einsetzen wo sinnvoll, also informativ.
* `description` für Projekt und Tasks machen (Beispiel `av_mopublic/build.gradle`).
* In den `SELECT`-Statements kein `SELECT *` verwenden, sondern die Spalten explizit aufführen.
* Pfade nicht im Unix Style, sondern im mittels Java-Methoden Betriebssystem unabhängig angeben: ```Paths.get("var","www","maps")``` oder ```Paths.get("var/www/maps")```.
* Pro Tabelle sollte eine SQL-Datei verwendet werden.
* Bitte an den AGI SQL-Richtlinien orientieren.
* Variablen mit `def` definieren und nicht mit `ext{}`


## GRETL Runtime Docker Image verwenden

Docker Image mit der GRETL runtime starten für die Job Entwicklung.

```
cd scripts/
./start-gretl.sh --docker_image sogis/gretl-runtime:14 --job_directory /home/gretl --task_name gradleTaskName -Pparam1=1 -Pparam2=2
```

Meistens benötigt ein GRETL-Job eine Quell- und eine Ziel-Datenbank. Hierfür können lokal folgende Umgebungsvariablen gesetzt werden (Werte entsprechend anpassen); sie werden der GRETL Runtime als Parameter übergeben und können im GRETL-Skript als Variablen genutzt werden:

```
export DB_URI_SOGIS=jdbc:postgresql://127.0.0.1/foodb
export DB_USER_SOGIS=foo
export DB_PWD_SOGIS=foopassword
export DB_URI_PUB=jdbc:postgresql://localhost:5432/bardb
export DB_USER_PUB=bar
export DB_PWD_PUB=barpassword
```

Unter Ubuntu können diese Befehle in die Datei ~/.profile eingetragen werden, damit die Umgebungsvariablen immer verfügbar sind.


Oder das test Skript *test-gretl.sh* verwenden.

### Troubleshooting
Wenn folgende Fehlermeldung auftritt, muss das *.gradle* Ordner im Job Ordner gelöscht werden.

```
Caused by: java.io.FileNotFoundException: /home/gradle/project/.gradle/4.2.1/fileHashes/fileHashes.lock (Permission denied)
```
