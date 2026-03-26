# Beschreibung GRETL-Job awjf_waldplan_pub
Dieses Readme gibt zusätzliche Informationen zum GRETL-Job awjf_waldplan_pub. Es ist komplementär zu den Kommentaren in den SQL-Files und build.gradle-File.

## Ziel GRETL-Job
Publikation der Waldplan-Daten aus dem Edit-Schema awjf_waldplan_v* im Pub-Schema awjf_waldplan_pub_v*.

## Struktur GRETL-Job
Da viele Flächen miteinander verschnitten werden und Zwischentabellen bei der Berechnungen helfen, wird die Processing-DB genutzt. <br>
Die Publikations erfolgt gemeindeweise gemäss der BFS-Nr. Die BFS-Nr. entspricht auch immer dem Dataset.

Der Gretl-Job ist folgendermassen aufgebaut:
```
┌──────────────────────────────────────┐
│ Erstellung Tabellen in Processing DB │
└──────────────────────────────────────┘
                    │         
                    ▼
┌──────────────────────────────────────┐
│ Import Daten in Processing DB        │
└──────────────────────────────────────┘
                    │         
                    ▼
┌──────────────────────────────────────┐
│ Flächenberechnungen in Processing DB │
└──────────────────────────────────────┘
                    │         
                    ▼
┌──────────────────────────────────────┐
│ Export XTF aus Processing DB         │
│ nach BFS-Nr                          │
└──────────────────────────────────────┘
                    │         
                    ▼
┌──────────────────────────────────────┐
│ Ersatz Daten auf Pub DB mittels      │
│ exportiertem XTF-File                │
└──────────────────────────────────────┘
                    │         
                    ▼
┌──────────────────────────────────────┐
│ Update Anzeigenamen auf Pub DB       │
└──────────────────────────────────────┘
                    │         
                    ▼
┌──────────────────────────────────────┐
│ Publisher                            │
└──────────────────────────────────────┘
```

Anmerkung: Bei der Waldübersicht handelt es sich um ein Multipolygon über die ganze Gemeinde. Daher wird diese immer komplett neu publiziert.

### Publikation alle Gemeinden
Um initial alle Daten zu publizieren, existiert der Gretl-Job [awjf_waldplan_pub_alle_gemeinden](https://github.com/sogis/gretljobs/tree/main/awjf_waldplan_pub_alle_gemeinden). Dieser funktioniert vom Prinzip gleich. Um aber alle Gemeinden mit einem Job publizieren zu können, wurde ein Loop eingebaut. Im Normalfall sollte der Job in Zukunft nicht mehr ausgeführt werden (ausser wenn das Schema neu aufgestzt werden muss). Idealerweise werden die beiden Jobs in Zukunft noch zusammengeführt. Dies ist Stand jetzt (März 2026) aber noch nicht der Fall.

## Flächenberechnungen
Innerhalb des Gretl-Jobs werden diverse Waldflächen berechnet. Als Basis für die Flächenberechnung wird im Task `processingPubData` mit dem SQL `06_awjf_waldplan_grundstueck_03_waldfunktion_waldnutzung_processing.sql` eine Tabelle gebildet, die sich aus den verschnittenen Waldfunktions- und Waldnutzungskategorie pro Grundstück zusammenstellt. Der nachfolgende Screenshot zeigt einen Ausschnitt der Tabelle aus der Processing-DB:

![tabelle_waldfunktion_waldnutzung](Bilder/processingtabelle_waldfunktion_waldnutzung.png)

Daraus können dann sämtlich benötigte Flächenwerte aus der Kombination aus Waldfunktion und Waldnutzung abgeleitet werden.

Wichtig dabei sind vor allem die prodiktiven (resp. unproduktiven) und hiebsatzrelevanten (resp. nicht hiebsatzrelevanten) Waldflächen.
Diese setzen sich folgendermassen zusammen

* <b>Prodkutive Waldfläche:</b> Nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung')
* <b>Unproduktive Waldfläche:</b> Nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung')
* <b>Hiebsatzrelevante Waldfläche:</b> Produktive Waldfläche - (Funktion = 'Biodiversitaet' AND biodiversitaet_objekt IN ('Waldreservat', 'Altholzinsel'))
* <b>Nicht hiebsatzrelevante Waldfläche:</b> Unproduktive Waldfläche + (Funktion = 'Biodiversitaet' AND biodiversitaet_objekt IN ('Waldreservat', 'Altholzinsel'))
					