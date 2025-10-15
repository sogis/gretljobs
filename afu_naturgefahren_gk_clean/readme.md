# Job afu_naturgefahren_gk_clean

Kopiert die Gefahrenkarten-Polygone aus der angegebenen Gefahrenkarte des Schemas afu_naturgefahren_pub_v2.

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

## Beschreibung der Schritte des Merge

Beschreibt am Beispiel der Polygone Grossmutter (GM), Mutter (M), Kind (K) wie schrittweise die in ein Grosspolygon zu mergenden Kleinpolygone identifiziert werden.

### Ausgangslage

Verlinkungen:

    GM

Es sind noch keine Verlinkungen auf die Grossmutter vorhanden

### Nach erstem Ausführen von link_to_neighbour.sql

Verlinkungen:

    GM <- M

Die Mutter ist über _parent_id_ref mit der Grossmutter verknüpft. 

    M._parent_id_ref = GM

### Nach zweitem Ausführen von link_to_neighbour.sql

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

### Setzen der Root-ID

Für das Mergen ist nur relevant, welche Gruppe von Polygonen gemerged werden soll. Darum wird mittels set_root_id.sql für alle Polygone die _root_id_ref gesetzt.

    K._root_id_ref = GM
    M._root_id_ref = GM
    GM._root_id_ref = GM (Selbst-Referenz)

### Mergen

In merge_geometries.sql wird nun gruppiert nach _root_id_ref gemerged. Die Grossmutter
erhält die aus dem Merge resultierende Geometrie und wird dabei "dicker".

Mit dem Mergen wird die Selbst-Referenz wieder aufgehoben.

## Kontroll Geopackage 

Kreiert ein Geopackage "clean_results.gpkg", welches als Build-Artefakt nach der Jobausführung heruntergeladen werden kann.

Ebenen im Geopackage:

* poly_cleanup (Kopie der Verarbeitungstabelle)
* verification: Stellt zwecks Verifikation mittels Markierungspunkten räumlich den Bezug her zwischen den 1-n gemergten Kleinpolygonen und dem Grosspolygon, in welches gemerged wurde.
    * "5-Punkt Kreuz": Markiert das Grosspolygon, in welches gemerged wurde.
    * "Einzelpunkt": Markiert ein Kleinpolygon, welches in das Grosspolygon gemerged wurde.
    * Ein Kreuz und 1-n Einzelpunkte sind als Multipoint zusammengefasst, damit bei Klicken / Selektieren einfach erkannt werden kann, welche Kleinpolygone in welches Grosspolygon gemerged wurden.
