# GRETL-Jobs *agi_av_export_ai* und *agi_av_export_jahresstand_ai*

Diese beiden GRETL-Jobs hatten bisher ein eigenes `build.gradle`,
das jeweils bis auf den Wert für die *curl*-Formulardaten
`topic=av` bzw. `topic=av_jahresstand` identisch war.
Neu wird für diese beiden GRETL-Jobs
nur noch ein einzelnes, parametrisiertes `build.gradle` vorgehalten.

## Details zur gewählten Lösung

Mit dem neuen `build.gradle` kann man dem GRETL-Job als Property entweder
`-Ptopic=av` oder `-Ptopic=av_jahresstand` übergeben.
(Wenn man die Property nicht angibt, ist der Standardwert `av`.)
Damit dies auch in Jenkins möglich ist,
haben beide Jobs ein spezielles Jenkinsfile, das diese Properties übergibt.

Eine weitere, sehr spezielle Besonderheit
am Jenkinsfile von *agi_av_export_jahresstand_ai* ist,
dass mit diesem Jenkinsfile gar kein `gretl`-Befehl ausgeführt wird,
sondern stattdessen der Job `agi_av_export_ai`
mit dem Parameter `topic=av_jahresstand` aufgerufen wird.
Daher muss dieser Job auch nicht auf dem Agent `gretl` laufen,
sondern er kann auf `master` laufen.
(Auf `gretl` würde auch funktionieren, es braucht so aber etwas länger,
weil dieser Agent ja erst gestartet werden muss.)

Im Prinzip benötigt der Job *agi_av_export_jahresstand_ai*
also kein `build.gradle`.
Damit der Job aber dennoch
vom *gretl-job-generator* in GRETL-Jenkins angelegt wird,
liegt im Job-Ordner ein leeres `build.gradle` vor.

Eine weitere, aber eher nebensächliche Besonderheit
am Jenkinsfile von *agi_av_export_jahresstand_ai* ist,
dass es auch bei Erfolg des Jobs ein E-Mail versendet.
Dies deshalb, weil er nur einmal pro Jahr läuft
und damit man auf die Job-Ausführung aufmerksam wird.
