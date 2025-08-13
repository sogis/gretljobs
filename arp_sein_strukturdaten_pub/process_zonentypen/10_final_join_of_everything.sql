-- ZIELTABELLE BEFÜLLEN

DELETE FROM
    export.strukturdaten_zonentyp
;

INSERT
    INTO export.strukturdaten_zonentyp (
        geometrie,
        flaeche,
        flaeche_bebaut,
        flaeche_unbebaut,
        flaeche_teilweise_bebaut,
        flaeche_gebaeude,
        flaeche_wohnungen,
        handlungsraum,
        gemeindename,
        gemeindenummer,
        altersklassen_5j,
        beschaeftigte_fte,
        raumnutzendendichte,
        flaechendichte,
        grundnutzungen_kanton,
        grundnutzungen_bund,
        gebaeudekategorien,
        gebaeudeklassen_10,
        gebaeudebauperioden,
        total_gebaeude,
        total_geschosse,
        total_wohnungen,
        total_zimmer,
        verteilung_anzahl_zimmer,
        anzahl_wohnungen_avg,
        anzahl_geschosse_avg,
        anzahl_geschosse_anz_null,
        anzahl_zimmer_avg,
        anzahl_zimmer_anz_null,
        flaeche_wohnung_avg,
        flaeche_wohnung_anz_null,
        flaeche_gebaeude_anz_null,
        bodenbedeckungen
    )
    SELECT
        -- "coalesce" wird angewendet, um NULL Werte zu vermeiden, wenn kein Objekt gejoined ist (Gebäude, Wohnung, Person, Firma)
        a.geometrie,
        a.flaeche,
        a.flaeche_bebaut,
        a.flaeche_unbebaut,
        a.flaeche_teilweise_bebaut,
        coalesce(d.flaeche_gebaeude, 0) AS flaeche_gebaeude,
        coalesce(e.flaeche_wohnungen, 0) AS flaeche_wohnungen,
        g2.handlungsraum,
        g1.gemeindename,
        a.bfs_nr AS gemeindenummer,
        h.altersklassen_5j,
        coalesce(i.beschaeftigte_fte, 0) AS beschaeftigte_fte,
        -- Raumnutzendendichte: division by zero vermeiden mit nullif
        a.flaeche / nullif(
            coalesce(h.popcount, 0) + coalesce(i.beschaeftigte_fte, 0), 0
        ) AS raumnutzendendichte,
        -- Flächendichte: Umrechnung von m2 auf ha = Faktor 10'000
        (   coalesce(h.popcount, 0) + coalesce(i.beschaeftigte_fte, 0)
        ) / a.flaeche * 10000 AS flaechendichte,
        grundnutzungen_kanton,
        grundnutzungen_bund,
        c.gebaeudekategorien,
        c.gebaeudeklassen_10,
        c.gebaeudebauperioden,
        coalesce(d.total_gebaeude, 0) AS total_gebaeude,
        coalesce(d.total_geschosse, 0) AS total_geschosse,
        coalesce(e.total_wohnungen, 0) AS total_wohnungen,
        coalesce(e.total_zimmer, 0) AS total_zimmer,
        c.verteilung_anzahl_zimmer,
        coalesce(e.anzahl_wohnungen_avg, 0) AS anzahl_wohnungen_avg,
        coalesce(d.anzahl_geschosse_avg, 0) AS anzahl_geschosse_avg,
        coalesce(d.anzahl_geschosse_anz_null, 0) AS anzahl_geschosse_anz_null,
        coalesce(e.anzahl_zimmer_avg, 0) AS anzahl_zimmer_avg,
        coalesce(e.anzahl_zimmer_anz_null, 0) AS anzahl_zimmer_anz_null,
        coalesce(e.flaeche_wohnung_avg, 0) AS flaeche_wohnung_avg,
        coalesce(e.flaeche_wohnung_anz_null, 0) AS flaeche_wohnung_anz_null,
        coalesce(d.flaeche_gebaeude_anz_null, 0) AS flaeche_gebaeude_anz_null,
        b.bodenbedeckungen
    FROM
        export.zonentyp_geoms a
    LEFT JOIN export.zonentyp_bodenbedeckungen_json b
        USING (typ_kt, bfs_nr)
    LEFT JOIN export.zonentyp_gwr_json c
        USING (typ_kt, bfs_nr)
    LEFT JOIN export.zonentyp_gebaeude_statistik d
        USING (typ_kt, bfs_nr)
    LEFT JOIN export.zonentyp_wohnungen_statistik e
        USING (typ_kt, bfs_nr)
    LEFT JOIN export.zonentyp_grundnutzungen_json f
        USING (typ_kt, bfs_nr)
    LEFT JOIN export.zonentyp_statpop_json h
        USING (typ_kt, bfs_nr)
    LEFT JOIN export.zonentyp_statent_statistik i
        USING (typ_kt, bfs_nr)
    LEFT JOIN import.hoheitsgrenzen_gemeindegrenze g1
        ON a.bfs_nr = g1.bfs_gemeindenummer
    LEFT JOIN import.grundlagen_gemeinde g2
        ON a.bfs_nr = g2.bfsnr
;