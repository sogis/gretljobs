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
* `t_id` in aller Regel nicht von einem Schema in das andere übertragen (Typicherweise Edit-DB -> Pub-DB), damit diese sauber über die Sequenz im Zielschema vergeben wird.
* Variablen mit `def` definieren und nicht mit `ext{}`

#### Zugriff auf Ressourcen

Für den Zugriff auf Datenbanken und andere Ressourcen sollen die Variablen gemäss der folgenden Auflistung verwendet werden. (Die Variablenwerte, die in dieser Auflistung angegeben sind, dienen für die Entwicklung von GRETL-Jobs auf der lokalen Maschine mit Docker Compose.)
```properties
# DBs
dbUriEdit=jdbc:postgresql://edit-db/edit
dbUserEdit=dmluser
dbPwdEdit=dmluser
dbUriPub=jdbc:postgresql://pub-db/pub
dbUserPub=dmluser
dbPwdPub=dmluser
dbUriOerebV2=jdbc:postgresql://oereb_v2-db/oereb_v2
dbUserOerebV2=dmluser
dbPwdOerebV2=dmluser
dbUriSimi=
dbUserSimi=
dbPwdSimi=
dbUriIsboden=
dbUserIsboden=
dbPwdIsboden=
dbUriVerisoNplso=
dbUserVerisoNplso=
dbPwdVerisoNplso=
dbUriAltlast4web=
dbUserAltlast4web=
PdbPwdAltlast4web=
dbUriKaso=
dbUserKaso=
dbPwdKaso=
dbUriCapitastra=
dbUserCapitastra=
dbPwdCapitastra=
dbUriEws=
dbUserEws=
dbPwdEws=
dbUriImdaspro=
dbUserImdaspro=
dbPwdImdaspro=

# FTP- und SFTP-Server
ftpUserEmapis=
ftpPwdEmapis=
ftpServerFledermaus=
ftpUserFledermaus=
ftpPwdFledermaus=
ftpServerInfogrips=
ftpUserInfogrips=
ftpPwdInfogrips=
ftpServerWaldportal=
ftpUserWaldportal=
ftpPwdWaldportal=
sftpServerGelan=
sftpUserGelan=
sftpPwdGelan=
sftpServerSEinApp=
sftpUserSEinApp=
# sftpPwdSEinApp gibt es nicht, dafür einen SSH-Key unter /home/gradle/.ssh/id_rsa; siehe Hinweis unterhalb dieser Auflistung
sftpServerSogis=
sftpUrlSogis=build
sftpUserSogis=
sftpPwdSogis=
sftpUserSogisGemdat=
# sftpPwdSogisGemdat gibt es nicht, dafür einen SSH-Key unter /home/gradle/.ssh/id_rsa; siehe Hinweis unterhalb dieser Auflistung
sftpServerZivilschutz=
sftpUserZivilschutz=
sftpPwdZivilschutz=

# Andere Ressourcen
afuAbbaustellenAppXtfUrl=
aiServer=
aiUser=
aiPwd=
awsAccessKeyAda=
awsSecretAccessKeyAda=
awsAccessKeyAfu=
awsSecretAccessKeyAfu=
awsAccessKeyAgi=
awsSecretAccessKeyAgi=
digiplanUrl=
digiplanUser=
digiplanPwd=
efjServicesUrl=
igelToken=
neophytenClientId=
neophytenClientSecret=
simiMetadataServiceUrl=
simiMetadataServiceUser=
simiMetadataServicePwd=
simiTokenServiceUrl=
simiTokenServiceUser=
simiTokenServicePwd=
# Der Wert von solrIndexupdaterBaseUrl ist die interne Basis-URL zum Indexupdater für Solr:
solrIndexupdaterBaseUrl=

# Diverse Variablen
dbSearchSchemaPub=
# Der Wert von geoservicesHostName ist je nach Umgebung "geo-t.so.ch", "geo-i.so.ch" oder "geo.so.ch":
geoservicesHostName=geo-t.so.ch
# Der Wert von gretlEnvironment ist je nach Umgebung "test", "integration" oder "production":
gretlEnvironment=
ilivalidatorModeldir=%ITF_DIR;https://geo.so.ch/models/;%JAR_DIR/ilimodels

# Folgende Variablen dürfen in GRETL-Jobs nicht verwendet werden.
# Sie werden aber lokal benötigt, damit dort auch die Schema-Jobs funktionieren.
dbUserEditDdl=ddluser
dbPwdEditDdl=ddluser
dbUserPubDdl=ddluser
dbPwdPubDdl=ddluser
dbUserOerebV2Ddl=ddluser
dbPwdOerebV2Ddl=ddluser
```
Hinweise:
* Für den *Datentransfer SEinApp* muss man verwenden: `host = sftpServerSEinApp`, `user = sftpUserSEinApp`, `identity = file('/home/gradle/.ssh/id_rsa')`; der SSH-Key kann im Docker Container verfügbar gemacht werden, indem man den Befehl `docker compose run` (s. weiter unten) mit der Option `-v /local/path/to/id_rsa:/home/gradle/.ssh/id_rsa` ergänzt
* Für den *Datentransfer Gemdat* muss man verwenden: `host = sftpServerSogis`, `user = sftpUserSogisGemdat`, `identity = file('/home/gradle/.ssh/id_rsa')`; der SSH-Key kann im Docker Container verfügbar gemacht werden, indem man den Befehl `docker compose run` (s. weiter unten) mit der Option `-v /local/path/to/id_rsa:/home/gradle/.ssh/id_rsa` ergänzt
* Die Anleitung, wie man solche Ressourcen (z.B. DB-Verbindungen) in Jenkins definiert oder bestehende Ressourcen bearbeitet, ist unter https://github.com/sogis/openshift-templates/blob/master/gretl/README.md#create-configmap
* Die Anleitung, wie man neue Credentials anlegt oder bestehende bearbeitet, ist unter https://github.com/sogis/openshift-templates/blob/master/gretl/README.md#create-secret

