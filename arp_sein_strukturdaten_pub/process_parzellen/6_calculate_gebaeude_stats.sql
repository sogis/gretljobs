-- GWR GEBÄUDE: Aggregiert auf Parzellen-Ebene (Summen und Anzahlen)

DROP TABLE IF EXISTS
    export.parzellen_gebaeude_statistik CASCADE
;

CREATE TABLE
    export.parzellen_gebaeude_statistik (
    t_ili_tid                   UUID,
    total_gebaeude              INTEGER,
    flaeche_gebaeude            NUMERIC,
    flaeche_gebaeude_anz_null   INTEGER,
    total_geschosse             INTEGER,
    anzahl_geschosse_avg        NUMERIC,
    anzahl_geschosse_anz_null   INTEGER   
);

INSERT
    INTO export.parzellen_gebaeude_statistik
    SELECT
        t_ili_tid,
        count(egid) AS total_gebaeude,
        sum(garea) AS flaeche_gebaeude,
        count(*) FILTER (WHERE garea IS NULL) AS flaeche_gebaeude_anz_null,
        sum(gastw) AS total_geschosse,
        round(avg(gastw),2) AS anzahl_geschosse_avg,
        count(*) FILTER (WHERE gastw IS NULL) AS anzahl_geschosse_anz_null
    FROM
        export.gebaeude
    GROUP BY
        t_ili_tid
;