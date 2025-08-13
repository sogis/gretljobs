-- GWR: Wohnungsdaten aggregiert auf Zonentyp-Ebene (Summen und Anzahlen)

DROP TABLE IF EXISTS
    export.zonentyp_gwr_wohn_agg CASCADE
;

CREATE TABLE
    export.zonentyp_gwr_wohn_agg (
        typ_kt						TEXT,
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
    INTO export.zonentyp_gwr_wohn_agg
    SELECT
        typ_kt,
        bfs_nr,
        count(ewid) AS total_wohnungen,
        -- mind. 1 Wert muss nach numeric gecastet werden, damit keine integer division durchgeführt wird
        round((count(ewid) / count(DISTINCT egid)::NUMERIC), 2) AS anzahl_wohnungen_avg,
        sum(warea) AS flaeche_wohnungen,
        round(avg(warea), 2) AS flaeche_wohnung_avg,
        count(*) FILTER (WHERE warea IS NULL) flaeche_wohnung_anz_null,
        sum(wazim) AS total_zimmer,
        round(avg(wazim), 2) AS anzahl_zimmer_avg,
        count(*) FILTER (WHERE wazim IS NULL) anzahl_zimmer_anz_null
    FROM
        export.wohnung
    GROUP BY
        typ_kt,
        bfs_nr
;