#### Verwendung der Variablen *ilivalidatorModeldir*

Bei _IliValidator_-Tasks und _Ili2gpkgImport_-Tasks soll die folgende Option gesetzt werden,
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
parameters.stashedFile=myfilename.xyz
parameters.stringParams=parameterName;default value;parameter description
triggers.upstream=other_job_name
authorization.permissions=gretl-users-barpa
```

Mit `logRotator.numToKeep` kann eingestellt werden, wieviele Ausführungen des Jobs aufbewahrt werden sollen, d.h. für wieviele Ausführungen beispielsweise das Logfile vorgehalten wird. Standardwert ist 15. Wenn man diese Einstellung weglässt, werden also die 15 letzten Ausführungen aufbewahrt.
Falls man alle Ausführungen aufbewahren möchte, kann man hier den Wert `unlimited` setzen.

Mit `triggers.cron` kann eingestellt werden, zu welchem Zeitpunkt der Job automatisch gestartet werden soll. Im Beispiel `H H(1-3) * * *` wird der Job jeden Tag irgendwann zwischen 01:00 Uhr und 03:59 Uhr ausgeführt. (Dokumentation der Schreibweise siehe https://github.com/jenkinsci/jenkins/blob/master/core/src/main/resources/hudson/triggers/TimerTrigger/help-spec.jelly). Wenn man diese Einstellung weglässt, wird der Job nie automatisch gestartet, und er muss manuell gestartet werden.

Mit `parameters.stashedFile` kann konfiguriert werden,
dass ein  Benutzer beim Starten des Jobs eine Datei hochladen muss.
Man muss hier einen Dateinamen (z.B. `data.xtf`) angeben;
unter diesem Dateinamen kann dann der GRETL-Job auf die Datei zugreifen.

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
* gretl-users-bdhba (HBA)
* gretl-users-bvtaa (AVT)
* gretl-users-edden (ADA)
* gretl-users-skkan (Staatskanzlei)
* gretl-users-vkfaa (AWJF)
* gretl-users-vlwaa (ALW)

Allerdings können auch diejenigen Benutzer oder Gruppen, welche durch globale Berechtigungseinstellungen in Jenkins dazu bereichtigt sind, den Job starten. Wenn man diese Einstellung weglässt, ist es von den globalen Berechtigungseinstellungen abhängig, wer den Job manuell starten darf.

Zudem kann mit der Eigenschaft `nodeLabel` bestimmt werden,
auf welchem Node der Job ausgeführt werden soll.
Möglich ist hier der Wert `gretl-3.1`,
damit der Job auf einem Jenkins Agent
mit GRETL Version 3.1 ausgeführt wird.
Diese Property dient primär dazu,
dass bei einem grösseren Versionssprung von GRETL
nicht alle Jobs gleichzeitig umgestellt werden müssen.
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

### Voraussetzungen

Damit die GRETL-Jobs auch lokal funktionieren, muss im lokalen Home-Verzeichnis die Datei `gretljobs.properties` vorhanden sein.
Sie enthält die verschiedenen Verbindungsparameter zu den lokalen Entwicklungs-DBs und andere benötigte Variablen.
Was in dieser Datei drinstehen muss, ist im Abschnitt [Zugriff auf Ressourcen](#zugriff-auf-ressourcen) ersichtlich (man kann diese Liste direkt kopieren).

### Entwicklungs-DBs nutzen

#### Entwicklungs-DBs starten
```
docker compose up -d
```
bzw.
```
COMPOSE_FILE=../gretljobs/docker-compose.yml docker compose up -d
```
Mit diesem Befehl werden zwei DB-Container gestartet,
von denen einer eine *edit*-DB, der andere eine *pub*-DB enthält.

Mit der ersten Variante des Befehls startet man die Entwicklungs-DBs,
wenn man sich im _gretljobs_-Verzeichnis befindet.
Mit der zweiten Variante startet man sie,
wenn man sich im _schema-jobs_-Verzeichnis befindet.

Auch die weiter unten in diesem Kapitel angegebenen Befehle
lassen sich auf diese Art
jeweils auch aus dem _schema-jobs_-Verzeichnis heraus ausführen.
Man muss in diesem Fall also dem Befehl
die Umgebungsvariable `COMPOSE_FILE` voranstellen
und so auf die Datei `docker-compose.yml` des Verzeichnis _gretljobs_ verweisen.

_Voraussetzung, damit dies funktioniert_:
Die Ordner _gretljobs_ und _schema-jobs_
müssen sich im gleichen übergeordneten Ordner befinden.

##### GRETL-Jobs, die eine DB für das Processing von Daten benötigen:
```
docker compose --profile processing up -d
```
So wird zusätzlich zur *edit*-DB und zur *pub*-DB
auch eine *processing*-DB gestartet
für GRETL-Jobs, die eine solche benötigen.

**Wichtig**: In diesem Fall müssen auch die nachfolgenden Compose-Befehle
jeweils mit der Option `--profile processing` aufgerufen werden,
damit sie auch die Processing-DB mit einschliessen.

#### Entwicklungs-DBs stoppen
```
docker compose stop
```
bzw.
```
COMPOSE_FILE=../gretljobs/docker-compose.yml docker compose stop
```
So werden die Entwicklungs-DB-Container gestoppt.
Die Daten der DBs bleiben erhalten,
da sie in Docker-Volumes gespeichert sind,
die hierbei nicht gelöscht werden.

#### Entwicklungs-DBs stoppen und DB-Container löschen
```
docker compose down
```
bzw.
```
COMPOSE_FILE=../gretljobs/docker-compose.yml docker compose down
```
Die Entwicklungs-DB-Container werden gestoppt, die DB-Container gelöscht
und zugleich auch das von Docker Compose angelegte Docker-Netzwerk gelöscht.
Die Daten der DBs bleiben aber auch in diesem Fall erhalten,
weil die Docker-Volumes nicht gelöscht werden.

#### Daten der Entwicklungs-DB-Container löschen
```
docker volume rm gretljobs_pgdata_edit gretljobs_pgdata_pub
```
bzw. für die Processing-DB
```
docker volume rm gretljobs_pgdata_processing
```
Mit diesem Befehl werden die Volumes der Entwicklungs-DB-Container
und damit die Daten in den Entwicklungs-DBs gelöscht.
(Die DB-Container müssen vorgängig mit dem Befehl `docker compose down`
ebenfalls gelöscht werden.)

#### Verbindungsparameter für die Entwicklungs-DBs
Die Entwicklungs-DBs sind z.B. aus _DBeaver_ oder _psql_
mit folgenden Verbindungsparametern erreichbar:

*Edit-DB:*
* Hostname: `localhost`
* Port: `54321`
* DB-Name: `edit`
* Benutzer mit DDL-Rechten: `ddluser` (zum Anlegen von Schemen, Tabellen usw.)
* Benutzer mit DML-Rechten: `dmluser` (für Lese- und Schreibzugriff)
* Passwörter: lauten jeweils gleich wie der Benutzername

*Publikations-DB:*
* Hostname: `localhost`
* Port: `54322`
* DB-Name: `pub`
* Benutzer mit DDL-Rechten: `ddluser` (zum Anlegen von Schemen, Tabellen usw.)
* Benutzer mit DML-Rechten: `dmluser` (für Lese- und Schreibzugriff)
* Passwörter: lauten jeweils gleich wie der Benutzername

*Processing-DB:*
* Hostname: `localhost`
* Port: `54323`
* DB-Name: `processing`
* Benutzer mit Superuser-Rechten: `processing`
* Passwort: lautet gleich wie der Benutzername

### GRETL-Job ausführen
```
docker compose run --rm -u $UID gretl --project-dir=MY_JOB_NAME [OPTION...] [TASK...]
```
bzw.
```
COMPOSE_FILE=../gretljobs/docker-compose.yml docker compose run --rm -u $UID gretl --project-dir=MY_JOB_NAME [OPTION...] [TASK...]
```
Dieser Befehl startet den GRETL-Job `MY_JOB_NAME`.

Beispiele:
```
docker compose run --rm -u $UID gretl --project-dir=arp_nutzungsplanung_pub
```
```
docker compose run --rm -u $UID gretl --project-dir=arp_nutzungsplanung_pub -Pbfsnr=2408 importXTF_stage
```

Erläuterungen:

* `MY_JOB_NAME` muss durch den Namen des auszuführenden GRETL-Jobs
  (den Ordnernamen) ersetzt werden.
* Mit `OPTION...` (optional) können beliebige Gradle-Optionen übergeben werden,
  z.B.: `--console=rich`, `-Pmyprop=myvalue`, `-Dmyprop=myvalue`.
  Dokumentation der Gradle-Optionen:
  https://docs.gradle.org/current/userguide/command_line_interface.html
* Mit `TASK...` (optional) kann ein oder mehrere Tasks angegeben werden,
  die von GRETL ausgeführt werden sollen;
  falls man nichts angibt,
  werden die in `build.gradle` definierten `defaultTasks` ausgeführt.
* Falls man einen GRETL-Job mit einem ganz bestimmten GRETL-Image-Tag (z.B. `latest`)
  ausführen möchte, stellt man dem Compose-Befehl
  die Variablendefinition `GRETL_IMAGE_TAG=MYTAG` voran, z.B.:
  ```
  GRETL_IMAGE_TAG=latest docker compose run --rm -u $UID gretl --project-dir=MY_JOB_NAME [OPTION...] [TASK...]
  ```
* Falls ein bestimmter Job Zugriff auf Daten in einem *Persistent Volume Claim* (PVC) benötigt, lässt sich dies lokal abbilden, indem man den Befehl mit einem *Volume Mount* (Option `-v ...`) gemäss folgendem Beispiel ergänzt:
  ```
  docker compose run --rm -u $UID -v /local/path:/work/datahub/DMAV_FixpunkteAVKategorie3_V1_0 gretl --project-dir=MY_JOB_NAME [OPTION...] [TASK...]
  ```
  (Mit Vorteil erstellt man das zu mountende lokale Verzeichnis (im Beispiel `/local/path`) bereits vor dem Ausführen des Befehls; andernfalls wird es zwar von Docker Compose automatisch angelegt, allerdings mit Schreibberechtigung nur für den User *root*.)

### Schema-Job ausführen
```
docker compose run --rm -u $UID --workdir //home/gradle/schema-jobs/shared/schema \
  gretl -PtopicName=MY_TOPIC_NAME -PschemaDirName=MY_SCHEMA_DIRECTORY_NAME [-PdbName=MY_DB_NAME] [OPTION...] TASK...
