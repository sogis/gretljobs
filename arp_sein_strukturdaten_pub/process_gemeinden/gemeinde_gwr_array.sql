-- GWR GEBÄUDE: Aggregiert auf Gemeinde-Ebene (Arrays)

DROP TABLE IF EXISTS
    export.gemeinde_gwr_array CASCADE
;

CREATE TABLE
    export.gemeinde_gwr_array AS
    WITH gkat_grouped AS (
        SELECT
            bfs_nr,
            gkat,
            gkat_txt,
            count(*) AS anzahl
        FROM
            export.gebaeude
        WHERE
            gkat IS NOT NULL
        GROUP BY
            bfs_nr,
            gkat,
            gkat_txt
    ),
    gkat_array AS (
        SELECT
            bfs_nr,
            jsonb_agg(
                jsonb_build_object(
                    '@type', 'SO_ARP_SEin_Strukturdaten_Publikation_20250407.Strukturdaten.Gebaeudekategorie',
                    'Kategorie_Id', gkat,
                    'Kategorie_Text', gkat_txt,
                    'Anzahl', anzahl
                )
            ) AS gebaeudekategorien
        FROM
            gkat_grouped
        GROUP BY
            bfs_nr
    ),
    gklas_10_grouped AS (
        SELECT
            bfs_nr,
            gklas_10,
            gklas_10_txt,
            count(*) AS anzahl
        FROM
            export.gebaeude
        WHERE
            gklas_10 IS NOT NULL
        GROUP BY
            bfs_nr,
            gklas_10,
            gklas_10_txt
    ),
    gklas_10_array AS (
        SELECT
            bfs_nr,
            jsonb_agg(
                jsonb_build_object(
                    '@type', 'SO_ARP_SEin_Strukturdaten_Publikation_20250407.Strukturdaten.Gebaeudeklasse_10',
                    'Kategorie_Id', gklas_10,
                    'Kategorie_Text', gklas_10_txt,
                    'Anzahl', anzahl
                )
            ) AS gebaeudeklassen_10
        FROM
            gklas_10_grouped
        GROUP BY
            bfs_nr
    ),
    gbaup_grouped AS (
        SELECT
            bfs_nr,
            gbaup,
            gbaup_txt,
            count(*) AS anzahl
        FROM
            export.gebaeude
        WHERE
            gbaup IS NOT NULL
        GROUP BY
            bfs_nr,
            gbaup,
            gbaup_txt
    ),
    gbaup_array AS (
        SELECT
            bfs_nr,
            jsonb_agg(
                jsonb_build_object(
                    '@type', 'SO_ARP_SEin_Strukturdaten_Publikation_20250407.Strukturdaten.Gebaeudebauperiode',
                    'Kategorie_Id', gbaup,
                    'Kategorie_Text', gbaup_txt,
                    'Anzahl', anzahl
                )
            ) AS gebaeudebauperioden
        FROM
            gbaup_grouped
        GROUP BY
            bfs_nr
    ),
    wazim_grouped AS (
        SELECT
            bfs_nr,
            CASE
                WHEN wazim >= 6 THEN 6
                ELSE wazim
            END AS wazim_cat,
            CASE
                WHEN wazim >= 6 THEN '6+ Zimmer'
                ELSE concat(wazim, ' Zimmer')
            END AS wazim_txt,
            count(*) AS anzahl
        FROM
            export.wohnung
        WHERE
            wazim IS NOT NULL
        GROUP BY
            bfs_nr,
            CASE
                WHEN wazim >= 6 THEN 6
                ELSE wazim
            END,
            CASE
                WHEN wazim >= 6 THEN '6+ Zimmer'
                ELSE concat(wazim, ' Zimmer')
            END
    ),
    wazim_array AS (
        SELECT
            bfs_nr,
            jsonb_agg(
                jsonb_build_object(
                    '@type', 'SO_ARP_SEin_Strukturdaten_Publikation_20250407.Strukturdaten.Anzahl_Zimmer',
                    'Kategorie_Id', wazim_cat,
                    'Kategorie_Text', wazim_txt,
                    'Anzahl', anzahl
                )
            ) AS verteilung_anzahl_zimmer
        FROM
            wazim_grouped
        GROUP BY
            bfs_nr
    )
    SELECT
        p.bfs_nr,
        gkat_array.gebaeudekategorien,
        gklas_10_array.gebaeudeklassen_10,
        gbaup_array.gebaeudebauperioden,
        wazim_array.verteilung_anzahl_zimmer
    FROM
        export.gemeinde_basis p
        LEFT JOIN gkat_array USING (bfs_nr)
        LEFT JOIN gklas_10_array USING (bfs_nr)
        LEFT JOIN gbaup_array USING (bfs_nr)
        LEFT JOIN wazim_array USING (bfs_nr)
;

CREATE INDEX
    ON export.gemeinde_gwr_array (bfs_nr)
;