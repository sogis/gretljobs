-- GWR: Gebäudedaten aggregiert auf Zonenschild-Ebene (Summen und Anzahlen)

DROP TABLE IF EXISTS
    export.zonenschild_gwr_geb_agg CASCADE
;

CREATE TABLE
    export.zonenschild_gwr_geb_agg (
    schild_uuid					UUID,
    total_gebaeude				INTEGER,
    flaeche_gebaeude			NUMERIC,
    flaeche_gebaeude_anz_null	INTEGER,
    total_geschosse				INTEGER,
    anzahl_geschosse_avg		NUMERIC,
    anzahl_geschosse_anz_null	INTEGER
);

INSERT
    INTO export.zonenschild_gwr_geb_agg
    SELECT
        schild_uuid,
        count(egid) AS total_gebaeude,
        sum(garea) AS flaeche_gebaeude,
        count(*) FILTER (WHERE garea IS NULL) AS flaeche_gebaeude_anz_null,
        sum(gastw) AS total_geschosse,
        round(avg(gastw), 2) AS anzahl_geschosse_avg,
        count(*) FILTER (WHERE gastw IS NULL) AS anzahl_geschosse_anz_null
    FROM
        export.gebaeude
    GROUP BY
        schild_uuid
;