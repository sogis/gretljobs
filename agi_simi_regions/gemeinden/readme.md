# Integration Gemeindestand in Schema agi_metadaten_datenabdeckung_v*

## Ablauf

1. Mittels QGIS-Desktop eine neue Datenabdeckung erstellen. Beispielsweise "gemeinden_2024".
1. Entstandene t_id in build.gradle übertragen.
1. Connection-Parameter für die entsprechende Umgebung setzen.
1. Import-Job auf Kommandozeile ausführen: `docker compose run --rm -u $UID gretl --project-dir=agi_simi_regions/gemeinden`

Dieser manuell auszuführende job integriert den aktuellen Stand der Gemeindeeinteilung in das Datenabdeckungs-Schema.