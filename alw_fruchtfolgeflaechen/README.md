# GRETL-Job alw_fruchtfolgeflaechen, der eine separate DB für die Prozessierung von Daten startet

Dieser GRETL-Job weist ein eigenes Jenkinsfile auf,
in welchem definiert ist, dass im GRETL-Pod zusätzlich zum
GRETL-Container auch ein DB-Container gestartet werden soll.
Die DB in diesem Container wird dann für das Geoprocessing verwendet,
damit die Rechenlast nicht auf einer produktiven DB anfällt.

## Beschreibung des Jenkinsfiles

Der wichtigste Unterschied zum Default-Jenkinsfile ist ab Zeile 7:
Anstatt dass einfach der Default Agent *gretl* gestartet wird,
wird zwar das Pod Template dieses Agents referenziert (`inheritFrom 'gretl'`).
Zusätzlich wird unter `yaml` aber ein weiterer Container
mit Name `processing-db` und einem DB-Image von bookworm definiert,
der in diesem Pod ebenfalls gestartet werden soll.
Mit den Umgebungsvariablen wird auch der DB-Name (`processing`)
und der zu verwendende DB-User (`processing`) und sein Passwort definiert.

Ein weiterer Unterschied ist, dass ab Zeile 40 zusätzliche Umgebungsvariablen
für den Job definiert werden,
mit denen dann in *build.gradle* auf die DB zugegriffen werden kann.
(In der DB-URI steht `127.0.0.1`, weil man so vom GRETL-Container aus
den eigenen Pod erreicht, in welchem ja auch der DB-Container läuft.
Und es kommt `processing` vor, weil dies der DB-Name ist,
den man weiter oben im YAML definiert hat.)

Hinzu kommt noch ein Unterschied im Ablauf des GRETL-Jobs:
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
gibt der `input`-Steps den Wert dieses Parameters zurück.
Setzt man also im GUI das Häkchen, liefert der `input`-Step `true` zurück,
und die `waitUntil`-Schleife wird deshalb verlassen.
Doku: https://www.jenkins.io/doc/pipeline/steps/pipeline-input-step/ und
https://www.jenkins.io/doc/pipeline/steps/workflow-basic-steps/#waituntil-wait-for-condition)


## Entwicklungs-DBs starten

In diesem Fall müssen die Entwicklungs-DBs
mit einem leicht anderen Befehl gestartet werden
Dies wird hier beschrieben: https://github.com/sogis/gretljobs/blob/main/README.md#gretl-jobs-die-eine-db-f%C3%BCr-das-processing-von-daten-ben%C3%B6tigen


## GRETL-Job lokal ausführen

In diesem Fall müssen vor dem Ausführen des GRETL-Wrapperskripts
zusätzlich folgende Umgebungsvariablen gesetzt werden:

```
export ORG_GRADLE_PROJECT_dbUriProcessing=jdbc:postgresql://processing
export ORG_GRADLE_PROJECT_dbUserProcessing=processing
export ORG_GRADLE_PROJECT_dbPwdProcessing=processing
```
