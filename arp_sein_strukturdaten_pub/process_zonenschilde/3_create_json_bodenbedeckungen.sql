-- BODENBEDECKUNG: Aggregiert auf Zonenschild-Ebene (Array)

DROP TABLE IF EXISTS
    export.zonenschild_bodenbedeckungen_json CASCADE
;

CREATE TABLE
    export.zonenschild_bodenbedeckungen_json AS
    SELECT
        schild_uuid,
        jsonb_agg(jsonb_build_object(
            '@type', 'SO_ARP_SEin_Strukturdaten_Publikation_20250407.Strukturdaten.Bodenbedeckung',
            'Kategorie_Text', kategorie_text,
            'Flaeche', round(flaeche_agg::NUMERIC, 2)
        )) AS bodenbedeckungen
    FROM
        export.zonenschild_bodenbedeckung
    WHERE
        round(flaeche_agg::NUMERIC, 2) > 0
    GROUP BY
        schild_uuid
;