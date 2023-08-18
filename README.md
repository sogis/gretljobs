# gretljobs

Enthält sämtliche Konfigurationsdateien (`build.gradle`, `*.sql`)
der GRETL-Jobs
und eine GRETL-Job-Entwicklungsumgebung.
Umfasst zudem das Job DSL Script `gretl_job_generator.groovy`
für den *gretl-job-generator* Job in Jenkins,
der in regelmässigen Abständen das *gretljobs*-Repository durchsucht
und daraus entsprechende Jenkins-Pipelines generiert
und ihnen das `Jenkinsfile` zuweist.

## Funktionsweise in Jenkins

In Jenkins besteht zu Beginn nur ein Job *gretl-job-generator*; das Skript, das er ausführt, ist `gretl_job_generator.groovy`. Er checkt in regelmässigen Abständen das *gretljobs*-Repository aus und sucht in allen Ordnern (konfigurierbar) nach Skripten mit Name `build.gradle` (konfigurierbar).

Wenn er ein solches findet, legt er einen Job an und definiert das Skript in der Datei `Jenkinsfile` als Code, den der Job ausführen soll. Falls der *gretl-job-generator* im Ordner des gerade anzulegenden Jobs neben `build.gradle` auch eine eigene Datei mit Namen `Jenkinsfile` findet, definiert er als Code für den Job statt des zentralen Jenkinsfiles den Inhalt dieses jobspezifischen Jenkinsfiles (Übersteuerbarkeit). Zudem weist der *gretl-job-generator* optional dem Job folgende Eigenschaften zu:

* Wer den Job starten darf
* Wieviele Ausführungen eines Jobs aufbewahrt werden sollen
* Ob bei Start des Jobs eine Datei hochgeladen werden muss
* Ob der Job nach Ausführung eines anderen Jobs gestartet werden soll
* Ob der Job in regelmässigen Zeitintervallen gestartet werden soll

Wenn ein GRETL-Job gestartet wird, ermittelt das zugewiesene Skript alle benötigten Parameter und Benutzernamen für den Zugriff auf DBs und andere externe Ressourcen und führt mit Gradle das Skript `build.gradle`, das im entsprechenden Job-Verzeichnis liegt, aus.

### Job starten, der in einem Branch vorliegt

Wenn man einen bereits **bestehenden Job** bearbeiten möchte,
erstellt man hierfür lokal einen separaten Branch
und pusht diesen Branch auf GitHub, wenn die Änderungen umgesetzt sind.
Im GRETL-Jenkins der Testumgebung und der Integrationsumgebung
kann man direkt nach dem Start des Jobs den Namen dieses Branches angeben
und so prüfen, ob die Änderungen wie gewünscht funktionieren.
Allenfalls noch erforderliche Anpassungen
kann man im gleichen Branch vornehmen und sie wieder pushen, usw.

Bei einem **neuen Job**, der also noch nicht im _main_-Branch,
sondern erst in einem anderen Branch vorliegt, ist das Vorgehen ähnlich;
man muss aber zuerst gemäss folgender Anleitung auch im _main_-Branch
den entsprechenden Job-Ordner und eine leere Datei _build.gradle_ anlegen,
damit der Job bereits in GRETL-Jenkins aufgelistet wird:

* Den Job wie gehabt lokal in einem Branch entwickeln und den Branch pushen
* Lokal in den _main_-Branch wechseln und den aktuellen Stand pullen:
  ```
  git checkout main && git pull
  ```
* Auch in diesem Branch einen Ordner mit demselben Namen wie der neue Job anlegen:
  ```
  mkdir my_new_job
  ```
* In diesem Ordner eine leere Datei _build.gradle_ anlegen:
  ```
  touch my_new_job/build.gradle
  ```
* Die leere Datei stagen und committen:
  ```
  git add my_new_job/build.gradle && git commit -m "[my_new_job] Initialisierung Job-Verzeichnis"
  ```
* Diesen "Job-Initialisierungs-Commit" pushen:
  ```
  git push origin main
  ```
* In GRETL-Jenkins z.B. der Testumgebung
  den Job _gretl-job-generator_ einmal laufenlassen

Nun wird der Job in GRETL-Jenkins der Testumgebung aufgelistet,
und man kann wie gewohnt nach dem Start den Branch auswählen,
in welchem man den neuen Job entwickelt hat.

