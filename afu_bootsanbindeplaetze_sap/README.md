# Beschreibung GRETL-Job afu_bootsanbindeplaetze_sap
Dieses Readme gibt zusätzliche Informationen zum GRETL-Job afu_bootsanbindeplaetze_sap. Es ist komplementär zu den Kommentaren in den SQL-Files und build.gradle-File. Für tiefergehende fachliche Informationen kann zudem das Konzept beigezogen werden.

## Ziel GRETL-Job
Auf Basis der erfassten Bootsanbindeplatzdaten und den berechneten Gebühren (siehe Gretljob afu_bootsanbindeplatze_pub) werden zwei CSV-Downloadfiles generiert (), welche im SAP-System des AfU eingelesen werden können. Das SAP nimmt anschliessend die Rechnungspositionen und generiert Rechnungen für die Bootsanbindeplatzmieter.

Die beiden generierten Downloadfiles unterscheiden sich nur darin, dass das "Kontokorrent-File" dijenigen Werte exportierte, welche beim Boolean-Attribut Kontokorrent wahr sind. Die Rechnungsstellung für Kontokorrent-Kunden erfolgt anders und muss deshalb separat ausgewiesen werden.

## Gebührenart und -zeitpunkt
Unterschieden wird zwischen einer Nutzungsgebuhr und einer Bewilligungsgebühr. Die Nutzungsgebühr ist jedes Jahr fällig und wird auch jedes Jahr zum ungfähr gleichen Zeitpunkt für das aktuelle Jahr verrechnet. Die Bewilligungsgebühr wird einmalig bei der Bootsplatzbewilligung erhoben. Um diese mit der Nutzungsgebühr zu bündeln, wird hier auf das Bewilligungsedatum geachtet. 

Im Normalfall werden die Rechnungen gegen Ende März jeden Jahres generiert. Wenn die Bewilligung nach dem 1.7. des letzten Jahres erhoben wurde, dann wird sie in die Rechnungsperiode integriert, andernfalls nicht. Der Grund liegt darin, dass der Bootsanbindeplatzmieter ab Bewilligung ein halbes Jahr Zeit hat sein Boot zu platzieren. Hatte der Mieter im letzten Jahr noch mehr als ein halbes Jahr Zeit (Bewilligung wurde vor dem 1.7. ausgsgestellt), dann wurde sie noch in die vorjährige Rechnugnsperiode integriert.

Die Berechnungen sind in den SQL-Files [afu_bootsanbindeplaetze_sap_calculate_values](afu_bootsanbindeplaetze_sap_calculate_values.sql) resp. [afu_bootsanbindeplaetze_kontokorrent_calculate_values](afu_bootsanbindeplaetze_kontokorrent_calculate_values.sql) ersichtlich.

## Rechnungsstelle Steggebühr
Bei gewissen Standorten wird die Steggebühr (Teil der Nutzungsgebühr) nicht vom Bootsanbindeplatzmieter, sondern vom Stegbesitzer getragen. Dafür wurde das Attribut rechnungsstelle_steggebuehr geschaffen. Ist dieses anders anders als das Attribut rechnungsstelle_nutzungsgebuehr, dann wird die Steggebühr dem Nutzer zugeordnet, welcher in rechnungstelle_steggebuehr hinterlegt ist.
