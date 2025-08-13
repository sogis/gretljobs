-- BODENBEDECKUNG: Aggregiert auf Parzellen-Ebene (Array)

DROP TABLE IF EXISTS
    export.parzellen_bodenbedeckungen_array CASCADE
;

CREATE TABLE
    export.parzellen_bodenbedeckungen_array AS
    SELECT
        t_ili_tid,
        jsonb_agg(
            jsonb_build_object(
                '@type',
                'SO_ARP_SEin_Strukturdaten_Publikation_20250407.Strukturdaten.Bodenbedeckung',
                'Kategorie_Text',
                kategorie_text,
                'Flaeche',
                round(flaeche_agg::NUMERIC, 2)
            )
        ) AS bodenbedeckungen
    FROM
        export.parzellen_bodenbedeckung
    WHERE
        round(flaeche_agg::NUMERIC, 2) > 0
    GROUP BY
        t_ili_tid
;