# gretljobs
Contains all job configuration files (\*.gradle, \*.sql, ...) of the jobs that are run by gretl and all files needed to set up a virtual gretl runtime environment

**Instructions to build the virtual gretl runtime environment**

As a requirement to run gretl virtual environment you have to define 4 environment variables in your .bashrc
To run the gretljobs you need a source DB and a target DB (possibly a virtual environment too).
Maybe you have to change pg_hba.conf of source DB or target DB
```
export sourceDbUrl=url to source DB
export sourceDbUser=username for source DB
export sourceDbPass=password for source DB 
export targetDbUrl=url to target DB (for example jdbc:postgresql://192.168.56.21/sogis (example for a virtual DB server))
export targetDbUser=username for target DB (for example gretl)
export targetDbPass=password for gretl user in target DB
```
After defining the environment variables you can build the virtual server.
Please make a new branch for working with gretljobs.
```
git clone https://github.com/sogis/gretljobs.git
cd gretljobs
git checkout -b branchname
vagrant up
```
Login on the virtual server with
```
vagrant ssh
```

Example build command 
```
gradle -b /vagrant/ch.so.afu.gewaesserschutz_export/build.gradle
```
**Best Practice für das Aufsetzen von jobs in build.gradle**
* Import Statements zuoberst einfügen.
* Als targetDbUser bei AGI Datenbanken gretl verwenden.
* Als temporäres Verzeichnis beim Herunterladen von Dateien ```System.getProperty("java.io.tmpdir")``` verwenden => temp Verzeichnis des Systems.
* Immer mindestens einen DefaultTask setzen mit dem das Skript startet. Dadurch muss dieser nicht beim Aufruf von GRETL mitgegeben werden (Bsp ```defaultTasks 'transferAgiHoheitsgrenzen'```).
* println einsetzen wo sinnvoll, also informativ.
* description für Projekt und Tasks machen (Beispiel av_mopublic/build.gradle).
* In den Select Queries kein Select * verwenden sondern die Spalten explizit aufführen.
* Pfade nicht im Unix Style sondern im Java Style angeben ```Paths.get("var","www","maps")``` oder ```Paths.get("var/www/maps")```.
* Pro Tabelle sollte eine SQL Datei verwendet werden.
* Bitte an den AGI SQL Richtlinien orientieren.
* Variablen mit def definieren.

**Best Practice für init.gradle**
* Die Beispiel init.gradle Datei verwenden.
* Plugins in init.gradle laden und nicht in build.gradle.
* GRETL Version hardcodiert angeben .
```
dependencies {
            classpath group: 'ch.so.agi', name: 'gretl',  version: '1.0.2'
}
```
