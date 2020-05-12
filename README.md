# gretljobs
Enthält sämtliche Konfigurationsdateien (`*.gradle`, `*.sql`) der GRETL-Jobs und eine GRETL-Entwicklungsumgebung. Umfasst zudem das Job DSL Script `gretl_job_generator.groovy` für den *gretl-job-generator*, der in regelmässigen Abständen das *gretljobs*-Repository durchsucht und daraus in Jenkins entsprechende Jenkins-Pipelines generiert.

## Funktionsweise in Jenkins

In Jenkins besteht zu Beginn nur ein Job *gretl-job-generator*; das Skript, das er ausführt, ist `gretl_job_generator.groovy`. Er checkt in regelmässigen Abständen das *gretljobs*-Repository aus und sucht in allen Ordnern (konfigurierbar) nach Skripten mit Name `build.gradle` (konfigurierbar).

Wenn er ein solches findet, legt er einen Job an und definiert das Skript in der Datei `Jenkinsfile` als Code, den der Job ausführen soll. Falls der *gretl-job-generator* im Ordner des gerade anzulegenden Jobs neben `build.gradle` auch eine eigene Datei mit Namen `Jenkinsfile` findet, definiert er als Code für den Job statt des zentralen Jenkinsfiles den Inhalt dieses jobspezifischen Jenkinsfiles (Übersteuerbarkeit). Zudem weist der *gretl-job-generator* optional dem Job folgende Eigenschaften zu:

* Wer den Job starten darf
* Wieviele Ausführungen eines Jobs aufbewahrt werden sollen
* Ob bei Start des Jobs eine Datei hochgeladen werden muss
* Ob der Job nach Ausführung eines anderen Jobs gestartet werden soll
* Ob der Job in regelmässigen Zeitintervallen gestartet werden soll

Wenn ein GRETL-Job gestartet wird, ermittelt das zugewiesene Skript alle benötigten Parameter und Benutzernamen für den Zugriff auf DBs und andere externe Ressourcen und führt mit Gradle das Skript `build.gradle`, das im entsprechenden Job-Verzeichnis liegt, aus.


## Best Practice für das Erstellen von Jobs

* Für jeden neuen Job oder für jede Änderung an einem Job muss ein neuer Entwicklungsbranch erstellt werden:

```
git checkout -b branchname
```

* Änderungen müssen immer per Pull Request in den master-Branch eingepflegt werden

### build.gradle

* `import`-Statements zuoberst einfügen
* Danach das `apply plugin`-Statement einfügen
* Als DB-User bei AGI-Datenbanken `gretl` verwenden.
* Als (temporäres) Verzeichnis beim Herunterladen von Dateien etc. ```System.getProperty("java.io.tmpdir")``` verwenden. Dies ist das temp-Verzeichnis des Betriebssystems. Heruntergeladene und temporäre Dateien bitte trotzdem mittels abschliessenden Task wieder löschen.
* Immer mindestens einen DefaultTask setzen mit dem das Skript startet. Dadurch muss kein Task beim Aufruf von GRETL mitgegeben werden (Bsp ```defaultTasks 'transferAgiHoheitsgrenzen'```).
* `println` einsetzen wo sinnvoll, also informativ.
* `description` für Projekt und Tasks machen (Beispiel `av_mopublic/build.gradle`).
* In den `SELECT`-Statements kein `SELECT *` verwenden, sondern die Spalten explizit aufführen.
* Pfade nicht im Unix Style, sondern im mittels Java-Methoden Betriebssystem unabhängig angeben: ```Paths.get("var","www","maps")``` oder ```Paths.get("var/www/maps")```.
* Pro Tabelle sollte eine SQL-Datei verwendet werden.
* Bitte an den AGI SQL-Richtlinien orientieren.
* Variablen mit `def` definieren und nicht mit `ext{}`
* Für den Zugriff auf Datenbanken, auf andere Server und auf den GRETL-Speicherplatz folgende Variablen verwenden:
  * `dbUriSogis`, `dbUserSogis`, `dbPwdSogis`
  * `dbUriVerisoNplso`, `dbUserVerisoNplso`, `dbPwdVerisoNplso`
  * `dbUriEdit`, `dbUserEdit`, `dbPwdEdit`
  * `dbUriPub`, `dbUserPub`, `dbPwdPub`
  * `dbUriAltlast4web`, `dbUserAltlast4web`, `PdbPwdAltlast4web`
  * `dbUriKaso`, `dbUserKaso`, `dbPwdKaso`
  * `dbUriCapitastra`, `dbUserCapitastra`, `dbPwdCapitastra`
  * `ftpServerZivilschutz`, `ftpUserZivilschutz`, `ftpPwdZivilschutz`
  * `aiServer`, `aiUser`, `aiPwd`
  * `infofloraUser`, `infofloraPwd`
  * `igelToken`
  * `gretlShare`


