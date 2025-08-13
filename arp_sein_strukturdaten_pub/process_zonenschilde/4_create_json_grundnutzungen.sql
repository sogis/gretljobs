-- GRUNDNUTZUNG: Aggregiert auf Zonenschild-Ebene (Array) (faktisch kein Aggregieren nötig)

DROP TABLE IF EXISTS
    export.zonenschild_grundnutzungen_json CASCADE
;

CREATE TABLE
    export.zonenschild_grundnutzungen_json AS
    SELECT
        schild_uuid,
        jsonb_build_array(
            jsonb_build_object(
                '@type', 'SO_ARP_SEin_Strukturdaten_Publikation_20250407.Strukturdaten.Grundnutzung_Kanton',
                'Kategorie_Text', typ_kt,
                'Flaeche', round(flaeche, 2)
            )
        ) AS grundnutzungen_kanton,
        jsonb_build_array(
            jsonb_build_object(
                '@type', 'SO_ARP_SEin_Strukturdaten_Publikation_20250407.Strukturdaten.Grundnutzung_Bund',
                'Kategorie_Text', typ_bund,
                'Flaeche', round(flaeche, 2)
            )
        ) AS grundnutzungen_bund
    FROM
        export.zonenschild_geoms
;