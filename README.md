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

Jeder GRETL-Job braucht im Minimum das File `build.gradle`. Wenn er auch durch Jenkins gestartet werden soll, braucht er zusätzlich das File `gretl-job.groovy` und bei Bedarf das File `job.properties`.

#### `gretl-job.groovy`
`gretl-job.groovy` hat in der Regel folgenden Inhalt:

```groovy
def gretlShare = 'none'
def dbUriSogis = ''
def dbCredentialNameSogis = ''
def dbUriEdit = ''
def dbCredentialNameEdit = ''
def dbUriPub = ''
def dbCredentialNamePub = ''
def gretljobsRepo = ''

node("master") {
    gretlShare = "${env.GRETL_SHARE}"
    dbUriSogis = "${env.DB_URI_SOGIS}"
    dbCredentialNameSogis = "${DB_CREDENTIAL_GRETL}"
    dbUriEdit = "${env.DB_URI_EDIT}"
    dbCredentialNameEdit = "${DB_CREDENTIAL_GRETL}"
    dbUriPub = "${env.DB_URI_PUB}"
    dbCredentialNamePub = "${DB_CREDENTIAL_GRETL}"
    gretljobsRepo = "${env.GRETL_JOB_REPO_URL}"
}

node ("gretl") {
    gitBranch = "${params.BRANCH ?: 'master'}"
    git url: "${gretljobsRepo}", branch: gitBranch
    dir(env.JOB_BASE_NAME) {
        withCredentials([usernamePassword(credentialsId: "${dbCredentialNameSogis}", usernameVariable: 'dbUserSogis', passwordVariable: 'dbPwdSogis'), usernamePassword(credentialsId: "${dbCredentialNameEdit}", usernameVariable: 'dbUserEdit', passwordVariable: 'dbPwdEdit'), usernamePassword(credentialsId: "${dbCredentialNamePub}", usernameVariable: 'dbUserPub', passwordVariable: 'dbPwdPub')]) {
            sh "gradle --init-script /home/gradle/init.gradle \
                -PgretlShare='${gretlShare}' \
                -PdbUriSogis='${dbUriSogis}' -PdbUserSogis='${dbUserSogis}' -PdbPwdSogis='${dbPwdSogis}' \
                -PdbUriEdit='${dbUriEdit}' -PdbUserEdit='${dbUserEdit}' -PdbPwdEdit='${dbPwdEdit}' \
                -PdbUriPub='${dbUriPub}' -PdbUserPub='${dbUserPub}' -PdbPwdPub='${dbPwdPub}'"
        }
    }
}
```

#### `job.properties`
`job.properties` kann folgende Eigenschaften des GRETL-Jobs enthalten:

```java
logRotator.numToKeep=30
triggers.cron=H H(1-3) * * *
authorization.permissions=gretl-users-barpa
```

Mit `logRotator.numToKeep` kann eingestellt werden, wieviele Ausführungen des Jobs aufbewahrt werden sollen, d.h. für wieviele Ausführungen beispielsweise das Logfile vorgehalten wird. Standardwert ist 15. Wenn man diese Einstellung weglässt, werden also die 15 letzten Ausführungen aufbewahrt.

Mit `triggers.cron` kann eingestellt werden, zu welchem Zeitpunkt der Job automatisch gestartet werden soll. Im Beispiel `H H(1-3) * * *` wird der Job jeden Tag irgendwann zwischen 01:00 Uhr und 03:59 Uhr ausgeführt. (Dokumentation der Schreibweise siehe https://github.com/jenkinsci/jenkins/blob/master/core/src/main/resources/hudson/triggers/TimerTrigger/help-spec.jelly). Wenn man diese Einstellung weglässt, wird der Job nie automatisch gestartet, und er muss manuell gestartet werden.

Mit `authorization.permissions` kann angegeben werden, welcher Benutzer oder welche Benutzergruppe den Job manuell starten darf. Allerdings können auch diejenigen Benutzer oder Gruppen, welche durch globale Berechtigungseinstellungen in Jenkins dazu bereichtigt sind, den Job starten. Wenn man diese Einstellung weglässt, ist es von den globalen Berechtigungseinstellungen abhängig, wer den Job manuell starten darf.


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
