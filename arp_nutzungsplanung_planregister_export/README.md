## Information zum GRETL-Job "planregister_export"
Dieser GRETL-Job dient alleine dazu die Daten des Planregisterschemas auf data.geo.so.ch und files.geo.so.ch zu publizieren. Er wird bis auf weiteres losgelöst von anderen Jobs (der verschiedenem NPL-Themen) nächtlich ausgelöst. Es kann also vorkommen, dass es zwischen der Planregister-Anwendung (im Typo3) und den publizierten Daten im Datenbezug minimale Differenzen gibt. Da jedoch die Publikation täglich stattfindet, ist das vernachlässigbar.

Warum nicht im Job `arp_nutzungsplanung_planregister_pub_alles`? Diesen Job wird/darf es zukünftig nicht mehr geben.

Warum nicht in den einzelnen NPL-Themen-Jobs? Man müsste den exakt identischen Code bei jedem Job verwenden. Zudem ist das Testen/Entwickeln herausfordernder, weil es sich um Jobs mit einem speziellen Jenkinsfile handeln ("review"-Schritt).