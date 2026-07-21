# Beschreibung GRETL-Job awjf_waldplan_pub
Dieses Readme gibt zusätzliche Informationen zum GRETL-Job gesa_tigermueckenfundstellen_pub. Es ist komplementär zu den Kommentaren in den SQL-Files und build.gradle-File.

## Ziel GRETL-Job
Import der Tigermückenfundstellendaten in das Edit-Schema gesa_tigermueckenfundstellen_v* und Publikation der Daten im Pub-Schema gesa_tigermueckenfundstellen_pub_v*.

## CSV-Import
Die Import-Datei wird vom GESA selbst beim Tropeninstitut besorgt. Diese sollte im Idealfall eine CSV-Datei sein. Sollte es sich um eine Excel-Datei handeln muss diese erst noch in eine CSV-Datei umgewandelt werden.

## Verwackelung der Punktgeometrien
Aus Sicherheitsgründen werden die Koordinaten der Fundstellen zufällig um 0-10m verwackelt. Die soll das Aufffinden der Fundstellen durch Drittpersonen vor Ort erschweren.

## Historisierung der Daten
Im Edit-Schema erfolgt eine Historisierung der Importdaten. Das heisst, dass beim Import immer nur die Daten aus dem aktuellen Jahr gelöscht.
Dies funktioniert so, dass aus der Importdatei das aktuelle Jahr rausgelesen wird (sollte immer gleich sein in der ganzen Datei) und dieses Jahr als "Löschungsvariable" verwendet wird. Sobald das Jahr ändert, verbleiben die die letztjährigen Daten im Schema.
Um die Jahresvariable dynamisch verwendne zu können muss das Löschungs-SQL dynamisch generiert werden (Task "generateDeleteSql")