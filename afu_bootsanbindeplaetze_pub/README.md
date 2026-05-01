# Beschreibung GRETL-Job afu_bootsanbindeplaetze_pub
Dieses Readme gibt zusätzliche Informationen zum GRETL-Job afu_bootsanbindeplaetze_pub. Es ist komplementär zu den Kommentaren in den SQL-Files und build.gradle-File.

## Ziel GRETL-Job
Publikation der Bootsanbindeplatz-Daten aus dem Edit-Schema afu_bootsanbindeplaetze_v* im Pub-Schema afu_bootsanbindeplaetze_pub_v*.

## Gebühren
Für die Bootsanbindeplätze werden diverse Gebühren berechnet. Dies geschieht im SQL-File [afu_bootsanbindeplaetz.sql](afu_bootsanbindeplatze_bootsanbindeplatz.sql)   

Einige Gebühren sind dabei fix. Anpassungen dieser Gebühren werden durch das AfU mitgeteilt. In dem Fall können im CTE `gebuehren` die entsprechenden Beträge angepasst werden.