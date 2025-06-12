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
    logModifications: End SqlExecutor (successful)
    ...

Bei diesem Beispiel-Run wurden 9042 + 1301 Kleinstpolygone identifiziert.
1301 konnten nicht gemerged werden, da für diese kein passendes Grosspolygon gefunden wurde, in welches gemergt werden kann.

## Kontroll Geopackage 

Kreiert ein Geopackage "clean_results.gpkg", welches als Build-Artefakt nach der Jobausführung heruntergeladen werden kann.

Ebenen im Geopackage:

* poly_cleanup (Kopie der Verarbeitungstabelle)
* verification: Stellt zwecks Verifikation mittels Markierungspunkten räumlich den Bezug her zwischen den 1-n gemergten Kleinpolygonen und dem Grosspolygon, in welches gemerged wurde.
    * "5-Punkt Kreuz": Markiert das Grosspolygon, in welches gemerged wurde.
    * "Einzelpunkt": Markiert ein Kleinpolygon, welches in das Grosspolygon gemerged wurde.
    * Ein Kreuz und 1-n Einzelpunkte sind als Multipoint zusammengefasst, damit bei Klicken / selektieren einfach erkannt werden kann, welche Kleinpolygone in welches Grosspolygon gemerged wurden.