```
bzw.
```
COMPOSE_FILE=../gretljobs/docker-compose.yml docker compose run --rm -u $UID --workdir //home/gradle/schema-jobs/shared/schema \
  gretl -PtopicName=MY_TOPIC_NAME -PschemaDirName=MY_SCHEMA_DIRECTORY_NAME [-PdbName=MY_DB_NAME] [OPTION...] TASK...
```
Dieser Befehl startet den Schema-Job im Ordner `MY_TOPIC_NAME\MY_SCHEMA_DIRECTORY_NAME`.

_Voraussetzung_: Die Ordner _gretljobs_ und _schema-jobs_ müssen sich
im gleichen übergeordneten Ordner befinden.

Beispiel:
```
docker compose run --rm -u $UID --workdir //home/gradle/schema-jobs/shared/schema \
  gretl -PtopicName=agi_mopublic -PschemaDirName=schema_pub createSchema configureSchema
```
Beispiel für Start desselben Schema-Jobs aus dem _schema-jobs_-Verzeichnis heraus:
```
COMPOSE_FILE=../gretljobs/docker-compose.yml docker compose run --rm -u $UID --workdir //home/gradle/schema-jobs/shared/schema \
  gretl -PtopicName=agi_mopublic -PschemaDirName=schema_pub createSchema configureSchema
