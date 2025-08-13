-- BODENBEDECKUNG: Aggregiert auf Zonentyp-Ebene (Array)

DROP TABLE IF EXISTS
    export.zonentyp_bodenbedeckungen_json CASCADE
;

CREATE TABLE
    export.zonentyp_bodenbedeckungen_json AS
    SELECT
        typ_kt,
        bfs_nr,
        jsonb_agg(jsonb_build_object(
            '@type', 'SO_ARP_SEin_Strukturdaten_Publikation_20250407.Strukturdaten.Bodenbedeckung',
            'Kategorie_Text', kategorie_text,
            'Flaeche', round(flaeche_agg::NUMERIC, 2)
        )) AS bodenbedeckungen
    FROM
        export.zonentyp_bodenbedeckung
    WHERE
        round(flaeche_agg, 2) > 0
    GROUP BY
        typ_kt,
        bfs_nr
;