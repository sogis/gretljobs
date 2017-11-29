# gretljobs
Enthält sämtliche Konfigurationsdateien (`*.gradle`, `*.sql`) der GRETL-Jobs und eine GRETL-Entwicklungsumgebung.

## Anleitung GRETL-Entwicklungsumgebung
Die GRETL-Entwicklungsumgebung läuft in einer Vagrant-Box (= virtueller Server). Die Datenbankverbindungsparameter einer Quell- und einer Zieldatenbank müssen als vier Umgebungsvariablen in der `.bashrc`-Datei gespeichert werden. Sowohl Ziel- wie auch die Quelldatenbank können ebenfalls in einer Vagrant-Boxlaufen. Unter Umständen müssen die `pg_hba.conf`- und `postgresql.conf`-Dateien angepasst werden, damit auf die Datenbank von "ausserhalb" zugegriffen werden kann.

Beispieleinträge in `.bashrc`:
```
export sourceDbUrl=jdbc:postgresql://geodb-t.verw.rootso.org/sogis
export sourceDbUser=mylogin
export sourceDbPass=mypwd
export targetDbUrl=jdbc:postgresql://192.168.56.21/sogis
export targetDbUser=gretl
export targetDbPass=fubar
```

Anschliessend können neue GRETL-Jobs erstellt werden oder bestehende verändert werden. Für jeden neuen Job wird ein neuer Branch erstellt.

```
git clone https://github.com/sogis/gretljobs.git
cd gretljobs
git checkout -b branchname
vagrant up
```

Einloggen in die Vagrant-Box:

```
vagrant ssh
```

Ausführen des Jobs:

```
gradle -b /vagrant/ch.so.afu.gewaesserschutz_export/build.gradle
```

## Best Practice für das Erstellen von Jobs

### build.gradle

* `import`-Statements zuoberst einfügen
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

### init.gradle

* Die Beispiel `init.gradle`-Datei verwenden.
* Plugins in `init.gradle` laden und nicht in build.gradle.
* Die GRETL-Version wird hardcodiert eingetragen und bei Bedarf muss sie angepasst werden:

```
dependencies {
            classpath group: 'ch.so.agi', name: 'gretl',  version: '1.0.2'
}
```

