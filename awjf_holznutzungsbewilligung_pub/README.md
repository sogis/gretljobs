# AWJF_Holznutzungsbewilligung_Pub

Import, Erfassung und Publikation von Holznutzungsbewilligungen gemäss MGDM.

## Aufbau des Jobs

Die Holznutzungsbewilligungen stammen aus zwei Quellen: vom SFTP-Server des Waldportals (private Flächen) sowie aus dem Erfassungsschema (öffentliche Flächen). Beide Datensätze werden in einem Staging-Schema zusammengeführt. Aus diesem zusammengeführten Bestand werden anschliessend sowohl das Publikationsschema als auch ein Export nach geodienste.ch gespiesen.

Ablauf bis zum Import in das Staging-Schema:
```
               exportEdit ─┐
                           ├─> importEditToStaging ─┐
        deleteFromStaging ─┘                        ├─> importWaldportalToStaging
downloadWaldportalZip ─> unzipWaldportalXtf ────────┘
```
(Fortsetzung) Ablauf vom Import bis zu Publikation und Export: 
```
importWaldportalToStaging ─┬─> copyStagingToPub ─> updateDispnamesInPub
                           └─> exportStaging ─> zipXtf ─> uploadZip
```

## Abhängigkeiten

### Extern

- Waldportal SFTP-Server: Quelle der Holznutzungsbewilligungen auf privaten Flächen (ZIP/XTF)
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