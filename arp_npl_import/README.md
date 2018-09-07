# Import und Datenumbau der Nutzungsplanung

Es gibt für den Import und Datenumbau zur Zeit je einen GRETL-Job. Ziel ist es alles in einem Job konsolidieren. Dazu fehlt aber die Anbindung eines Filesystems an GRETL-Jenkins, um auf zu importierende XTF zugreifen zu können. Der Importjob muss aus diesem Grund lokal ausgeführt werden. Wird ein GRETL-Job lokal ausgeführt, kann er aber nicht auf die notwendigen DB-Credentials für die Pub-DB zugreifen, die man für das Schreiben (also den Datenumbau) in die Pub-DB braucht. Aus diesem Grund sind zwei einzelne Jobs notwendig. Der Importrozess wird lokal "on-demand" ausgeführt, der Datenumbau-Prozess wird in GRETL-Jenkins "on-demand" ausgeführt.

Vertretbar solange Lieferungen noch eine seltene Ausnahmeerscheinung sind...

## Import-Datenumbau-Workflow

Gretljobs-Repo (lokal) klonen:

```
git clone https://github.com/sogis/gretljobs.git gretljobs-npl-import
```

Zu importieren XTF in das Import-Job-Verzeichnis (`arp_npl_import`) kopieren, damit diese für Gretl im Docker-Container sichbar sind.

Umgebungsvariablen für DB-Verbindung setzen. Diese werden im Docker-Container beim Ausführen des Jobs verwendet:

```
export DB_URI_SOGIS=jdbc:postgresql://geodb-t.verw.rootso.org:5432/sogis
export DB_USER_SOGIS=datasync
export DB_PWD_SOGIS=datasync
```

Im `scripts`-Ordner des geklonten Repos folgender Befehl ausführen, um den Import zu starten:

```
./start-gretl.sh --docker_image sogis/gretl-runtime:production --job_directory /Users/stefan/tmp/gretljobs-npl-import/arp_npl_import/ --task_name replaceDataset -Pxtf=2580_091_2018-02-13.xtf
```

Ein absoluter Pfad zum `--job_directory` verursacht m.E. am wenigsten Probleme.

Wenn der Job erfolgreich durchgelaufen ist, in QGIS o.ä. überprüfen, ob die Daten tatsächlich sauber importiert wurden.

Anschliessend kann in der GRETL-Jenkins-Umgebung (`https://gretl-test.so.ch/`) der Job `arp_npl_pub` ausgeführt werden. Der zugehörige Job liegt im Verzeichnis `arp_npl_pub`. Logfiles anschauen und in QGIS o.ä. überprüfen. 

Wenn in der Test-Umgebung alles funktioniert hat, das Ganze nochmals auf der Produktion. In Zukunft dürfte wohl das Ausführen auf der Test-Umgebung überflüssig werden.

### Alte Welt (QWC1)
Da nun der Datenumbau direkt beim Transfer von Erfassungs-DB nach Pub-DB passiert, fehlt das Pub-Modell (resp. Schema des Pub-Modelles) auf der alten sogis-DB. Temporär muss es auch noch dort vorhanden sein, weil man immer noch den QWC1 bedienen will. Dazu wird der `arp_npl_pub`-Job lokal ausgeführt. Hier müssen noch die DB-Parameter gesetzt werden:

```
export DB_URI_PUB=jdbc:postgresql://geodb-t.verw.rootso.org:5432/sogis
export DB_USER_PUB=datasync
export DB_PWD_PUB=datasync
```

```
./start-gretl.sh --docker_image sogis/gretl-runtime:production --job_directory /Users/stefan/tmp/gretljobs-npl-import/arp_npl_pub/ 
```

### Fehlermeldungen

```
Started by user Ziegler Stefan
[Pipeline] node
Running on master in /var/lib/jenkins/jobs/arp_npl_pub/workspace
[Pipeline] End of Pipeline
java.lang.ArrayIndexOutOfBoundsException: 0
	at org.jenkinsci.plugins.workflow.cps.DSL$ThreadTaskImpl.invokeBody(DSL.java:567)
	at org.jenkinsci.plugins.workflow.cps.DSL$ThreadTaskImpl.eval(DSL.java:538)
	at org.jenkinsci.plugins.workflow.cps.CpsThread.runNextChunk(CpsThread.java:184)
	at org.jenkinsci.plugins.workflow.cps.CpsThreadGroup.run(CpsThreadGroup.java:330)
	at org.jenkinsci.plugins.workflow.cps.CpsThreadGroup.access$100(CpsThreadGroup.java:82)
	at org.jenkinsci.plugins.workflow.cps.CpsThreadGroup$2.call(CpsThreadGroup.java:242)
	at org.jenkinsci.plugins.workflow.cps.CpsThreadGroup$2.call(CpsThreadGroup.java:230)
	at org.jenkinsci.plugins.workflow.cps.CpsVmExecutorService$2.call(CpsVmExecutorService.java:64)
	at java.util.concurrent.FutureTask.run(FutureTask.java:266)
	at hudson.remoting.SingleLaneExecutorService$1.run(SingleLaneExecutorService.java:112)
	at jenkins.util.ContextResettingExecutorService$1.run(ContextResettingExecutorService.java:28)
	at java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:511)
	at java.util.concurrent.FutureTask.run(FutureTask.java:266)
	at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1149)
	at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:624)
	at java.lang.Thread.run(Thread.java:748)
Finished: FAILURE
```

-> Nochmals ausführen und es hat funktioniert. Scheint ein Problem von Jenkins gewesen zu sein.


## Entwicklung

See: [https://geoweb.rootso.org/redmine/issues/2677](https://geoweb.rootso.org/redmine/issues/2677)

java -jar ~/apps/ili2pg-3.11.2/ili2pg.jar \
--dbhost 192.168.50.5 \
--dbdatabase sogis \
--dbusr ddluser \
--dbpwd ddluser \
--nameByTopic \
--disableValidation \
--defaultSrsCode 2056 \
--strokeArcs \
--sqlEnableNull \
--createGeomIdx \
--createFkIdx \
--createEnumTabs \
--beautifyEnumDispName \
--createMetaInfo \
--createBasketCol \
--createDatasetCol \
--models SO_Nutzungsplanung_20171118 \
--dbschema arp_npl \
--createscript arp_npl.sql \
--schemaimport \
--createUnique \
--createFk \
--createNumChecks

Dient hier sogleich zum Testen mit einer lokalen Vagrant-Kiste.

