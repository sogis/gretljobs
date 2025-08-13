-- STATPOP: Aggregiert auf Parzellen-Ebene

DROP TABLE IF EXISTS
    export.parzellen_statpop_json CASCADE
;

CREATE TABLE
    export.parzellen_statpop_json AS
    WITH statpop_grouped AS (
        SELECT
            t_ili_tid,
            classagefiveyears,
            count(*) AS anzahl
        FROM
            export.statpop
        WHERE
            classagefiveyears IS NOT NULL
        GROUP BY
            t_ili_tid,
            classagefiveyears
    )
    SELECT 
        t_ili_tid,
        sum(anzahl)::integer AS popcount,
        jsonb_agg(
        jsonb_build_object(
            '@type', 'SO_ARP_SEin_Strukturdaten_Publikation_20250407.Strukturdaten.Altersklasse_5j',
            'Kategorie_Id', classagefiveyears,
            'Kategorie_Text',
            CASE
                WHEN classagefiveyears BETWEEN 0 AND 110 THEN concat(classagefiveyears, '-', classagefiveyears + 4, ' Jahre')
                WHEN classagefiveyears = 115 THEN '115+ Jahre'
            END,
            'Anzahl', anzahl
        )
    ) altersklassen_5j
FROM
    statpop_grouped
GROUP BY
    t_ili_tid;