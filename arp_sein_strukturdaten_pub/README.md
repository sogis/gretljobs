# Strukturdaten für die SEin App

## Was macht der Job?

Dieser Job verschneidet Daten der Nutzungsplanung und Amtlichen Vermessung sowie Gebäude-, Bevölkerungs- und Unternehmensdaten und bereitet die vier Datenebenen Parzelle, Zonentyp, Zonenschild und Gemeinde auf. Diese werden der Applikation "Siedlungsentwicklung nach innen" (SEin) in Form einer XTF-Datei bereitgestellt.

## Aufbau des Jobs

Es wird eine processing-db eingesetzt, um Zwischenresultate materialisieren, indizieren und wiederverwenden zu können. Um die processing-db hochzufahren und einzubinden, wurde ein vom Default abweichendes Jenkinsfile erstellt.

Die vier SQL-Dateien `<datenebene>.sql` enthalten je alle SQL-Querys, die für die Berechnung der jeweiligen Datenebene notwendig sind, müssen jedoch in der festgelegten Reihenfolge ausgeführt werden (siehe `build.gradle`), da Zwischenresultate wiederverwendet werden. Beispielsweise wird der Verschnitt der Bauzonenstatistik mit der Bodenbedeckung nur einmal auf Parzellen-Ebene ausgeführt und das Ergebnis hochaggregiert.

## Schedule

Ausführung jedes Monatsende anschliessend an den Job `arp_auswertung_nutzungsplanung_pub`.