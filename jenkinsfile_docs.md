# Dokumentation Jenkinsfile

Standardmässig verwenden die GRETL-Jobs das "zentrale" [Standard-Jenkinsfile](Jenkinsfile).
Bei speziellen Anforderungen kann man einem Job ein eigenes Jenkinsfile zuweisen, indem man es im Job-Ordner platziert.
In den folgenden Abschnitten sind solche Fälle aufgelistet.
Es ist jeweils aufgeführt, welches Jenkinsfile für einen ähnlichen Fall als Vorlage übernommen werden soll.
Es sollen möglichst wenige oder am besten gar keine Änderungen am übernommenen Jenkinsfile gemacht werden, damit die Jenkinsfiles weitgehend einheitlich bleiben.

## GRETL-Jobs mit File Upload

Vorlage: [xy_jenkinsfile_template_fileupload/Jenkinsfile](xy_jenkinsfile_template_fileupload/Jenkinsfile)

- Im Jenkinsfile muss die Umgebungsvariable `UPLOAD_FILE_NAME` auf den für die hochgeladene Datei zu verwendenden Namen gesetzt werden
- In `job.properties` muss die folgende Property gesetzt werden: `parameters.stashedFile=data.zip`; hier muss derselbe Dateiname verwendet werden
- Jeweils auch die entsprechende Dateiendung angeben (beispielsweise `xyz.csv`), damit die Benutzer sehen, welcher Dateityp hochgeladen werden soll

Mit dieser Konfiguration wird man beim Start des Jobs gefragt, welche Datei hochgeladen werden soll.
Das Jenkinsfile platziert die hochgeladene Datei im *Gradle Build Directory* im Unterordner `in`.
Bei der Weiterverarbeitung die Datei im `build.gradle` mit der Variablen `$buildDir` referenzieren.
Beispiele: `"$buildDir/in/data.zip"`, `buildDir + "/in/xyz.zip"`

## GRETL-Jobs mit File Upload, wobei der ursprüngliche Dateiname beibehalten werden soll

Vorlage: [xy_jenkinsfile_template_fileupload_origname/Jenkinsfile](xy_jenkinsfile_template_fileupload_origname/Jenkinsfile)

- Im Jenkinsfile muss die Umgebungsvariable `UPLOAD_FILE_NAME` auf den für die hochgeladene Datei initial zu verwendenden Namen gesetzt werden
- Zusätzlich muss die Umgebungsvariable `ORIGINAL_FILE_NAME` auf den Wert der Variablen `<gewählterDateiname>_FILENAME` gesetzt werden (die Variable heisst im Beispiel deshalb `data.zip_FILENAME`)
- In `job.properties` muss die folgende Property gesetzt werden: `parameters.stashedFile=data.zip`; hier muss derselbe Dateiname verwendet werden wie für die Umgebungsvariable `UPLOAD_FILE_NAME`
- Jeweils auch die entsprechende Dateiendung angeben (beispielsweise `xyz.csv`), damit die Benutzer sehen, welcher Dateityp hochgeladen werden soll

Mit dieser Konfiguration wird man beim Start des Jobs gefragt, welche Datei hochgeladen werden soll.
Das Jenkinsfile platziert die hochgeladene Datei im *Gradle Build Directory* im Unterordner `in`.
Die Datei hat in diesem Fall denselben Namen wie die ursprünglich hochgeladene Datei.
Dieser Name wird dem GRETL-Befehl mit der Property `uploadFileName` übergeben.
Dadurch ist bei der Weiterverarbeitung in `build.gradle` die Datei unter `"$buildDir/in/$uploadFileName"` erreichbar.

## Beim Start des GRETL-Jobs einen Parameter (String) übergeben

Vorlage: [xy_jenkinsfile_template_stringparams/Jenkinsfile](xy_jenkinsfile_template_stringparams/Jenkinsfile)

- In `job.properties` muss die Property `parameters.stringParams=PARAM_NAME;DEFAULT_VALUE;DESCRIPTION` gesetzt werden
- Im Jenkinsfile den GRETL-Aufruf ergänzen, so dass mit `-PpropertyName` eine zusätzliche Property übergeben wird, deren Wert mit `${params.PARAM_NAME}` aus dem dem Job übergebenen Parameter gesetzt wird

Der Name des Parameters kann frei gewählt werden, muss aber in `job.properties` und im Jenkinsfile jeweils übereinstimmen.
Der Name der Property, die man dem GRETL-Aufruf übergibt, kann ebenfalls frei gewählt werden.
Wahrscheinlich ist es meistens sinnvoll, wenn sie gleich heisst wie der Parametername.
In `job.properties` muss jeweils mit Strichpunkt getrennt der Parametername, optional der Vorgabewert und optional eine Beschreibung, die im Jenkins GUI bei diesem Parameter angezeigt werden soll, definiert werden.
Die Strichpunkte sind aber immer nötig, z.B. `parameters.stringParams=MY_PARAMETER_NAME;;`

