## TODO

- Default-Task auf Löschen. FinalizedBy nicht verwenden, da dieser immer ausgeführt wird.
- ~~Löschen finalisieren~~ Sollte i.O. sein. Siehe TODO-Kommentar. Hier steht der korrekte Code.
- ~~Stimmen die Berechtigungen?~~
- ~~Umstellen von Test-Ftp-Dir auf Prod-Ftp-Dir.~~ Done.

java -jar /Users/stefan/apps/SaxonHE11-6J/saxon-he-11.6.jar -s:/Users/stefan/tmp/gemdat/test_mit_name.xml -xsl:/Users/stefan/sources/gretljobs/agi_av_meldewesen/xml2xtf.xsl -o:/Users/stefan/tmp/gemdat/test_mit_name.xtf

-> Gebäudebezeichung = RM-Hochhaus


java -jar /Users/stefan/apps/SaxonHE11-6J/saxon-he-11.6.jar -s:/Users/stefan/tmp/gemdat/test_ohne_name.xml -xsl:/Users/stefan/sources/gretljobs/agi_av_meldewesen/xml2xtf.xsl -o:/Users/stefan/tmp/gemdat/test_ohne_name.xtf

-> Gebäudebezeichnung = Wohngebäude mit Nebennutzung