-- GWR: Wohnungsdaten aggregiert auf Gemeinde-Ebene (Summen und Anzahlen)

DROP TABLE IF EXISTS
    export.gemeinde_gwr_wohn_agg CASCADE
;

CREATE TABLE
    export.gemeinde_gwr_wohn_agg (
        bfs_nr						INTEGER,
        total_wohnungen				INTEGER,
        anzahl_wohnungen_avg		NUMERIC,
        flaeche_wohnungen			NUMERIC,
        flaeche_wohnung_avg			NUMERIC,
        flaeche_wohnung_anz_null	INTEGER,
        total_zimmer				INTEGER,
        anzahl_zimmer_avg			NUMERIC,
        anzahl_zimmer_anz_null		INTEGER
);

INSERT
    INTO export.gemeinde_gwr_wohn_agg
    SELECT
        bfs_nr,
        count(ewid) AS total_wohnungen,
        CASE 
            WHEN count(DISTINCT egid) = 0 THEN 0
            ELSE round((count(DISTINCT ewid) / count(DISTINCT egid)), 2)
        END AS anzahl_wohnungen_avg,
        sum(warea) AS flaeche_wohnungen,
        round(avg(warea), 2) AS flaeche_wohnung_avg,
        count(*) FILTER (WHERE warea IS NULL) flaeche_wohnung_anz_null,
        sum(wazim) AS total_zimmer,
        round(avg(wazim), 2) AS anzahl_zimmer_avg,
        count(*) FILTER (WHERE wazim IS NULL) anzahl_zimmer_anz_null
FROM
    export.wohnung
GROUP BY
    bfs_nr
;