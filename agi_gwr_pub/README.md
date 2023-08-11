- Für Demozwecke, z.B. Energiefachstelle.
- Modell nur minimalistisch. Strukturell (was ist mandatory etc.?, woraus macht man einen Aufzähltyp?) und inhaltlich (welche Attribute wollen wir?) Was bedeuten z.B. die zwei mal x Heizungsattribute?
- Modell-Variante: Attributnamen im Edit-Modell entsprechen den komischen Abkürzung plus natürlich Kommentar dazu. Im Pub-Modell die sprechenden Namen. Dazu aber auch die Originalwerte mit kryptischen Namen? Oder "Gebaeudestatus" und "Gebaeudestatus_Code".
- Umbau / Matching:
  * **Ich Depp:** Ich glaube ich werde mit der codes-Tabelle beim Import joinen. Dann bekommen ich die Texte gratis.
  * Momentan mittels Koordinate und AV-Gebäude. Zukünftig wohl via EGID.
  * was machen / wie darstellen non-matches?
  * auch beim Joinen mit AV-Gebäude kann es zu Dupletten kommen.
  * Gebäudegeometrie könnte auch aus Pub kommen. Zuerst aus Edit Punkt, dann pub zu pub.

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


```
./start-gretl.sh --docker-image sogis/gretl:latest --docker-network schema-jobs_default --topic-name agi_gwr --schema-dirname schema_pub createRolesDevelopment
./start-gretl.sh --docker-image sogis/gretl:latest --docker-network schema-jobs_default --topic-name agi_gwr --schema-dirname schema_pub createSchema configureSchema grantPrivileges
./start-gretl.sh --docker-image sogis/gretl:latest --docker-network schema-jobs_default --topic-name agi_gwr --schema-dirname schema_pub dropSchema

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
export ORG_GRADLE_PROJECT_dbUriEdit=jdbc:postgresql://geodb-t.rootso.org/edit
export ORG_GRADLE_PROJECT_dbUserEdit=xxxxxxxxx
export ORG_GRADLE_PROJECT_dbPwdEdit=yyyyyyyyy
export ORG_GRADLE_PROJECT_dbUriPub=jdbc:postgresql://pub-db/pub
export ORG_GRADLE_PROJECT_dbUserPub=ddluser
export ORG_GRADLE_PROJECT_dbPwdPub=ddluser
```

```
./start-gretl.sh --docker-image sogis/gretl:latest --docker-network schema-jobs_default --job-directory $PWD/agi_gwr_pub importData
```