# Publikation der AV-Daten

Mit diesem Job werden die AV-Daten gemeindeweise über die Datenbanken und den Datenbezug publiziert.

## Von AV-Aktualisierung abhängige Jobs

Viele zeitgesteuerte Jobs sind von der AV-Aktualisierung abhängig (WMTS-Seeding, ...). Als Konvention wird davon ausgegangen, dass dieser Job vor Mitternacht durchgelaufen ist, und abhängige Jobs darum nach Mitternacht aktualisierte AV-Daten konsumieren werden.

## Aufteilung in Sub-Projekte

Der Job ist in drei Sub-Projekte aufgeteilt. Gemäss dem jeweiligen INTERLIS-Modell.

## Abhängigkeits-Konfiguration der Sub-Projekte

Zwecks stabiler Referenzen zwischen den Subprojekten referenzieren die Subprojekte untereinander jeweils den "Sammel-Task" "execProjPubTasks".

Die zu publizierenden Gemeinden folgen:

 * Für die Publikation von DM01AVSO24LV95 aus dem Inhalt des Ordners build/dm01_so des Unterprojekts 0_dm01_so
 * Für die Modelle DM01AVCH24LV95D und SO_AGI_MOpublic_YYYYMMDD aus dem Publisher von 0_dm01_so mittels Konfiguration der Kind-Publisher: `regions = project(':0_dm01_so').tasks.publish.publishedRegions`