### Files

Jeder GRETL-Job braucht im Minimum das File `build.gradle`. Bei Bedarf platziert man zudem ein File `job.properties` im Job-Ordner, um den Job in Jenkins zu konfigurieren. Falls der Job in Jenkins mit einem anderen Jenkinsfile als dem Standard-Jenkinsfile gestartet werden soll, muss sein spezifisches Jenkinsfile ebenfalls im Job-Ordner abgelegt werden.

#### `job.properties`

Die Datei `job.properties` muss in ISO 8859-1 encodiert sein, damit allfällige Umlaute etc. korrekt eingelesen werden.
Sie kann folgende Eigenschaften des GRETL-Jobs enthalten:

```java
logRotator.numToKeep=30
triggers.cron=H H(1-3) * * *
parameters.fileParam=filename.xtf
parameters.stringParam=parameterName;default value;parameter description
triggers.upstream=other_job_name
authorization.permissions=gretl-users-barpa
nodeLabel=gretl-ili2pg4
```

Mit `logRotator.numToKeep` kann eingestellt werden, wieviele Ausführungen des Jobs aufbewahrt werden sollen, d.h. für wieviele Ausführungen beispielsweise das Logfile vorgehalten wird. Standardwert ist 15. Wenn man diese Einstellung weglässt, werden also die 15 letzten Ausführungen aufbewahrt.

