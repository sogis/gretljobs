# Dokumentation Jenkinsfile

Standardmässig verwenden die GRETL-Jobs das "zentrale" [Standard-Jenkinsfile](Jenkinsfile).
Bei speziellen Anforderungen kann man einem Job ein eigenes Jenkinsfile zuweisen, indem man es im Job-Ordner platziert.
In den folgenden Abschnitten sind solche Fälle aufgelistet.
Es ist jeweils aufgeführt, welches Jenkinsfile für einen ähnlichen Fall als Vorlage übernommen werden soll.
Es sollen möglichst wenige oder am besten gar keine Änderungen am übernommenen Jenkinsfile gemacht werden, damit die Jenkinsfiles weitgehend einheitlich bleiben.

## GRETL-Jobs mit File Upload

Vorlage: [xy_jenkinsfile_template_fileupload/Jenkinsfile](xy_jenkinsfile_template_fileupload/Jenkinsfile)

- In `job.properties` muss die folgende Property gesetzt werden: `parameters.stashedFile=FILE_NAME` (in der Vorlage als Beispiel `parameters.stashedFile=data.zip`); der hier gesetzte Dateiname definiert, wie die Datei nach dem Upload heissen wird
- Im Jenkinsfile muss in Zeile 13 die Umgebungsvariable `UPLOAD_FILE_NAME` auf denselben Dateinamen gesetzt werden (in der Vorlage `data.zip`)
- Jeweils auch die entsprechende Dateiendung angeben (beispielsweise `xyz.csv`), damit die Benutzer sehen, welcher Dateityp hochgeladen werden soll

Mit dieser Konfiguration wird man beim Start des Jobs gefragt, welche Datei hochgeladen werden soll.
Das Jenkinsfile platziert die hochgeladene Datei im *Gradle Build Directory* im Unterordner `in`.
Die hochgeladene Datei wird nach dem Upload jeweils den in `job.properties` unter `parameters.stashedFile` definierten Dateinamen haben.
Bei der Weiterverarbeitung die Datei im `build.gradle` mit der Variablen `$buildDir` referenzieren.
Beispiele: `"$buildDir/in/data.zip"`, `buildDir + "/in/xyz.csv"`

## GRETL-Jobs mit File Upload, wobei der ursprüngliche Dateiname beibehalten werden soll

Vorlage: [xy_jenkinsfile_template_fileupload_origname/Jenkinsfile](xy_jenkinsfile_template_fileupload_origname/Jenkinsfile)

- In `job.properties` muss die folgende Property gesetzt werden: `parameters.stashedFile=FILE_NAME` (in der Vorlage als Beispiel `parameters.stashedFile=data.zip`); der hier gesetzte Dateiname ist für den GRETL-Job irrelevant, da die Datei vom Jenkinsfile zu ihrem ursprünglichen Dateinamen umbenannt wird
- Im Jenkinsfile muss in Zeile 13 die Umgebungsvariable `UPLOAD_FILE_NAME` auf denselben Dateinamen gesetzt werden (in der Vorlage `data.zip`)
- Jeweils auch die entsprechende Dateiendung angeben (beispielsweise `xyz.csv`), damit die Benutzer sehen, welcher Dateityp hochgeladen werden soll

Mit dieser Konfiguration wird man beim Start des Jobs gefragt, welche Datei hochgeladen werden soll.
Das Jenkinsfile platziert die hochgeladene Datei im *Gradle Build Directory* im Unterordner `in`.
Die Datei hat in diesem Fall immer denselben Namen wie die ursprünglich hochgeladene Datei.
Dieser Name wird auf Zeile 20 dem GRETL-Befehl mit der Property `uploadFileName` übergeben.
Dadurch ist die Datei in GRETL in `build.gradle` unter `"$buildDir/in/$uploadFileName"` erreichbar.

Der Anwendungsfall für diese Variante ist, dass im Dateinamen der hochgeladenen Datei z.B. eine BFS-Nummer vorkommt (z.b. `schutzbauten_2408.xtf`), die dann in GRETL ausgelesen und bei _ili2pgReplace_ als Dataset übergeben werden kann.

## Beim Start des GRETL-Jobs einen Parameter (String) übergeben

Vorlage: [xy_jenkinsfile_template_stringparams/Jenkinsfile](xy_jenkinsfile_template_stringparams/Jenkinsfile)

- In `job.properties` muss die Property `parameters.stringParams=PARAM_NAME;DEFAULT_VALUE;DESCRIPTION` gesetzt werden (in der Vorlage als Beispiel `parameters.stringParams=ili2pgDataset;2408;BFS-Nummer (Dataset) der Daten angeben`)
- Im Jenkinsfile muss in Zeile 13 die Option `-P propertyName=${params.PARAM_NAME}` des GRETL-Aufrufs angepasst werden: `PARAM_NAME` muss gleich wie der Parametername lauten, den man in `job.properties` gewählt hat; `propertyName` kann im Prinzip anders lauten, aber es ist sinnvoll, wenn er möglichst ähnlich lautet wie der Parametername (in der Vorlage deshalb `-P ili2pgDataset=${params.ili2pgDataset}`)

