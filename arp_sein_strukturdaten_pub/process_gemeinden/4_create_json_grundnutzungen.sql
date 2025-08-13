-- GRUNDNUTZUNG: Aggregiert auf Gemeinde-Ebene (Array)

DROP TABLE IF EXISTS
    export.gemeinde_grundnutzungen_json CASCADE
;

CREATE TABLE
    export.gemeinde_grundnutzungen_json AS
    WITH zonentyp_geoms_agg AS (
    SELECT
        bfs_nr,
        typ_kt,
        typ_bund,
        flaeche,
        sum(flaeche) OVER (PARTITION BY bfs_nr, typ_bund) AS flaeche_bund_agg
    FROM
        export.zonentyp_geoms
    )
    SELECT
        bfs_nr,
        jsonb_agg(jsonb_build_object(
            '@type', 'SO_ARP_SEin_Strukturdaten_Publikation_20250407.Strukturdaten.Grundnutzung_Kanton',
            'Kategorie_Text', typ_kt,
            'Flaeche', round(flaeche::NUMERIC, 2)
        )) AS grundnutzungen_kanton,
        jsonb_agg(DISTINCT jsonb_build_object(
            '@type', 'SO_ARP_SEin_Strukturdaten_Publikation_20250407.Strukturdaten.Grundnutzung_Bund',
            'Kategorie_Text', typ_bund,
            'Flaeche', round(flaeche_bund_agg::NUMERIC, 2)
        )) AS grundnutzungen_bund
FROM
    zonentyp_geoms_agg
GROUP BY
    bfs_nr
;