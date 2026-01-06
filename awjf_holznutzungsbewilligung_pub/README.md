# awjf_holznutzungsbewilligung_pub

Import und Publikation der Holznutzungsbewilligungen (MGDM) aus dem Waldportal (vgl. [Roter Faden](https://github.com/sogis/dok/blob/dok/dok_rote_faeden/Documents/AWJF/Waldmassnahmen_Waldportal/Waldmassnahmen_Waldportal.md)).

## Funktionsweise

Der Job lädt ein gezipptes XTF vom SFTP-Server des Waldportals herunter (Task-Gruppe *shared*) und führt zwei Workflows aus:

### Import vom Waldportal in die KGDI (Task-Gruppe *updateDatabases*)
1. *unzipXtf*: XTF-Datei aus dem ZIP-Archiv extrahieren
2. *importCatalog*: Holznutzungsbewilligung_Codelisten_V1_0.xml (in diesem Repo) in die Erfassungs-DB importieren
3. *importXtf*: Holznutzungsbewilligungen in die Erfassungs-DB importieren
4. *copyToPub*: Daten in das Publikationsschema überführen
5. *updateDispnames*: Für die Darstellung im WGC den `<dispname>` von Enumerationen nach `<attribut>_txt` schreiben

### Export nach geodienste.ch (Task-Gruppe *uploadZip*)

1. *uploadZip*: ZIP-Datei nach geodienste.ch übertragen und publizieren

## Abhängigkeiten

### Extern

- Waldportal SFTP-Server: Quelle der Holznutzungsbewilligungen (ZIP/XTF)
- geodienste.ch: Zielserver für die Publikation

### Umgebungsvariablen

- `dbUriEdit`, `dbUserEdit`, `dbPwdEdit`: Zugangsdaten Erfassungs-DB
- `dbUriPub`, `dbUserPub`, `dbPwdPub`: Zugangsdaten Publikations-DB
- `sftpServerWaldportal`, `sftpUserWaldportal`, `sftpPwdWaldportal`: Zugangsdaten Waldportal SFTP-Server
- `aiServer`, `aiUser`, `aiPwd`: Zugangsdaten geodienste.ch

## Datenmodelle
- MGDM: `Holznutzungsbewilligung_V1_0`
- Publikationsmodell: `SO_AWJF_Holznutzungsbewilligung_Publikation_20251222`

## Periodizität

Ausführung jeden Donnerstag zwischen 1:00 und 3:00 UTC.