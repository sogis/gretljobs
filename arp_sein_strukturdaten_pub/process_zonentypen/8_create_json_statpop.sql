-- STATPOP: Aggregiert auf Zonentyp-Ebene
DROP TABLE IF EXISTS
    export.zonentyp_statpop_json CASCADE
;

CREATE TABLE
    export.zonentyp_statpop_json AS
    WITH statpop_grouped AS (
        SELECT
            typ_kt,
            bfs_nr,
            classagefiveyears,
            count(*) AS anzahl
        FROM
            export.statpop
        WHERE
            classagefiveyears IS NOT NULL
        GROUP BY
            typ_kt,
            bfs_nr,
            classagefiveyears
    )
    SELECT
        typ_kt,
        bfs_nr,
        sum(anzahl)::INTEGER AS popcount,
        jsonb_agg(jsonb_build_object(
            '@type', 'SO_ARP_SEin_Strukturdaten_Publikation_20250407.Strukturdaten.Altersklasse_5j',
            'Kategorie_Id', classagefiveyears,
            'Kategorie_Text', 
            CASE 
                WHEN classagefiveyears BETWEEN 0 AND 110 THEN concat(classagefiveyears, '-', classagefiveyears + 4, ' Jahre')
                WHEN classagefiveyears = 115 THEN '115+ Jahre'
            END,
            'Anzahl', anzahl
        )) altersklassen_5j
    FROM
        statpop_grouped
    GROUP BY
        typ_kt,
        bfs_nr
;