## Best Practice für das Erstellen von Jobs

* Für jeden neuen Job oder für jede Änderung an einem Job muss ein neuer Entwicklungsbranch erstellt werden:

```
git checkout -b branchname
```

* Änderungen müssen immer per Pull Request in den main-Branch eingepflegt werden

### build.gradle

* `import`-Statements zuoberst einfügen
* Danach das `apply plugin`-Statement einfügen
* Als DB-User bei AGI-Datenbanken `gretl`, bei den Entwicklungs-Datenbanken `dmluser` verwenden.
* Als (temporäres) Verzeichnis beim Herunterladen von Dateien etc. ```System.getProperty("java.io.tmpdir")``` verwenden. Dies ist das temp-Verzeichnis des Betriebssystems. Heruntergeladene und temporäre Dateien bitte trotzdem mittels abschliessenden Task wieder löschen.
* Immer mindestens einen DefaultTask setzen mit dem das Skript startet. Dadurch muss kein Task beim Aufruf von GRETL mitgegeben werden (Bsp ```defaultTasks 'transferAgiHoheitsgrenzen'```).
* `println` einsetzen wo sinnvoll, also informativ.
* `description` für Projekt und Tasks machen (Beispiel `av_mopublic/build.gradle`).
* In den `SELECT`-Statements kein `SELECT *` verwenden, sondern die Spalten explizit aufführen.
* Pfade nicht im Unix Style, sondern im mittels Java-Methoden Betriebssystem unabhängig angeben: ```Paths.get("var","www","maps")``` oder ```Paths.get("var/www/maps")```.
* Pro Tabelle sollte eine SQL-Datei verwendet werden.
* Bitte an den AGI SQL-Richtlinien orientieren.
* Variablen mit `def` definieren und nicht mit `ext{}`
* Für den Zugriff auf Datenbanken und andere Ressourcen folgende Variablen verwenden:
  * `dbUriEdit`, `dbUserEdit`, `dbPwdEdit`
  * `dbUriPub`, `dbUserPub`, `dbPwdPub`
  * `dbUriOereb`, `dbUserOereb`, `dbPwdOereb`
  * `dbUriOerebV2`, `dbUserOerebV2`, `dbPwdOerebV2`
  * `dbUriSimi`, `dbUserSimi`, `dbPwdSimi`
  * `dbUriSogis`, `dbUserSogis`, `dbPwdSogis`
  * `dbUriVerisoNplso`, `dbUserVerisoNplso`, `dbPwdVerisoNplso`
  * `dbUriAltlast4web`, `dbUserAltlast4web`, `PdbPwdAltlast4web`
  * `dbUriKaso`, `dbUserKaso`, `dbPwdKaso`
  * `dbUriCapitastra`, `dbUserCapitastra`, `dbPwdCapitastra`
  * `digiplanUser`, `digiplanPwd`
  * `efjServicesUrl`
  * `ftpUserEmapis`, `ftpPwdEmapis`
  * `ftpServerFledermaus`, `ftpUserFledermaus`, `ftpPwdFledermaus`
  * `ftpServerInfogrips`, `ftpUserInfogrips`, `ftpPwdInfogrips`
  * `ftpServerWaldportal`, `ftpUserWaldportal`, `ftpPwdWaldportal`
  * `ftpServerZivilschutz`, `ftpUserZivilschutz`, `ftpPwdZivilschutz`
  * `sftpServerGelan`, `sftpUserGelan`, `sftpPwdGelan`
  * `sftpServerSogis`, `sftpUserSogis`, `sftpPwdSogis`
  * für Datentransfer Gemdat: `host = sftpServerSogis`, `user = sftpUserSogisGemdat`, `identity = file('/home/gradle/.sshkeys/id_rsa')`
  * `aiServer`, `aiUser`, `aiPwd`
  * `infofloraUser`, `infofloraPwd`
  * `igelToken`
  * `afuAbbaustellenAppXtfUrl` (die komplette URL zum XTF-Dokument, inkl. Token)
  * `awsAccessKeyAda`, `awsSecretAccessKeyAda`
  * `awsAccessKeyAfu`, `awsSecretAccessKeyAfu`
  * `awsAccessKeyAgi`, `awsSecretAccessKeyAgi`
  * `geoservicesHostName` (der Wert dieser Variable ist je nach Umgebung `geo-t.so.ch`, `geo-i.so.ch` oder `geo.so.ch`)
  * `simiMetadataServiceUrl`, `simiMetadataServiceUser`, `simiMetadataServicePwd`
  * `simiTokenServiceUrl`, `simiTokenServiceUser`, `simiTokenServicePwd`
  * `solrIndexupdaterBaseUrl` (die interne Basis-URL zum Indexupdater für Solr)
  * `gretlEnvironment` (der Wert dieser Variable ist je nach Umgebung `test`, `integration` oder `production`)

  Die Anleitung, wie man solche Ressourcen (z.B. DB-Verbindungen)
  in Jenkins definiert oder bestehende Ressourcen bearbeitet,
  ist unter
  https://github.com/sogis/gretl/tree/master/openshift#create-or-update-resources-to-be-used-by-gretl.
  Die Anleitung, wie man neue Credentials anlegt oder bestehende bearbeitet,
  ist unter
  https://github.com/sogis/gretl/tree/master/openshift#create-or-update-secrets-to-be-used-by-gretl.
