# Aktualisierung des Feature-Suchindexes

Mit Jenkins werden alle **Publikationsjobs mit definierter Suche** durchsucht und jeweils nur dir Publikationstasks `updateSearchIndex*` ausgeführt.

> [!TIP]
> Dieser Jobs kann generisch für das Starten von gewissen Tasks verwendet werden.

> [!IMPORTANT]
> Wichtig dabei ist, dass diese gestarteten Tasks kein *dependsOn* oder ähnliche Vernetzung mit anderen Tasks haben. Die Tasks müssen isoliert gestartet werden können.