Mit `triggers.cron` kann eingestellt werden, zu welchem Zeitpunkt der Job automatisch gestartet werden soll. Im Beispiel `H H(1-3) * * *` wird der Job jeden Tag irgendwann zwischen 01:00 Uhr und 03:59 Uhr ausgeführt. (Dokumentation der Schreibweise siehe https://github.com/jenkinsci/jenkins/blob/master/core/src/main/resources/hudson/triggers/TimerTrigger/help-spec.jelly). Wenn man diese Einstellung weglässt, wird der Job nie automatisch gestartet, und er muss manuell gestartet werden.

Mit `parameters.fileParam` kann erreicht werden, dass ein  Benutzer beim Starten des Jobs eine Datei hochladen muss, die dann vom GRETL-Job verarbeitet wird. Es wird ein Dateiname (z.B. `filename.xtf`) oder Pfad (z.B. `data/filename.xtf`) verlangt, mit welchem im GRETL-Job auf die Datei zugegriffen werden kann.

Mit `parameters.stringParam` kann ein Parameter definiert werden, mit dem der Job gestartet wird und für welchen beim manuellen Start des Jobs vom Benutzer ein Wert eingegeben werden kann. Im obigen Beispiel wird ein String-Parameter mit Name `parameterName` definiert, dessen Standarwert `default value` ist und für den dem Benutzer neben dem Eingabefeld die Beschreibung `parameter description` angezeigt wird. Die drei Werte müssen mit Strichpunkt voneinander getrennt werden. Für den Standardwert und die Beschreibung sind Leerschläge zugelassen. Über den Parameternamen kann im Jenkinsfile auf den Wert des Parameters zugegriffen werden.

Mit `triggers.upstream` kann eingestellt werden, dass der Job immer dann ausgeführt werden soll, wenn ein bestimmter anderer Job erfolgreich ausgeführt worden ist. Es können hier auch mehrere Jobs angegeben werden, jeweils durch Komma und Leerschlag voneinander getrennt (z.B. `other_job_name_1, other_job_name_2`).

Mit `authorization.permissions` kann angegeben werden, welcher Benutzer oder welche Benutzergruppe den Job manuell starten darf.
Folgende GRETL-spezifischen Benutzergruppen stehen im Moment zur Verfügung:

* gretl-users-barpa
* gretl-users-bdafu
* gretl-users-bvtaa
* gretl-users-edden
* gretl-users-vkfaa
* gretl-users-vlwaa

Allerdings können auch diejenigen Benutzer oder Gruppen, welche durch globale Berechtigungseinstellungen in Jenkins dazu bereichtigt sind, den Job starten. Wenn man diese Einstellung weglässt, ist es von den globalen Berechtigungseinstellungen abhängig, wer den Job manuell starten darf.

Mit `nodeLabel` kann bestimmt werden,
auf welchem Node der Job ausgeführt werden soll.
Erlaubt ist hier einzig der Wert `gretl-ili2pg4`;
so wird der Job auf einem Jenkins Agent
mit dem Label `gretl-ili2pg4` ausgeführt.
Lässt man diese Property weg,
wird der Job auf einem Jenkins Agent
mit dem Label `gretl` ausgeführt (der Standard).


## Entwicklungs-DBs starten

Mit diesem Repository wird die Konfiguration für den Start von zwei leeren Entwicklungs-DBs mitgeliefert. Mit folgenden Befehlen kann man diese starten, um danach Daten zu importieren und mit der Entwicklung von GRETL-Jobs zu starten.

Zwei Docker-DB-Server starten; einer enthält die edit-DB, der andere die pub-DB:
```
docker-compose down # (dieser Befehl ist optional; er kann benutzt werden, um bereits gestartete DB-Container zu stoppen und zu löschen)
docker-compose up
```

Nun können in den DBs nach Belieben Schemas angelegt und Daten importiert werden.
Dies kann z.B. mit *ili2pg* erfolgen
oder durch Ausführen von SQL-Skripten
oder durch Restoren aus einem Dump.

Die DBs sind mit folgenden Verbindungsparametern erreichbar:

#### Edit-DB

* Hostname: `localhost`
* Port: `54321`
* DB-Name: `edit`
* Benutzer: `gretl` (für Lese- und Schreibzugriff) oder `admin` (zum Anlegen von Schemen, Tabellen usw.); das Passwort lautet jeweils gleich wie der Benutzername

#### Publikations-DB

* Hostname: `localhost`
* Port: `54322`
* DB-Name: `pub`
* Benutzer: `gretl` (für Lese- und Schreibzugriff) oder `admin` (zum Anlegen von Schemen, Tabellen usw.); das Passwort lautet jeweils gleich wie der Benutzername

### Die Rollen (Benutzer und Gruppen) der produktiven DBs importieren

Um auch die in den produktiven DBs vorhandenen DB-Rollen
in den Entwicklungs-DBs verfügbar zu haben,
kopiert man die Datei mit den DB-Rollen (die "Globals")
vom geoutil-Server auf seine lokale Maschine,
entfernt mit einem `sed`-Befehl diejenigen Zeilen,
die für die Entwicklungs-DBs nicht nötig sind,
und importiert sie dann mit `psql` in die Entwicklungs-DBs:
```
scp geoutil.verw.rootso.org:/opt/workspace/dbdump/globals_geodb.rootso.org.dmp /tmp
sed -E -i.bak '/^CREATE ROLE (postgres|admin|gretl)\;/d; /^ALTER ROLE (postgres|admin|gretl) /d' /tmp/globals_geodb.rootso.org.dmp
psql --single-transaction -h localhost -p 54321 -d edit -U postgres -f /tmp/globals_geodb.rootso.org.dmp
psql --single-transaction -h localhost -p 54322 -d pub -U postgres -f /tmp/globals_geodb.rootso.org.dmp
```
Für den Fall, dass `psql` auf der lokalen Maschine nicht installiert ist,
kopiert man stattdessen die Globals zuerst in den laufenden Container
und führt danach den `psql`-Befehl innerhalb des Containers aus:
```
docker cp /tmp/globals_geodb.rootso.org.dmp gretljobs_pub-db_1:/tmp
docker exec -e PGHOST=/tmp -it gretljobs_pub-db_1 psql --single-transaction -d pub -f /tmp/globals_geodb.rootso.org.dmp
docker cp /tmp/globals_geodb.rootso.org.dmp gretljobs_edit-db_1:/tmp
docker exec -e PGHOST=/tmp -it gretljobs_edit-db_1 psql --single-transaction -d edit -f /tmp/globals_geodb.rootso.org.dmp
```



## GRETL Runtime Docker Image verwenden

Für die Entwicklung von GRETL-Jobs
kann GRETL mit einem Wrapper-Skript als Docker-Container gestartet werden.

Zunächst müssen die Verbindungsparameter zu den DBs konfiguriert werden:
```
export ORG_GRADLE_PROJECT_dbUriEdit=jdbc:postgresql://edit-db/edit
export ORG_GRADLE_PROJECT_dbUserEdit=gretl
export ORG_GRADLE_PROJECT_dbPwdEdit=gretl
export ORG_GRADLE_PROJECT_dbUriPub=jdbc:postgresql://pub-db/pub
export ORG_GRADLE_PROJECT_dbUserPub=gretl
export ORG_GRADLE_PROJECT_dbPwdPub=gretl
```

Danach kann der GRETL-Container gestartet werden. Beispiel-Aufruf:

```
./start-gretl.sh --docker-image sogis/gretl-runtime:latest [--docker-network NETWORK] --job-directory $PWD/jobname [taskName...] [--option-name...]
```

Mit `--docker-image IMAGE:TAG` wird angegeben,
welches Image man starten möchte.

Mit `--docker-network NETWORK` (optional) kann angegeben werden,
dass der GRETL-Container an ein bestimmtes Docker-Netzwerk
angebunden werden soll.
(Die Namen der verfügbaren Docker-Netzwerke
können mit dem Befehl `docker network ls` ermittelt werden.)

Mit `--job-directory $PWD/jobname` wird
das Verzeichnis zum auszuführenden Job angegeben.
Dies muss ein absoluter Pfad sein;
deshalb steht hier der Vorschlag, `$PWD` zu verwenden.

Mit `[taskName...]` (optional) können ein oder mehrere Tasks angegeben werden,
die von GRETL ausgeführt werden sollen.

Mit `[--option-name...]` können beliebige Gradle-Optionen verwendet werden,
auch z.B. `-Pmyprop=myvalue` und `-Dmyprop=myvalue`.
Die Gradle-Optionen sind unter
https://docs.gradle.org/current/userguide/command_line_interface.html
beschrieben oder aus der Ausgabe des Befehls `gradle -h` ersichtlich.
Die Reihenfolge aller Optionen ist beliebig.

Benötigt ein GRETL-Job Zugriff auf Datenbanken,
können für die Entwicklung lokal Umgebungsvariablen
nach dem folgenden Muster gesetzt werden;
sie werden vom Skript `start-gretl.sh` dem GRETL-Container übergeben
und können im `build.gradle` als Variablen genutzt werden
(Namen siehe bei der Beschreibung von *build.gradle*):

```
export ORG_GRADLE_PROJECT_dbUriFoo=jdbc:postgresql://127.0.0.1/foodb
export ORG_GRADLE_PROJECT_dbUserFoo=foo
export ORG_GRADLE_PROJECT_dbPwdFoo=foopassword
export ORG_GRADLE_PROJECT_dbUriBar=jdbc:postgresql://localhost/bardb?sslmode=require
export ORG_GRADLE_PROJECT_dbUserBar=bar
export ORG_GRADLE_PROJECT_dbPwdBar=barpassword
export ORG_GRADLE_PROJECT_dbUriBaz=jdbc:postgresql://localhost:5432/bazdb?sslmode=require
export ORG_GRADLE_PROJECT_dbUserBaz=barbar
export ORG_GRADLE_PROJECT_dbPwdBaz=barbarpassword
```

Unter Ubuntu können diese Befehle in die Datei ~/.profile eingetragen werden, damit die Umgebungsvariablen immer verfügbar sind.


### Troubleshooting
Wenn folgende Fehlermeldung auftritt, muss das *.gradle* Ordner im Job Ordner gelöscht werden.

```
Caused by: java.io.FileNotFoundException: /home/gradle/project/.gradle/4.2.1/fileHashes/fileHashes.lock (Permission denied)
```