* Bei _IliValidator_-Tasks und _Ili2gpkgImport_-Tasks die folgende Option setzen,
  damit in den Betriebs-Umgebungen für den Download der benötigten Modelle
  die Anzahl abzufragender INTERLIS-Repositories reduziert wird:

  `if (findProperty('ilivalidatorModeldir')) modeldir = ilivalidatorModeldir`

  (Falls das Modell durch einen vorgängigen Schema-Import (`--schemaimport`)
  allerdings bereits in der GeoPackage-Datei enthalten sein sollte,
  muss die `modeldir`-Option nicht gesetzt werden,
  weil _ili2gpkgImport_ dann das Modell im GeoPackage findet
  und also nicht online danach suchen muss.)

  Beispiele:
  https://github.com/sogis/gretljobs/blob/eb6f40ffb9c9ec3e41c2d46220780636a65db7e0/agi_mopublic_pub_export/build.gradle#L62,
  https://github.com/sogis/gretljobs/blob/eb6f40ffb9c9ec3e41c2d46220780636a65db7e0/agi_mopublic_pub_export/build.gradle#L79

### Files

Jeder GRETL-Job braucht im Minimum das File `build.gradle`.
Bei Bedarf platziert man zudem ein File `job.properties` im Job-Ordner,
um den Job in Jenkins zu konfigurieren.
Ebenfalls optional kann eine Datei `gradle.properties`
im Job-Ordner platziert werden,
um Properties für den Gradle-Prozess zu setzen.
Falls der Job in Jenkins mit einem anderen `Jenkinsfile`
als dem Standard-Jenkinsfile gestartet werden soll,
muss sein spezifisches Jenkinsfile ebenfalls im Job-Ordner abgelegt werden.

#### `job.properties`

Die Datei `job.properties` kann folgende Eigenschaften des GRETL-Jobs enthalten:

```java
logRotator.numToKeep=30
triggers.cron=H H(1-3) * * *
parameters.fileParam=filename.xtf
parameters.stringParams=parameterName;default value;parameter description
triggers.upstream=other_job_name
authorization.permissions=gretl-users-barpa
nodeLabel=gretl-bigtmp
```

Mit `logRotator.numToKeep` kann eingestellt werden, wieviele Ausführungen des Jobs aufbewahrt werden sollen, d.h. für wieviele Ausführungen beispielsweise das Logfile vorgehalten wird. Standardwert ist 15. Wenn man diese Einstellung weglässt, werden also die 15 letzten Ausführungen aufbewahrt.
Falls man alle Ausführungen aufbewahren möchte, kann man hier den Wert `unlimited` setzen.

