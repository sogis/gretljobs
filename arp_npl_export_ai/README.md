# Datenumbau
Ich denke man muss die Übung wie sie jetzt abläuft, abbrechen. Der Datenumbau ist m.E. broken by design und nicht mehr zu retten. Dieses Verstückeln macht es zwar eigentlich übersichtlicher als eine grosse CTE, führt aber konsequent zu falschen Resultaten.

Entweder CTE-Bandwurm oder mit ili2pg v4.1 exportieren.



# Verändertes Modell

```
/Users/stefan/.ilicache/jdbc&003apostgresql&003a/geodb-t.verw.rootso.org&003a5432/sogis/arp_npl_mgdm/Nutzungsplanung_V1_1.ili:47:Domain DOMAIN Nutzungsplanung_Hauptnutzung_V1_1.TypID should be an OIDType.
Error: /Users/stefan/.ilicache/jdbc&003apostgresql&003a/geodb-t.verw.rootso.org&003a5432/sogis/arp_npl_mgdm/Nutzungsplanung_V1_1.ili:47:Domain DOMAIN Nutzungsplanung_Hauptnutzung_V1_1.TypID should be an OIDType.
failed to run ili2pg
ch.ehi.ili2db.base.Ili2dbException: compiler failed
```

-> Cache löschen `rm -rf ~/.ilicache` und in der DB in t_ili2db_model den Datentyp ändern. 
- Kann man in GRETL / ili2pg forcieren, dass es nicht das Modell aus der DB nimmt? Oder dem Cache (den alleine löschen hat nicht gereicht)
- Warum wird jetzt trotzdem das Modell geändert ohne den Namen zu ändern?

# Fehlerhafte Geometrie / Memoryprobleme
Anscheinend gibt es beim Thema Lärmempfindlichkeit Probleme beim Export der Daten. Gradle (JVM) braucht zuviel Memory. Aus diesem Grund hat Noemi wohl ST_SnapToGrid eingeführt. Dies führt aber zu einer invaliden Geometrien (in Messen). Sowohl Postgis wie auch ilivalidator finden diese invalide Geometrie. ST_MakeValid steht auf sogis-DB noch nicht zur Verfügung. Aus diesem Grund wird ein ST_Buffer(ST_SnapToGrid(),0) gemacht.

# init-Datei
Ich erlaube mir im Repo die init.gradle Datei abzulegen, da der Job noch nicht im Jenkins läuft und ich garantiert wieder lokal entwickeln muss.
