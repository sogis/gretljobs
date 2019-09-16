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
  * `gretlShare`


### Files

Jeder GRETL-Job braucht im Minimum das File `build.gradle`. Bei Bedarf platziert man zudem ein File `job.properties` im Job-Ordner, um den Job in Jenkins zu konfigurieren. Falls der Job in Jenkins mit einem anderen Jenkinsfile als dem Standard-Jenkinsfile gestartet werden soll, muss sein spezifisches Jenkinsfile ebenfalls im Job-Ordner abgelegt werden.

#### `job.properties`
`job.properties` kann folgende Eigenschaften des GRETL-Jobs enthalten:

```java
logRotator.numToKeep=30
triggers.cron=H H(1-3) * * *
parameters.fileParam=filename.xtf
parameters.stringParam=parameterName;default value;parameter description
triggers.upstream=other_job_name
authorization.permissions=gretl-users-barpa
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


## GRETL Runtime Docker Image verwenden

Docker Image mit der GRETL runtime starten für die Job Entwicklung.

```
scripts/start-gretl.sh --docker-image sogis/gretl-runtime:latest --job-directory ~/gretljobs/jobname [taskName...] [--option-name...]
```

Bei [--option-name...] können beliebige Gradle-Optionen verwendet werden, auch z.B. `-Pmyprop=myvalue` und `-Dmyprop=myvalue`. Die Gradle-Optionen sind unter https://docs.gradle.org/current/userguide/command_line_interface.html beschrieben oder aus der Ausgabe des Befehls `gradle -h` ersichtlich. Die Reihenfolge aller Optionen ist beliebig.

Meistens benötigt ein GRETL-Job Zugriff auf Datenbanken. Hierfür können lokal für die Entwicklung von GRETL-Jobs folgende Umgebungsvariablen gesetzt werden (Werte entsprechend anpassen); sie werden von *start-gretl.sh* der GRETL Runtime als Parameter übergeben und können im GRETL-Skript als Variablen (Namen siehe bei der Beschreibung von *build.gradle*) genutzt werden:

```
export DB_URI_SOGIS=jdbc:postgresql://127.0.0.1/foodb
export DB_USER_SOGIS=foo
export DB_PWD_SOGIS=foopassword
export DB_URI_EDIT=jdbc:postgresql://localhost/bardb?ssl=true\&sslfactory=org.postgresql.ssl.NonValidatingFactory
export DB_USER_EDIT=bar
export DB_PWD_EDIT=barpassword
export DB_URI_PUB=jdbc:postgresql://localhost:5432/bazdb?ssl=true\&sslfactory=org.postgresql.ssl.NonValidatingFactory
export DB_USER_PUB=barbar
export DB_PWD_PUB=barbarpassword
```

Unter Ubuntu können diese Befehle in die Datei ~/.profile eingetragen werden, damit die Umgebungsvariablen immer verfügbar sind.


Oder das test Skript *test-gretl.sh* verwenden.

### Troubleshooting
Wenn folgende Fehlermeldung auftritt, muss das *.gradle* Ordner im Job Ordner gelöscht werden.

```
Caused by: java.io.FileNotFoundException: /home/gradle/project/.gradle/4.2.1/fileHashes/fileHashes.lock (Permission denied)
```