Mit dieser Konfiguration wird dem GRETL-Befehl die Property `propertyName` übergeben, deren Wert der Parameterwert ist, den man dem Job beim Start mitgegeben hat.
Der Name des Parameters kann frei gewählt werden, muss aber in `job.properties` und im Jenkinsfile jeweils übereinstimmen.
Der Name der Property, die man dem GRETL-Aufruf übergibt, kann ebenfalls frei gewählt werden, aber es ist sinnvoll, wenn er möglichst ähnlich lautet wie der Parametername.

In `job.properties` muss hinter `parameters.stringParams=` der Parametername, optional ein Vorgabewert und optional eine Beschreibung, die im Jenkins GUI bei diesem Parameter angezeigt werden soll, definiert werden, jeweils mit Strichpunkt voneinander getrennt.
Die Strichpunkte müssen immer gesetzt werden, auch wenn man einen oder beide optionale Angaben weglässt, z.B. `parameters.stringParams=MY_PARAMETER_NAME;;`

Falls der Job mehrere String-Parameter benötigt, trennt man die einzelnen String-Parameter mit dem Zeichen `@` voneinander ab, z.B.:
```
parameters.stringParams=bfsnr;;BFS-Nr. der Gemeinde, welche publiziert werden soll@buildDescription;Keine Beschreibung angegeben;Beschreibung/Grund für die Publikation der Daten
```
oder etwas besser formatiert:
```
parameters.stringParams=bfsnr;;BFS-Nr. der Gemeinde, welche publiziert werden soll@\
                        buildDescription;Keine Beschreibung angegeben;Beschreibung/Grund für die Publikation der Daten
```

## Im Pod eine temporäre Datenbank für die Verarbeitung von Daten starten

Vorlage: [xy_jenkinsfile_template_processing/Jenkinsfile](xy_jenkinsfile_template_processing/Jenkinsfile)

Mit diesem Jenkinsfile wird im Jenkins-Agent-Pod zusätzlich ein DB-Container für die Durchführung von umfangreichen Berechnungen (Geoverarbeitung) gestartet.
Dies hat den Vorteil, dass die Rechenlast nicht auf den produktiven DBs anfällt.

Der wichtigste Unterschied zum Default-Jenkinsfile ist, dass nicht einfach der Default Agent *gretl* gestartet wird.
Sondern das Pod Template dieses Agents wird zwar referenziert (`inheritFrom env.NODE_LABEL ?: 'gretl'` auf Zeile 4), aber mit zusätzlichem YAML wird ein weiterer Container mit Name `processing-db` und Image `postgis/postgis:18-3.6-alpine` definiert, der zusätzlich zum GRETL-Container im gleichen Pod gestartet wird.
Mit der Umgebungsvariablen `POSTGRES_USER` wird dabei ein DB-User (`processing`) und implizit auch der DB-Name (also ebenfalls `processing`) festgelegt, und mit `POSTGRES_PASSWORD` das Passwort des DB-Users (ebenfalls `processing`).

Ein weiterer Unterschied ist, dass ab Zeile 39 zusätzliche Umgebungsvariablen für den Job definiert werden, so dass man in `build.gradle` mit den Variablen `dbUriProcessing`, `dbUserProcessing` und `dbPwdProcessing` auf die DB zugreifen kann.
(In der DB-URI steht `127.0.0.1`, weil man so vom GRETL-Container aus andere Container im aktuellen Pod, in welchem ja auch der DB-Container läuft, erreicht.
Und hinter dem Schrägstrich steht `processing`, weil dies der DB-Name ist, den man weiter oben im YAML mit der Umgebungsvariable `POSTGRES_USER` implizit definiert hat.)

## Beeinflussung des Ablaufs des GRETL-Jobs

In [afu_gewaesserschutz_zonen_areale_pub/Jenkinsfile](afu_gewaesserschutz_zonen_areale_pub/Jenkinsfile) findet sich ein Beispiel eines Jobs, bei dem der Ablauf vom User beeinflusst werden kann (Rückfrage an den User).
Dieser Job lehnt sich an die ÖREB-GRETL-Jobs an.
Es gibt hiefür keine Jenkinsfile-Vorlage, weil praktisch jeder Job wieder individuell ist.
Generell gilt, dass man wenn möglich lieber auf dieses Feature verzichtet, wenn es nicht zwingend ist.

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