Mit `triggers.cron` kann eingestellt werden, zu welchem Zeitpunkt der Job automatisch gestartet werden soll. Im Beispiel `H H(1-3) * * *` wird der Job jeden Tag irgendwann zwischen 01:00 Uhr und 03:59 Uhr ausgeführt. (Dokumentation der Schreibweise siehe https://github.com/jenkinsci/jenkins/blob/master/core/src/main/resources/hudson/triggers/TimerTrigger/help-spec.jelly). Wenn man diese Einstellung weglässt, wird der Job nie automatisch gestartet, und er muss manuell gestartet werden.

Mit `parameters.fileParam` kann erreicht werden, dass ein  Benutzer beim Starten des Jobs eine Datei hochladen muss, die dann vom GRETL-Job verarbeitet wird. Es wird ein Dateiname (z.B. `filename.xtf`) oder Pfad (z.B. `data/filename.xtf`) verlangt, mit welchem im GRETL-Job auf die Datei zugegriffen werden kann.

Mit `parameters.stringParams` können Parameter definiert werden,
für welche der Benutzer beim manuellen Start des Jobs Werte übergeben kann.
Im Jenkinsfile kann Über den gesetzten Parameternamen (`parameterName`)
auf den Wert des Parameters zugegriffen werden.
Im obigen Beispiel wird ein String-Parameter mit Name `parameterName` definiert,
dessen Standarwert `default value` ist
und für den dem Benutzer neben dem Eingabefeld
die Beschreibung `parameter description` angezeigt wird.
Die drei Werte müssen mit Strichpunkt voneinander getrennt werden.
Innerhalb der Werte dürfen deshalb keine Strichpunkte vorkommen
(und auch nicht das Zeichen `@`).
Für den Standardwert und die Beschreibung sind Leerschläge zugelassen.
Es ist auch möglich, mehrere String-Parameter zu definieren.
Sie müssen mit dem Zeichen `@` voneinander getrennt werden.
Für die bessere Lesbarkeit ist es ratsam,
jeden String-Parameter auf einer eigenen Zeile zu definieren;
hierzu wird ein Backslash am Ende der vorangehenden Zeile benötigt.
Beispiel:

```java
parameters.stringParams=bfsnr;0000;BFS-Nr. der Gemeinde welche publiziert werden soll.@\
                        buildDescription;Keine Beschreibung angegeben;Beschreibung/Grund für die Publikation der Daten
```

Mit `triggers.upstream` kann eingestellt werden, dass der Job immer dann ausgeführt werden soll, wenn ein bestimmter anderer Job erfolgreich ausgeführt worden ist. Es können hier auch mehrere Jobs angegeben werden, jeweils durch Komma und Leerschlag voneinander getrennt (z.B. `other_job_name_1, other_job_name_2`).

Mit `authorization.permissions` kann angegeben werden, welcher Benutzer oder welche Benutzergruppe den Job manuell starten darf.
Mehrere Benutzer oder Gruppen
können mit Komma getrennt aneinandergereiht werden.
Folgende GRETL-spezifischen Benutzergruppen stehen im Moment zur Verfügung:

* gretl-users-barpa (ARP)
* gretl-users-bdafu (AfU)
* gretl-users-bvtaa (AVT)
* gretl-users-edden (ADA)
* gretl-users-vkfaa (AWJF)
* gretl-users-vlwaa (ALW)

Allerdings können auch diejenigen Benutzer oder Gruppen, welche durch globale Berechtigungseinstellungen in Jenkins dazu bereichtigt sind, den Job starten. Wenn man diese Einstellung weglässt, ist es von den globalen Berechtigungseinstellungen abhängig, wer den Job manuell starten darf.

Mit `nodeLabel` kann bestimmt werden,
auf welchem Node der Job ausgeführt werden soll.
Erlaubt ist hier der Wert `gretl-bigtmp`
damit der Job auf einem Jenkins Agent
mit einem grösseren `/tmp`-Verzeichnis ausgeführt wird.
Und der Wert `gretl-2.2`,
damit der Job auf einem Jenkins Agent
mit GRETL Version 2.2 ausgeführt wird.
(Im Moment zeigt allerdings auch der normale Jenkins Agent
auf Version 2.2; es gibt also keinen Unterschied.)
Lässt man diese Property weg,
wird der Job auf dem normalen Jenkins Agent
(mit dem Label `gretl`) ausgeführt.

#### `gradle.properties`

Die Datei `gradle.properties` kann z.B. dazu benutzt werden,
dem Job mehr Heap Space (gewissermassen mehr RAM) zur Verfügung zu stellen.
Um ihm z.B. bis zu 2GB zuzuweisen,
muss `gradle.properties` die folgende Zeile enthalten:

```
org.gradle.jvmargs=-Xmx2048m
```

Weitere mögliche Optionen sind unter
https://docs.gradle.org/current/userguide/build_environment.html
dokumentiert.

#### `Jenkinsfile`

Das Jenkinsfile sorgt dafür,
dass ein GRETL-Job aus Jenkins heraus gestartet werden kann.
In der Regel braucht ein GRETL-Job kein eigenes Jenkinsfile,
denn es kommt standardmässig
das "zentrale" [Jenkinsfile](Jenkinsfile) zum Einsatz.

In speziellen Fällen benötigen GRETL-Jobs ein eigenes Jenkinsfile;
hierzu kopiert man das Jenkinsfile eines bereits bestehenden, ähnlichen Jobs
in den GRETL-Job-Ordner.
Es soll dabei nicht verändert oder möglichst nur minimal angepasst werden,
damit alle Jenkinsfiles soweit möglich identisch sind.

Die speziellen Fälle und die jeweiligen Vorlagen sind in [jenkinsfile_docs.md](jenkinsfile_docs.md) beschrieben.


## GRETL Docker Image verwenden

Für die Entwicklung von GRETL-Jobs
kann GRETL mit `docker compose` als Docker-Container gestartet werden.

Hierfür müssen zunächst die Verbindungsparameter zu den DBs
und andere benötigte Variablen konfiguriert werden.
Diese platziert man in einer Datei `gretljobs.properties`
in seinem Home-Verzeichnis.
Der Inhalt der Datei sieht z.B. so aus:

```
dbUriEdit=jdbc:postgresql://edit-db/edit
dbUserEdit=dmluser
dbPwdEdit=dmluser
dbUriPub=jdbc:postgresql://pub-db/pub
dbUserPub=dmluser
dbPwdPub=dmluser
```

### Entwicklungs-DBs starten
Falls man sie benötigt, startet man zunächst zwei DB-Container;
einer enthält eine *edit*-DB, der andere eine *pub*-DB:
```
docker compose up -d
```

### Schema-Job ausführen
Nun legt man in diesen DBs die benötigten Schemas an
und importiert nach Bedarf Daten,
z.B. mit *ili2pg*, durch Ausführen eines Schema-Jobs,
durch Ausführen von SQL-Skripten oder durch Restoren aus einem Dump.

Schema-Jobs kann man ebenfalls mit `docker compose`
entweder aus dem vorliegenden Verzeichnis heraus
oder aus dem Verzeichnis `schema-jobs` heraus ausführen.
Voraussetzung ist, dass das Repository *schema-jobs*
in einem Ordner mit Name `schema-jobs` vorliegt;
dieser muss sich auf derselben Ordner-Hierarchiestufe
wie der Ordner mit den GRETL-Jobs befinden.

Ein Schema-Job kann mit folgendem Befehl
aus dem `schema-jobs`-Verzeichnis heraus gestartet werden:
```
docker compose -f ../gretljobs/docker-compose.yml run --rm -u $UID --workdir //home/gradle/schema-jobs/shared/schema \
  gretl -PtopicName=MY_TOPIC_NAME -PschemaDirName=MY_SCHEMA_DIRECTORY_NAME [-PdbName=MY_DB_NAME] [OPTION...] [TASK...]
```
Beispiel:
```
docker compose -f ../gretljobs/docker-compose.yml run --rm -u $UID --workdir //home/gradle/schema-jobs/shared/schema \
  gretl -PtopicName=agi_mopublic -PschemaDirName=schema_pub --console=rich createSchema configureSchema
```

Oder er kann mit folgendem Befehl
aus dem `gretljobs`-Verzeichnis heraus gestartet werden:
```
docker compose run --rm -u $UID --workdir //home/gradle/schema-jobs/shared/schema \
  gretl -PtopicName=MY_TOPIC_NAME -PschemaDirName=MY_SCHEMA_DIRECTORY_NAME [-PdbName=MY_DB_NAME] [OPTION...] [TASK...]
```
Beispiel:
```
docker compose run --rm -u $UID --workdir //home/gradle/schema-jobs/shared/schema \
  gretl -PtopicName=agi_mopublic -PschemaDirName=schema_pub --console=rich createSchema configureSchema
```


`MY_TOPIC_NAME` muss durch den Namen des Topics (den Ordnernamen)
und `MY_SCHEMA_DIRECTORY_NAME` durch den Namen des Unterordners,
in welchem die Schema-Eigenschaften definiert sind,
ersetzt werden.

Die Option `-PdbName=MY_DB_NAME` ist nur in Ausnahmefällen nötig,
z.B. wenn das Schema in einer anderen DB angelegt werden soll,
als in der Datei `schema.properties` definiert ist.

Mit `[OPTION...]` (optional) können beliebige Gradle-Optionen übergeben werden,
auch z.B. `-Pmyprop=myvalue` und `-Dmyprop=myvalue`.
Die Gradle-Optionen sind unter
https://docs.gradle.org/current/userguide/command_line_interface.html
beschrieben oder aus der Ausgabe des Befehls `gradle -h` ersichtlich.

Mit `[TASK...]` (optional) kann ein oder mehrere Tasks angegeben werden,
die von GRETL ausgeführt werden sollen, z.B. `dropSchema createSchema configureSchema`

### GRETL-Job ausführen
Der GRETL-Job wird mit folgendem Befehl gestartet:
```
docker compose run --rm -u $UID gretl --project-dir=MY_JOB_NAME [OPTION...] [TASK...]
```

`MY_JOB_NAME` muss durch den Namen des auszuführenden GRETL-Jobs
(den Ordnernamen) ersetzt werden.

Mit `[OPTION...]` (optional) können beliebige Gradle-Optionen übergeben werden,
auch z.B. `-Pmyprop=myvalue` und `-Dmyprop=myvalue`.

Mit `[TASK...]` (optional) kann ein oder mehrere Tasks angegeben werden,
die von GRETL ausgeführt werden sollen.
Falls man nichts angibt,
werden die allenfalls in `build.gradle` definierten `defaultTasks` ausgeführt.

### Entwicklungs-DBs stoppen
Die Entwicklungs-DB stoppt man mit
```
docker compose down
```

### Hinweise zu den DB-Containern
#### Daten in den DBs löschen
Die Daten in den DBs bleiben auch
nach `docker-compose stop` oder `docker-compose down` erhalten.
Falls man mit leeren DBs neu starten möchte,
löscht man (nach dem Stoppen der DB-Container) deren Volumes
mit folgendem Befehl:
```
docker volume prune --all --filter 'label=com.docker.compose.project=gretljobs'
```
(Wobei der *Value* des Labels nicht zwingend immer *gretljobs* ist,
sondern vom Verzeichnisnamen abhängt, in welchem `docker-compose.yml` liegt;
man kann ihn durch `docker volume inspect VOLUMENAME` herausfinden.)

#### Verbindungsparameter für die DBs
Die DBs sind mit folgenden Verbindungsparametern erreichbar:

*Edit-DB:*
* Hostname: `localhost`
* Port: `54321`
* DB-Name: `edit`
* Benutzer: `ddluser` (zum Anlegen von Schemen, Tabellen usw.) bzw. `dmluser` (für Lese- und Schreibzugriff); das Passwort lautet jeweils gleich wie der Benutzername

*Publikations-DB:*
* Hostname: `localhost`
* Port: `54322`
* DB-Name: `pub`
* Benutzer: `ddluser` (zum Anlegen von Schemen, Tabellen usw.) bzw. `dmluser` (für Lese- und Schreibzugriff); das Passwort lautet jeweils gleich wie der Benutzername

#### Die Rollen (Benutzer und Gruppen) der produktiven DBs importieren

Um auch die in den produktiven DBs vorhandenen DB-Rollen
in den Entwicklungs-DBs verfügbar zu haben,
kopiert man die Datei mit den DB-Rollen (die "Globals")
vom geoutil-Server auf seine lokale Maschine,
entfernt mit einem `sed`-Befehl diejenigen Zeilen,
die für die Entwicklungs-DBs nicht nötig sind,
und importiert sie dann mit `psql` in die Entwicklungs-DBs:
```
scp geoutil.verw.rootso.org:/opt/workspace/dbdump/globals_geodb.rootso.org.dmp /tmp
sed -E -i.bak '/^CREATE ROLE (postgres|admin)\;/d; /^ALTER ROLE (postgres|admin) /d' /tmp/globals_geodb.rootso.org.dmp
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

### Troubleshooting
Wenn folgende Fehlermeldung auftritt, muss das *.gradle* Ordner im Job Ordner gelöscht werden.

```
Caused by: java.io.FileNotFoundException: /home/gradle/project/.gradle/4.2.1/fileHashes/fileHashes.lock (Permission denied)
```
