- Für Demozwecke, z.B. Energiefachstelle.
- Modell nur minimalistisch. Strukturell (was ist mandatory etc.?, woraus macht man einen Aufzähltyp?) und inhaltlich (welche Attribute wollen wir?) Was bedeuten z.B. die zwei mal x Heizungsattribute?
- Modell-Variante: Attributnamen im Edit-Modell entsprechen den komischen Abkürzung plus natürlich Kommentar dazu. Im Pub-Modell die sprechenden Namen. Dazu aber auch die Originalwerte mit kryptischen Namen? Oder "Gebaeudestatus" und "Gebaeudestatus_Code".
- Umbau / Matching:
  * Momentan mittels Koordinate und AV-Gebäude. Zukünftig wohl via EGID.




Schemajobs:

```
export ORG_GRADLE_PROJECT_dbUriEdit=jdbc:postgresql://edit-db/edit
export ORG_GRADLE_PROJECT_dbUserEditDdl=ddluser
export ORG_GRADLE_PROJECT_dbPwdEditDdl=ddluser
export ORG_GRADLE_PROJECT_dbUriPub=jdbc:postgresql://pub-db/pub
export ORG_GRADLE_PROJECT_dbUserPubDdl=ddluser
export ORG_GRADLE_PROJECT_dbPwdPubDdl=ddluser
```

```
./start-gretl.sh --docker-image sogis/gretl:latest --docker-network schema-jobs_default --topic-name agi_gwr --schema-dirname schema createRolesDevelopment
./start-gretl.sh --docker-image sogis/gretl:latest --docker-network schema-jobs_default --topic-name agi_gwr --schema-dirname schema createSchema configureSchema grantPrivileges
./start-gretl.sh --docker-image sogis/gretl:latest --docker-network schema-jobs_default --topic-name agi_gwr --schema-dirname schema dropSchema
```


GRETL-Jobs:

```
export ORG_GRADLE_PROJECT_dbUriEdit=jdbc:postgresql://edit-db/edit
export ORG_GRADLE_PROJECT_dbUserEdit=ddluser
export ORG_GRADLE_PROJECT_dbPwdEdit=ddluser
export ORG_GRADLE_PROJECT_dbUriPub=jdbc:postgresql://pub-db/pub
export ORG_GRADLE_PROJECT_dbUserPub=ddluser
export ORG_GRADLE_PROJECT_dbPwdPub=ddluser
```

```
./start-gretl.sh --docker-image sogis/gretl:latest --docker-network schema-jobs_default --job-directory $PWD/agi_gwr_pub importData
```