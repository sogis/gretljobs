# avt_groblaermkataster
Die Strassenlärmdaten des AVT werden in einer Datenbank beim AVT in einer Fachanwendung (Firma G+P) bewirtschaftet. Daraus werden zwei Datensätz in zwei unterschiedlichen INTERLIS-Datenmodellen exportiert. 

Der vorliegende Job behandelt den Groblärmkataster. Es gibt nur ein (Publikation-)Modell. Die Daten werden direkt in die Publikationsdatenbank mittels GRETL-Job importiert. Beim Starten des Jobs wird der Benutzer aufgefordert die zu importierende Datei hochzuladen.

Im Web GIS Client wird _ein_ Layer (`ch.so.avt.groblaermkataster` / Groblärmkataster) publiziert.

