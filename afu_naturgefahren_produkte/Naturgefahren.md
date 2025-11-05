# Nachführung der Naturgefahren

## Verantwortliche:
AfU: Nicole Bieber (Nicole.Bieber@bd.so.ch), Doris Vath (Doris.Vath@bd.so.ch)<br>
AGI: Oliver Jeker, Martin Schweizer 

## Beschreibung
Die Nachführung der Naturgefahren besteht aus verschiedenen Teilbereichen: <br> 
- Import
- Freigabe
- Produkteberechnung
- Publikation und Upload AI


## Erfassung
Die Nachführung der Naturgefahren erfolgt folgendermassen: 
1. Das AfU vergibt einen Auftrag an ein Ingenieur-Büro, welches die Naturgefahren in einem gewissen Gebiet (Abklärungsperimeter) aufnehmen soll. Es können dabei auch nur Teilaufträge vergeben werden (z.B. Gebiet X, nur Hauptprozess Wasser).
1. Das Büro schickt ein validiertes XTF (Modell https://geo.so.ch/models/AFU/SO_AFU_Naturgefahren_20240501.ili) ans AfU
1. Das AfU importiert die Daten über den folgenden GRETL-Job: *afu_naturgefahren_import (link).*<br> **Wichtig**: Die Daten werden in nach der Auftragskennung benannten ILI-Datasets importiert. Zwecks bewusstem Umgang damit müssen die Namen der importierten XTF den Auftragskennungen entsprechen (Bsp: Bei Kennung 128_Himmelried_2023 heisst das XTF 128_Himmelried_2023.xtf). Bei Nicht-Übereinstimmung bricht der Importjob ab.

### Constraints

Teil der Validierung des Erfassungsmodells sind umfangreiche Constraints, welche teilweise in Java-Bibliotheken implementiert sind.

Das korrekte Arbeiten der Constraints ist über das Testbett https://github.com/sogis/natgef-testbed sichergestellt. In diesem wird das korrekte Funktionieren der Constraints durch auf den Constraint passende invalide Daten geprüft. Das Testbett stellt sicher, dass die Validierung mit dem entsprechenden Fehler abbricht.

### Validierung

Mit der vom Testbett geprüften Validierungs-Konfiguration werden die Daten im GRETL-Importjob und im ilivalidator-web-service (https://geo.so.ch/ilivalidator/) validiert.

Dokumentation der in Testbett, GRETL und ilivalidator-web-service verwendeten Versionen siehe [Readme des Testbetts](https://github.com/sogis/natgef-testbed/blob/main/readme.md).

### DB Schema

Edit-DB: afu_naturgefahren_v1 <br>
In diesem Schema sind NUR die neuen Daten. Die alten NatGef-Daten lagern nach wie vor im Schema afu_gefahrenkartierung_v1.

## Freigabe

Nachdem die importierten Daten vom AfU verifiziert wurden, kann der sogenannte "Freigabe-Job" gestartet werden. Dabei wird der Basket bzw. das Dataset des neu importierten Datensatzes auf das "main"-Dataset gesetzt, so dass dieser Datensatz neu nicht mehr eigenständig ist.   
Dies geschieht über den GRETL-Job *afu_naturgefahren_freigeben*. Dabei muss wiederum die Kennung des Auftrags angegeben werden, die man mit dem "main"-Dataset verschmelzen will. 
**ACHTUNG:** Dieser Schritt kann nicht Rückgängig gemacht werden. Im Falle eines Fehlers müssen alle entsprechenden Flächen "von Hand" gelöscht werden. 

## Produkte berechnung 
Die Naturgefahren-Produkte sind die folgenden: 
- Dokumente pro Gemeinde 
- Erhebungsgebiet
- Fliessrichtung
- Fliesstiefen
- Gefahrengebiet Hauptprozess Wasser, Sturz, Rutschung
- Gefahrengebiet Teilgebiet Absenkung/Einsturz, Fels- Bergsturz, Hangmure, Murgang, permanente Rutschung, spontane Rutschung, Stein- Blockschlag, Überflutung
- Kennwert Übermurung Geschwindigkeit,
- Kennwert Übermurung Höhe
- Kennwert Überschwemmung Geschwindigkeit
- Synoptische Intensität
- Synoptisches Gefahrengebiet
- Hinweis Ufererosion

Die Produkte werden mit folgendem GRETL-Job berechnet: *afu_naturgefahren_produkte*. Auch hier muss wieder das Dataset eingegeben werden, für welches man die Produkte berechnen will (Beispiel: main). Des weiteren kann der Einbezug der alten Daten einzelner Hauptprozess-Gefahrenkarten unterbunden werden. Hierzu schreibt man bspw. beim Parameter "ohne_altdaten_wasser" "true" hin. 

Die Daten werden in folgendem Modell berechnet und abgelegt: https://geo.so.ch/models/AFU/SO_AFU_Naturgefahren_Kernmodell_20231016.ili

    Im Ordner des GRETL-Jobs (afu_naturgefahren_produkte) befindet sich ein docker-compose.yml. <br>
    Wird es mit "docker-compose up" ausgeführt, wird eine postgis DB hochgefahren. 
    - Image: postgis/postgis:16-3.4-alpine
    - port: 54324
    - user: user
    - password: pass
    - DB: processing 

### Vorbereitung 
Die Vorbereitung umfasst folgende Schritte 
1. Eine temporäre "Berechnungs-Datenbank" wird hochgefahren. (In der Entwicklungsversion noch nicht).
2. Die Extension "uuid-ossip" wird auf der neu hochgefahrenen DB erstellt. *Wird wohl im produktiven Betrieb nicht mehr benötigt.*
3. Es werden die folgenden Schemata erstellt:
   - afu_naturgefahren_v1 -> Enthält die 1:1 Kopie des angeforderten Datasets aus der Edit-DB Die Daten werden dabei als XTF exportiert und in die temporäre DB importiert.
   - afu_naturgefahren_alte_dokumente_v1 -> Enthält die alten Dokumente. Diese werden aus der Pub-DB aus dem View afu_gefahrenkartierung_pub.gefahrenkartirung_perimeter_gefahrenkartierung_v ausgelesen und schon in die neue Form umgebaut. 
   - afu_gefahrenkartierung -> Enthält die alten NatGef-Daten als 1:1 Kopie. Da ein Export als XTF aber zu lange dauern würde, werden die Daten mit einem Db2Db-Step in die Temporäre DB geschrieben. 
   - afu_naturgefahren_beurteilungsgebiet_v1 -> Enthält die Beurteilungsgebiete als 1:1 Kopie aus der Edit-DB. Diese werden als XTF transferiert.
   - agi_hoheitsgrenzen_pub -> 1:1 Kopie der Gemeindegrenzen aus der Pub-DB. Werden als XTF transferiert.
  
### Berechnungen
Bei den Berechnungen gibt es grundsätzlich zwei Arten von Verschnitten: <br><br>
Der **"Prio-Verschnitt"**. Hier werden Flächen priorisiert (gemäss den Farben oder Intensität und Jährlichkeit aka "Charakterisierung"). Dann werden die Flächen miteinander verschnitten und die höher priorisierte gewinnt. Allerdings gibt es hier auch spezialfälle.
  - Beim Teilbereich Überflutung haben wir z.B. "geteilte Kästchen". Ein Überflutungsereignis der Charakterisierung U2 kann z.B. blau oder gelb sein. In diesem Fall muss die blaue Fläche die gelbe wegschneiden. Dies wird dadurch gewährleistet, dass der Charakterisierung noch eine Zehnerzahl zugerechnet wird: 0 für Restgefährdung, 10 für gering, 20 für mittel und 30 für erheblich.
  - Das Selbe gilt für den Teilbereich spontane Rutschung
Die Prio-Verschnitte werden am Ende noch mit einem Union und einem dump verschmolzen und wieder getrennt (Multipolygon). <br><br>

Der **Verschnitt nach Paul Ramsey**. (http://blog.cleverelephant.ca/2019/07/postgis-overlays.html) Hier werden Flächen nicht weggeschnitten, sondern die Flächen werden miteinander verschnitten (difference und Overlays in einem). Danach werden die Charakterisierungen der betreffenden Flächen oftmals aggregiert (Beispiel "U1, S2"). <br><br>
     
#### Synoptische Intensität
Die Flächen der Teilprozesse werden priorisiert gemäss dem zweiten Wert im IWCode (Farbe). Zusätzlich werden noch die Flächen hinzugefügt, welche beurteilt wurden, aber keine Einwirkung aufweisen. 
Diese erhalten natürlich die niedrigste Prio. Die einzelnen Teilprozesse werden einzeln mit sich selbst verschnitten, aber nur dort, wo die Jährlichkeit die selbe ist. Das Ziel ist schliesslich ein Layer mit Flächen gleicher Intensität und Jährlichkeit pro Teilprozess. 

#### Ufererosion 
Die Daten werden 1:1 übernommen 

#### Abklärungsperimeter
Hier werden alle Beurteilungsgebiete vereint. Es ist quasi ein "Union all" auf afu_naturgefahren_beurteilungsgebiet_v1.erhebungsgebiet_*

#### Erhebungsgebiet 
Die Erhebungsgebiete werden so aufbereitet: Zuerst werden mit "Paul Ramsey" die Abklärungsperimeter verschnitten. Diese können sich ja überlagern. Danach wird nachgeschaut, unter welchen Flächen sich jetzt welche Abklärungs-stati befinden. Diese werden dann ensprechend in die Spalten eingetragen. 

#### Dokumente pro Gemeinde 
  - Die alten Dokumente: Im File vorbereitung/alte_dokumente_copy.sql ist zuerst der View eingebaut, mit hilfe dessen die Dokumente bis anhin bereit gestellt wurden. Die Dokumente sind hier Hart-Codiert drin. Dann werden alle Geometrien, auf die ein bestimmtes Dokument referenziert zusammengefasst in einem Multipolygon. Mit bool_or wird dann ermittelt, welche Prozesse in einem Dokument beschrieben werden. Dann wird geschaut, welche dieser Multi-Flächen welche Gemeinde berührt (mit einem -10m Buffer). Diesen Gemeinden werden die Dokumente dann zugewordnet. 
  - Bei den neuen Dokumenten ist es so: Die Berichte sind mit dem Auftrag verknüpft. Dieser wiederum hat Teilaufträge. Die Teilaufträge wiederum haben Befunde zugeordnet und in diesen befindet sich die Geometrie. Die Berichte sind mit dem Teilauftrag über die Prozessquelle verbunden (Ist etwas kompliziert). 

#### Teilprozesse 
Die Teilprozesse werden mit der "Prio-Verschnitt" Methode verschnitten. Die Prioritäten werden hier aus dem IWCode ermittelt. Dabei gibt es zwei Unterschiedliche Ansätze: 
  - Direkte Ermittlung (z.B. teilprozess Stein und Blockschlag). Da hier jedes Kästchen im Würfeldiagram nur eine Zahl hat, ist die Priorität = Charakterisierung. 
  - Die zweistufige Priorisierung (z.B.  teilprozess Hangmure). Hier wird wieder jedem IWCode eine Zahl zugeordnet. Nun haben wir aber das Problem, dass die Charakterisierung 6 sowohl rot als auch blau sein kann. Die rote Fläche siegt aber über die blaue. Deshalb muss jetzt um die richtige Prio zu erhalten noch ein Wert hinzu adiert werden. Ist die Farbe der Fläche rot (=erheblich) wird 30 dazu addiert. Ist sie blau (mittel), 20. Ist sie gelb (gering) 10. Bei Restgefährdung wird nichts dazu addiert. 

#### Hauptprozesse 
##### Wasser 
Beim Hauptprozess Wasser werden zuerst die beiden Teilprozesse Überschwemmung und Murgang zusammengefügt. Dann werden die Flächen gemäss der Gefahrenstufe priorisiert und miteinander verschnitten. Dies sogt dafür, dass Flächen mit einer niedrigen Gefahrenstufe schon mal weggeschnitten werden. Danach muss aber noch mit der Ramsey-Methode dafür gesorgt werden, dass die Charakterisierungen aggregiert werden. 
Beispiel: Ein Murgang Gefahrenstufe "Mittel" überlagert eine Überschwemmungsfläche Gefahrenstufe "Mittel". Hier muss die Schnittfläche herausgetrennt werden (Ramsey) und die Charakterisierungen aggregiert werden (z.B. "M3, U1"). 

Beim Hauptprozess Wasser müssen auch die Altdaten verschnitten werden. Dies geschieht aber nur nach Prioritäten. Es sind auch nur einzelne Stellen, an denen sich die Flächen überlagern (eigentlich Fehler, aber nicht offiziell). 

##### Sturz
Die Priorisierung wird hier gleich von der Charakterisierung übernommen. Alle Sturz-Prozesse weisen die Charakterisierung SX auf und gemäss Prozessmatrix ist die Zahl auch gleichbedeutend mit "Höherrangig". Es gibt keine geteilten Kästchen. Das heisst: Bei einer allfälligen Überlagerung werden die Charakterisierungen eh nicht aggregiert, sondern die Charakterisierung mit dem höchsten Wert gewinnt. Deshalb reicht ein einfaches Clip aus.  

Die alten Daten werden 1:1 übernommen (mit Attribut-Mapping, weil z.T. anders).

##### Rutschung
zuerst müssen Überlappungen der Teilprozesse "spontane Rutschung" und "Hangmuren" miteinander verschnitten werden. Grund: Beide haben den Charakterisierungs-Buchstaben H. Es darf in einer Fläche aber kein H1 und H2 (als Beispiel) geben. Deshalb werden die Polygone gemäss ihrer Charakterisierung (= Priorisierung) miteinander verschnitten. Der erste Verschnitt erfolgt gemäss den Gefahrenstufen. Dies ist wichtig, weil bei diesen Prozessen ein H2 "mittel" und ein H4 "gering" sein kann (geteilte Kästchen). Dann werden die Gebiete noch gemäss ihrer Charakteristik verschnitten, damit sichergestellt ist, dass wirklich nur noch eine H - Fläche übrig ist (bei anderen Hauptprozessen ist dies nicht nötig, weil unterschiedliche Buchstaben). Dann werden die Flächen wieder mit Ramsey verschnitten und die Charakteristika aggregiert. Flächen mit gleicher Gefahrenstufe und gleicher Charakterisierung können zusammengefasst werden.

Die alten Rutschungs-Daten müssen ähnlich die die Flächen des Hauptprozesses Wasser auch noch verschnitten werden. Dies geschieht hier aber mit priorisierung UND Ramsey. 

##### Synoptisches Gefahrengebiet. 
Die Berechnung des synoptischen gefahrengebiets, kann nicht in einem file (CTEs) abgehandelt werden, da der Berechnungsprozess sonst viel zu lange dauern würde. Er wird daher in verschiedenen files und Schritten abgehandelt. Grundsätzlich funktioniert der Verschnitt hier aber exakt nach Paul Ramsey. Im Gegensatz zu den anderen Ramsey-Verschnitten werden hier aber temporäre Tabellen angelegt. 

#### Kennwerte
Die Kennwerte werden nicht verschnitten oder berechnet. Sie werden quasi übernommen. Einzelne Attribute werden verändert (z.B. j_30 -> 30 oder von_75_bis_100_cm .> von_75_bis_100cm) 

### Kleinstflächenbereinigung 
Kleinstflächen sollen bei den Gefahrenkarten der Hauptprozesse eliminiert werden. Dies geschieht mit den gk_clean-Tasks. 

Die Tasks Kopieren die Gefahrenkarten-Polygone aus der angegebenen Gefahrenkarte des Schemas afu_naturgefahren_pub_v2.

Klassiert und verarbeitet die Polygone in der Verarbeitungstabelle "poly_cleanup". 
Details zur Tabelle siehe [create_cleanup_layer.sql](smallpoly/create_cleanup_layer.sql).   
Die Polygone in der beim Jobstart angegebenen Quelltabelle (Bsp. gefahrengebiet_hauptprozess_wasser) werden vom Job **nicht verändert**.

Die Zusammenfassung der Verarbeitung wird im log des Jobs ausgegeben:

    ...
    > Task :logModifications
    logModifications: Start SqlExecutor
    logModifications: Given parameters DB-URL: jdbc:postgresql://processing-db/processing, DB-User: processing, Files: [/home/gradle/project/afu_naturgefahren_gk_clean/smallpoly/log_modifications.sql]
    logModifications: Merged small polygons: 9042
    logModifications: Skipped small polygons: 1301
    logModifications: Receiving big polygons: 963
    logModifications: End SqlExecutor (successful)
    ...

Bei diesem Beispiel-Run wurden 9042 + 1301 Kleinstpolygone identifiziert. 1301 konnten nicht gemerged werden, da für diese kein passendes Grosspolygon gefunden wurde, in welches gemergt werden kann. In 963 Grosspolygone wurden 1-n Kleinspolygone gemerged (Sprich: Sie wurden grösser).

#### Beschreibung der Schritte des Merge

Beschreibt am Beispiel der Polygone Grossmutter (GM), Mutter (M), Kind (K) wie schrittweise die in ein Grosspolygon zu mergenden Kleinpolygone identifiziert werden.

##### Ausgangslage

Verlinkungen:

    GM

Es sind noch keine Verlinkungen auf die Grossmutter vorhanden

##### Nach erstem Ausführen von link_to_neighbour.sql

Verlinkungen:

    GM <- M

Die Mutter ist über _parent_id_ref mit der Grossmutter verknüpft. 

    M._parent_id_ref = GM

##### Nach zweitem Ausführen von link_to_neighbour.sql

Verlinkungen:

    GM <- M <- K

Das Kind ist über _parent_id_ref mit der Mutter verknüpft.

    K._parent_id_ref = M

In der effektiven Berechnung gibt es natürlich meist mehrere Mütter und viele Kinder für eine Grossmutter:

    GM <- M1 <- K1_1
             <- K1_2
             <- K1_3
       <- M2 <- K2_1 
             <- K2_2 


Die Grossmutter ist ein Grosspolygon, die Mutter und das Kind sind Kleinpolygone.   
Die Grossmutter ist ein Root-Polygon (ein Root-Node), da sie von Kleinpolygonen referenziert wird.
Die Grossmutter gehört zu Generation 0, die Mutter zu Generation 1, das Kind zu Generation 2

link_to_neighbour.sql Könnte noch beliebige weitere Male ausgeführt werden. Mit jeder Ausführung kommt eine weitere Generation dazu.

##### Setzen der Root-ID

Für das Mergen ist nur relevant, welche Gruppe von Polygonen gemerged werden soll. Darum wird mittels set_root_id.sql für alle Polygone die _root_id_ref gesetzt.

    K._root_id_ref = GM
    M._root_id_ref = GM
    GM._root_id_ref = GM (Selbst-Referenz)

##### Mergen

In merge_geometries.sql wird nun gruppiert nach _root_id_ref gemerged. Die Grossmutter
erhält die aus dem Merge resultierende Geometrie und wird dabei "dicker".

Mit dem Mergen wird die Selbst-Referenz wieder aufgehoben.

## Publikation
Die Daten werden im WebGIS publiziert und im Rahmen eines MGDMs zur AI der Kantone (geodienste.ch) hochgeladen. 

### DB Schema
Pub-DB: afu_naturgefahren_pub_v1

### Datenumbau
**Gretljob ausführen:** [https://gretl.so.ch/job/afu_naturgefahren_pub

**Gretljob konfigurieren:** [https://github.com/sogis/gretljobs/tree/master/afu_naturgefahren_pub

Der GRETL-Job kopiert die Daten auf die Pub-DB UND er baut sie um ins MGDM. Danach wird ein XTF aus dem MGDM exportiert und an die AI geodienste.ch gesendet. 