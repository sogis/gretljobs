-- BODENBEDECKUNG: aggregiert auf Gemeinde-Ebene (Array)

DROP TABLE IF EXISTS
    export.gemeinde_bodenbedeckungen_json CASCADE
;

CREATE TABLE
    export.gemeinde_bodenbedeckungen_json AS
    SELECT
        bfs_nr,
        jsonb_agg(
            jsonb_build_object(
                '@type', 'SO_ARP_SEin_Strukturdaten_Publikation_20250407.Strukturdaten.Bodenbedeckung',
                'Kategorie_Text', kategorie_text,
                'Flaeche', round(flaeche_agg, 2)
            )
        ) AS bodenbedeckungen
    FROM
        export.gemeinde_bodenbedeckung
    WHERE
        round(flaeche_agg, 2) > 0
    GROUP BY
        bfs_nr
;