```


Erläuterungen:
* `MY_TOPIC_NAME` muss durch den Namen des Topics (den Ordnernamen)
  und `MY_SCHEMA_DIRECTORY_NAME` durch den Namen des Unterordners,
  in welchem die Schema-Eigenschaften definiert sind,
  ersetzt werden.
* Die Option `-PdbName=MY_DB_NAME` (optional) ist nur in Ausnahmefällen nötig,
  z.B. wenn das Schema in einer anderen DB angelegt werden soll,
  als in der Datei `schema.properties` definiert ist.
* Mit `OPTION...` (optional) können beliebige Gradle-Optionen übergeben werden,
  z.B.: `--console=rich`, `-Pmyprop=myvalue`, `-Dmyprop=myvalue`.
* Mit `TASK...` muss angegeben werden, welcher Task bzw. welche Tasks
  von GRETL ausgeführt werden sollen,
  z.B. `dropSchema` oder `createSchema configureSchema`.
* Der Task `configureSchema` setzt, wenn er lokal,
  d.h. in einer Development-Umgebung ausgeführt wird,
  gleichzeitig auch die Berechtigungen auf den DB-Schemen und Tabellen so,
  dass GRETL-Jobs auf diese Schemen zugreifen können (Lese- und Schreibrechte).
  Das heisst, dass lokal der Task `grantPrivileges`
  im Normalfall nicht ausgeführt werden muss.
* Falls man einen Schema-Job mit einem ganz bestimmten GRETL-Image-Tag (z.B. `latest`)
  ausführen möchte, stellt man dem Compose-Befehl
  die Variablendefinition `GRETL_IMAGE_TAG=MYTAG` voran, z.B.:
  ```
  GRETL_IMAGE_TAG=latest docker compose run --rm -u $UID --workdir //home/gradle/schema-jobs/shared/schema \
    gretl -PtopicName=MY_TOPIC_NAME -PschemaDirName=MY_SCHEMA_DIRECTORY_NAME [-PdbName=MY_DB_NAME] [OPTION...] TASK...
  ```

### Daten in die Entwicklungs-DBs importieren

#### Mittels dump restore

Beschreibung des Ablaufs siehe: [copy_schema_to_dev.md](copy_schema_to_dev.md)

#### Alternativ: Mittels Schema-Job Task importDevelopmentData

Wenn der Schema-Job entsprechend konfiguriert ist,
kann man unter bestimmten Bedingungen mit dem Task `importDevelopmentData`
automatisiert Daten in die Entwicklungs-DBs importieren.

Voraussetzungen:
* Die Daten müssen online unter https://files.geo.so.ch als .xtf verfügbar sein
* In der Datei `schema.properties` im Schema-Job
  muss die Property `data.themePublicationName` gesetzt sein
  (z.B. `data.themePublicationName = ch.so.arp.nutzungsplanung.kommunal`)
* Falls es sich um ein Schema handelt, das Datasets enthält,
  muss entweder in `schema.properties` auch die Property `data.dataSets` gesetzt sein
  (z.B. `data.dataSets = 2403,2405,2408`),
  oder man muss beim Ausführen des Tasks `importDevelopmentData`
  die Property `data.dataSets` übergeben, z.B. `-Pdata.dataSets=2403,2405,2408`.
  Sowohl in `schema.properties` als auch bei der Übergabe als Property beim Ausführen des Tasks
  ist auch der Wert `defaultDataSets` möglich (z.B. `-Pdata.dataSets=defaultDataSets`);
  hinter `defaultDataSets`
  sind die BFS-Nummern aller Gemeinden des Kantons Solothurn hinterlegt.

### Hinweise zu den DB-Containern
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
