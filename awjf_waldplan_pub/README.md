# Beschreibung GRETL-Job awjf_waldplan_pub

## Ziel GRETL-Job
Publikation der Waldplan-Daten aus dem Edit-Schema awjf_waldplan_v* im Pub-Schema awjf_waldplan_pub_v*.

## Struktur GRETL-Job
Da viele Flächen miteinander verschnitten werden und Zwischentabellen bei der Berechnungen helfen, wird die Processing-DB genutzt. <br>
Die Publikations erfolgt gemeindeweise gemäss der BFS-Nr.

## Flächenberechnungen
Innerhalb des Gretl-Jobs werden diverse Waldflächen berechnet. Als Basis für die Flächenberechnung wird im Task `processingPubData` mit dem SQL `06_awjf_waldplan_grundstueck_03_waldfunktion_waldnutzung_processing.sql` eine Tabelle gebildet, die sich aus den verschnittenen Waldfunktions- und Waldnutzungskategorie pro Grundstück zusammenstellt. Der nachfolgende Screenshot zeigt einen Ausschnitt der Tabelle aus der Processing-DB:

![tabelle_waldfunktion_waldnutzung](Bilder/processingtabelle_waldfunktion_waldnutzung.png)

Daraus können dann sämtlich benötigte Flächenwerte aus der Kombination aus Waldfunktion und Waldnutzung abgeleitet werden.

Begriffserklärungen
Prodkutive Waldflächen
