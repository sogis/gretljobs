-- GRUNDNUTZUNG: Aggregiert auf Parzellen-Ebene (Array) (faktisch keine Aggregation nötig)

DROP TABLE IF EXISTS
    export.parzellen_grundnutzungen_json CASCADE
;

CREATE TABLE
    export.parzellen_grundnutzungen_json AS
    SELECT
        t_ili_tid,
        jsonb_build_json(
            jsonb_BUILD_OBJECT(
                '@type',
                'SO_ARP_SEin_Strukturdaten_Publikation_20250407.Strukturdaten.Grundnutzung_Kanton',
                'Kategorie_Text',
                typ_kt,
                'Flaeche',
                round(
                    flaeche::NUMERIC,
                    2
                )
            )
        ) AS grundnutzungen_kanton,
        jsonb_build_json(
            jsonb_BUILD_OBJECT(
                '@type',
                'SO_ARP_SEin_Strukturdaten_Publikation_20250407.Strukturdaten.Grundnutzung_Bund',
                'Kategorie_Text',
                typ_bund,
                'Flaeche',
                round(
                    flaeche::NUMERIC,
                    2
                )
            )
        ) AS grundnutzungen_bund
    FROM
        export.parzellen_geoms
;