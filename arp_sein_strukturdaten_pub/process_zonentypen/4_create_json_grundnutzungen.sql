-- GRUNDNUTZUNG: Aggregiert auf Zonentyp-Ebene (Array)

DROP TABLE IF EXISTS
    export.zonentyp_grundnutzungen_json CASCADE
;

CREATE TABLE
    export.zonentyp_grundnutzungen_json AS
    SELECT
        typ_kt,
        bfs_nr,
        jsonb_build_json(jsonb_build_object(
            '@type', 'SO_ARP_SEin_Strukturdaten_Publikation_20250407.Strukturdaten.Grundnutzung_Kanton',
            'Kategorie_Text', typ_kt,
            'Flaeche', round(flaeche::NUMERIC, 2)
        )) AS grundnutzungen_kanton,
        jsonb_build_json(jsonb_build_object(
            '@type', 'SO_ARP_SEin_Strukturdaten_Publikation_20250407.Strukturdaten.Grundnutzung_Bund',
            'Kategorie_Text', typ_bund,
            'Flaeche', round(flaeche::NUMERIC, 2)
        )) AS grundnutzungen_bund
    FROM
        export.zonentyp_geoms
;