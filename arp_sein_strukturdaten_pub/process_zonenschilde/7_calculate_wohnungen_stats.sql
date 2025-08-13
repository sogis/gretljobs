-- GWR: Wohnungsdaten aggregiert auf Zonenschild-Ebene (Summen und Anzahlen)

DROP TABLE IF EXISTS
    export.zonenschild_wohnungen_statistik CASCADE
;

CREATE TABLE
    export.zonenschild_wohnungen_statistik (
        schild_uuid					UUID,
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
    INTO export.zonenschild_wohnungen_statistik
    SELECT
        schild_uuid,
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
    schild_uuid
;