Falls der Job mehrere String-Parameter benötigt, trennt man die einzelnen String-Parameter mit dem Zeichen `@` voneinander ab, z.B.:
```
parameters.stringParams=bfsnr;;BFS-Nr. der Gemeinde welche publiziert werden soll@buildDescription;Keine Beschreibung angegeben;Beschreibung/Grund für die Publikation der Daten
```
oder etwas besser formatiert:
```
parameters.stringParams=bfsnr;;BFS-Nr. der Gemeinde welche publiziert werden soll@\
                        buildDescription;Keine Beschreibung angegeben;Beschreibung/Grund für die Publikation der Daten
```

## Im Pod eine temporäre Datenbank für die Verarbeitung von Daten starten

Vorlage: [alw_fruchtfolgeflaechen/Jenkinsfile](alw_fruchtfolgeflaechen/Jenkinsfile)

Mit diesem Jenkinsfile wird im Jenkins-Agent-Pod zusätzlich ein DB-Container
für die Durchführung von umfangreichen Berechnungen (Geoverarbeitung) gestartet.
Dies hat den Vorteil,
dass die Rechenlast nicht auf den produktiven DBs anfällt.

Der wichtigste Unterschied zum Default-Jenkinsfile ist ab Zeile 14:
Anstatt dass einfach der Default Agent *gretl* gestartet wird,
wird zwar das Pod Template dieses Agents referenziert (`inheritFrom 'gretl'`).
Zusätzlich wird unter `yaml` aber ein weiterer Container
mit Name `processing-db` und einem PostgreSQL-DB-Image
von Crunchy Data definiert,
der in diesem Pod ebenfalls gestartet werden soll.
Mit den Umgebungsvariablen wird dabei der DB-Name (`processing`)
und der zu verwendende DB-User (`user`) und sein Passwort festgelegt.

Ein weiterer Unterschied ist, dass ab Zeile 65 zusätzliche Umgebungsvariablen
für den Job definiert werden,
mit denen dann in `build.gradle` auf die DB zugegriffen werden kann.
(In der DB-URI steht `127.0.0.1`, weil man so vom GRETL-Container aus
den eigenen Pod erreicht, in welchem ja auch der DB-Container läuft.
Und es kommt `processing` vor, weil dies der DB-Name ist,
den man weiter oben im YAML definiert hat.)

### Zusätzlich: Beeinflussung des Ablaufs des GRETL-Jobs

Hinzu kommt noch ein Unterschied im Ablauf des GRETL-Jobs
(dieser Unterschied hat aber nichts mit der Processing-DB zu tun):
Nach dem Schritt `fff_to_edit_db`
müssen die Benutzer das Resultat prüfen.
Falls es nicht gut ist, nehmen sie Änderungen an den Übersteuerungsdaten vor
und klicken im GUI des GRETL-Jobs auf *Fortfahren*;
dann wird dieser Teil der Berechnung nochmals durchgeführt,
und das Resultat kann erneut geprüft werden.
Wenn das Resultat i.O. ist, setzt man im GUI das Häkchen bei `PUBLISH_RESULT`
und klickt auf *Fortfahren*.
So wird der letzte Schritt `gretl fff_to_edit_db_finish` ausgeführt
und der Job abgeschlossen.

(Die Logik des `input`-Steps funktioniert hier so:
Weil er genau einen Parameter aufweist (den `booleanParam`),
gibt der `input`-Step den Wert dieses Parameters zurück.
Setzt man also im GUI das Häkchen, liefert der `input`-Step `true` zurück,
und die `waitUntil`-Schleife wird deshalb verlassen.
Doku: https://www.jenkins.io/doc/pipeline/steps/pipeline-input-step/ und
https://www.jenkins.io/doc/pipeline/steps/workflow-basic-steps/#waituntil-wait-for-condition)

## Im Pod ein PVC einbinden

Vorlage: [arp_nutzungsplanung_pub/Jenkinsfile](arp_nutzungsplanung_pub/Jenkinsfile)

In diesem Jenkinsfile wird im Jenkins-Agent-Pod zusätzlich ein PVC gemountet.

Beispiel für den Mount des `datahub`-Subpath vom Projekt-lowback-PVC:
```yaml
              agent {
                kubernetes {
                    inheritFrom env.NODE_LABEL ?: 'gretl'
                    yamlMergeStrategy merge()
                    yaml """
                    spec:
                      containers:
                        - name: gretl                         # oder 'gretl-2.4' für GRETL Version 2.4
                          volumeMounts:
                            - name: datahub-workdir-volume
                              mountPath: /datahub             # Pfad im Pod, wo das PVC gemountet wird
                              subPath: datahub
                      volumes:
                        - name: datahub-workdir-volume
                          persistentVolumeClaim:
                            claimName: ${env.OPENSHIFT_PROJECT_NAME}-lowback  #sollte in Jenkins automatisch aufgelöst werden
"""
                }
```

Für lokale Entwicklung mit GRETL ohne Jenkins funktioniert das nicht.
Hier muss das [Docker Compose](https://github.com/sogis/gretljobs/blob/main/compose.yaml) entsprechend um ein Volume ergänzt werden.
