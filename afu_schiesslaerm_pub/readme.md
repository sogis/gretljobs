# Übersicht über diesen Publikations-Job

Die Tasks des Jobs gliedern sich die folgenden Haupt-Schritte:

* Validierung der Eingabe-Parameter des Jobs (bis Task "validate").
    * Sicherstellung, dass die übergebene Schiessplatz-ID auch in den Daten existiert.
    * Entscheid, ob der Job im "Aktualisierungs-Modus" oder im "Lösch-Modus" arbeitet.
        * Aktualisierungs-Modus, falls hasRealData = true
        * Lösch-Modus, falls hasRealData = false
* Aktualisierung des Pub-Schemas mit den übergebenen Daten eines Schiessplatzes (bis Task "setDisplayText")   
Funktioniert mittels Ili2PgReplace und Datasets. Die Namen der Datasets entsprechen den Schiessplatz-ID's.
* Publikation der Daten im Datenbezug (restliche Tasks)   
Da auf der Pub-DB Datasets vorhanden sind, erfogt die Publikation über zwei Publisher:
    * "Hilfs-Publikation" des ganzen Datensatzes in ein lokal zwischengespeichertes XTF.
    * Erstellung der Datenbezug-Dateien ab dem XTF. 