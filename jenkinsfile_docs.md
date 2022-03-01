# Dokumentation Jenkinsfile

Standardmässig verwenden die GRETL-Jobs
das "zentrale" [Standard-Jenkinsfile](Jenkinsfile).
Bei speziellen Anforderungen kann man einem Job
ein eigenes Jenkinsfile zuweisen,
indem man es im Job-Ordner platziert.
In den folgenden Abschnitten sind solche Fälle aufgelistet;
es ist jeweils aufgeführt, welches Jenkinsfile für einen ähnlichen Fall
als Vorlage übernommen werden soll.
Es sollen möglichst wenige oder am besten gar keine Änderungen
am übernommenen Jenkinsfile gemacht werden,
damit die Jenkinsfiles weitgehend einheitlich bleiben.

## Nach dem Start des GRETL-Jobs in Jenkins eine Datei hochladen

Vorlage: [avt_ausnahmetransportrouten_export_ai/Jenkinsfile](avt_ausnahmetransportrouten_export_ai/Jenkinsfile)

Direkt nach dem Start des Jobs wird man gefragt,
welche Datei man hochladen möchte.
(Diese Frage wird im klassischen Jenkins-GUI leider etwas versteckt angezeigt.)

Mit diesem Jenkinsfile kann in `build.gradle`
über den relativen Pfad `upload/uploadFile`
(die Datei heisst nach dem Upload also immer `uploadFile`)
auf die hochgeladene Datei zugegriffen werden.

## Nach dem Start des GRETL-Jobs in Jenkins eine Datei hochladen und zusätzlich den Dataset-Namen (z.B. BFS-Nummer) angeben

Vorlage: [arp_npl_import/Jenkinsfile](arp_npl_import/Jenkinsfile)

Auch hier wird man direkt nach dem Start des Jobs gefragt,
welche Datei man hochladen möchte, und man muss einen Dataset-Namen angeben.

In diesem Fall ist die hochgeladene Datei in `build.gradle`
ebenfalls unter `upload/uploadFile` verfügbar.
Zudem kann auf den angegebenen Dataset-Namen
über die Variable `ili2pgDataset` zugegriffen werden.

## Beim Start des GRETL-Jobs einen Parameter (String) übergeben

Vorlage: [afu_abbaustellen_pub/Jenkinsfile](afu_abbaustellen_pub/Jenkinsfile)

Damit dieser Job funktioniert, muss zusätzlich in der Datei `job.properties`
die folgende Zeile stehen:

```
parameters.stringParam=afuAbbaustellenAppXtfUrl;;Komplette URL zum Download des XTF
```

Der Name des Parameters kann frei gewählt werden
(hier `afuAbbaustellenAppXtfUrl`);
nach dem ersten Strichpunkt kann zudem ein Vorgabewert eingetragen werden
(hier leerer String);
nach dem zweiten Strichpunkt kann eine Beschreibung eingegeben werden,
die dem Benutzer zu diesem Parameter
beim Start des GRETL-Jobs angezeigt werden soll.

Im Jenkinsfile muss der Name des Parameters an den
in `job.properties` definierten Namen angepasst werden.

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
