Die beiden Hilfsdateien ersetzen `Ä/Ö/Ü` durch `AE/OE/UE`, `ä/ö/ü` durch
`ae/oe/ue` und `ẞ/ß` durch `SS/ss`. Beispiel:
`NaiS_Form_2_HÄGE-08_20170327_20.pdf` wird zu
`NaiS_Form_2_HAEGE-08_20170327_20.pdf`. Andere Zeichen werden nicht allgemein
nach ASCII umgewandelt. Das Python-Skript vereinheitlicht vorab die
Unicode-Schreibweise (NFC), um auch zerlegt gespeicherte Umlaute zu erkennen.

1. Die PDFs in den für NaiS vorgesehenen neuen Dokumentordner kopieren. Der
   bisherige Schutzwald-Ordner kann weiterhin von bestehenden Links verwendet
   werden. Auf dieser Kopie arbeiten; währenddessen keine parallelen Änderungen
   an den Dateinamen durchführen.
2. Python-Vorschau aufrufen (ab dem Repository-Verzeichnis `gretljobs`):

   ```bash
   python3 awjf_nais_schutzwald_pub/Datenmigration/umlaute_ersetzen.py /pfad/zu/den/pdfs
   ```

   Das Skript berücksichtigt nur PDFs und überspringt symbolische Links.
   Für Unterordner zusätzlich `--rekursiv` angeben; Ordnernamen bleiben erhalten.
   Namenskollisionen führen vor der ersten Änderung zum Abbruch, auch wenn sie
   sich nur in der Gross-/Kleinschreibung unterscheiden.
3. Nach Prüfung anwenden:

   ```bash
   python3 awjf_nais_schutzwald_pub/Datenmigration/umlaute_ersetzen.py /pfad/zu/den/pdfs --anwenden --protokoll /tmp/nais-umbenennungen.csv
   ```

   Das CSV-Protokoll enthält die tatsächlich umbenannten alten/neuen absoluten
   Pfade. Es wird nicht überschrieben. Bei einem Laufzeitfehler können bereits
   einzelne Umbenennungen erfolgt sein; diese stehen im Protokoll.
4. `umlaute_ersetzen.sql` auf der Edit-Datenbank als vollständiges Skript ausführen.
   Es betrifft ausschliesslich `awjf_nais_schutzwald_v1.nais_dokument.dokument`.
   Es werden keine Tabellen oder Funktionen angelegt. Die `WITH`-Ausdrücke sind
   Teile der Abfragen und benötigen keine Berechtigung zum Anlegen von Objekten.
   Zusätzlich zu den üblichen Verbindungs-/Schemarechten werden nur SELECT- und
   UPDATE-Rechte auf den betroffenen Tabellenspalten benötigt.
   Der Standardlauf zeigt `t_id`, alten und neuen Namen und nimmt die Änderungen
   anschliessend mit `ROLLBACK` zurück. Die erste Ergebnisliste als CSV sichern.
   Für die tatsächliche Umstellung am Ende `ROLLBACK;` durch `COMMIT;` ersetzen
   und das Skript erneut vollständig ausführen. Falls ein anderer Fehler auftritt,
   die Transaktion mit `ROLLBACK;` beenden.
5. Die umbenannten PDFs im neuen Web-Dokumentordner bereitstellen und danach
   Export und Linkvalidierung erneut ausführen. Datenbank und Dateisystem werden
   unabhängig geändert; die Umstellung zeitlich abstimmen.

Auch das SQL normalisiert die Namen vorab nach NFC. Dafür wird eine
PostgreSQL-Datenbank mit UTF-8 vorausgesetzt.
Eine erneute Datenmigration aus der alten Tabelle würde die alten Namen wieder
einspielen; in diesem Fall die Bereinigung anschliessend erneut ausführen.
