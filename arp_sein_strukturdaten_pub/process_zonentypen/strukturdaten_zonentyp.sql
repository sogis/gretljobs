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
        COALESCE(d.flaeche_gebaeude, 0) AS flaeche_gebaeude,
        COALESCE(e.flaeche_wohnungen, 0) AS flaeche_wohnungen,
        g2.handlungsraum,
        g1.gemeindename,
        a.bfs_nr AS gemeindenummer,
        h.altersklassen_5j,
        COALESCE(i.beschaeftigte_fte, 0) AS beschaeftigte_fte,
        -- Raumnutzendendichte: division by zero vermeiden mit NULLIF
        a.flaeche / NULLIF(
            COALESCE(h.popcount, 0) + COALESCE(i.beschaeftigte_fte, 0), 0
        ) AS raumnutzendendichte,
        -- Flächendichte: Umrechnung von m2 auf ha = Faktor 10'000
        (   COALESCE(h.popcount, 0) + COALESCE(i.beschaeftigte_fte, 0)
        ) / a.flaeche * 10000 AS flaechendichte,
        grundnutzungen_kanton,
        grundnutzungen_bund,
        c.gebaeudekategorien,
        c.gebaeudeklassen_10,
        c.gebaeudebauperioden,
        COALESCE(d.total_gebaeude, 0) AS total_gebaeude,
        COALESCE(d.total_geschosse, 0) AS total_geschosse,
        COALESCE(e.total_wohnungen, 0) AS total_wohnungen,
        COALESCE(e.total_zimmer, 0) AS total_zimmer,
        c.verteilung_anzahl_zimmer,
        COALESCE(e.anzahl_wohnungen_avg, 0) AS anzahl_wohnungen_avg,
        COALESCE(d.anzahl_geschosse_avg, 0) AS anzahl_geschosse_avg,
        COALESCE(d.anzahl_geschosse_anz_null, 0) AS anzahl_geschosse_anz_null,
        COALESCE(e.anzahl_zimmer_avg, 0) AS anzahl_zimmer_avg,
        COALESCE(e.anzahl_zimmer_anz_null, 0) AS anzahl_zimmer_anz_null,
        COALESCE(e.flaeche_wohnung_avg, 0) AS flaeche_wohnung_avg,
        COALESCE(e.flaeche_wohnung_anz_null, 0) AS flaeche_wohnung_anz_null,
        COALESCE(d.flaeche_gebaeude_anz_null, 0) AS flaeche_gebaeude_anz_null,
        b.bodenbedeckungen
    FROM
        export.zonentyp_basis a
    LEFT JOIN export.zonentyp_bodenbedeckungen_array b
        USING (typ_kt, bfs_nr)
    LEFT JOIN export.zonentyp_gwr_array c
        USING (typ_kt, bfs_nr)
    LEFT JOIN export.zonentyp_gwr_geb_agg d
        USING (typ_kt, bfs_nr)
    LEFT JOIN export.zonentyp_gwr_wohn_agg e
        USING (typ_kt, bfs_nr)
    LEFT JOIN export.zonentyp_grundnutzungen_array f
        USING (typ_kt, bfs_nr)
    LEFT JOIN export.zonentyp_statpop_array h
        USING (typ_kt, bfs_nr)
    LEFT JOIN export.zonentyp_statent_agg i
        USING (typ_kt, bfs_nr)
    LEFT JOIN import.hoheitsgrenzen_gemeindegrenze g1
        ON a.bfs_nr = g1.bfs_gemeindenummer
    LEFT JOIN import.grundlagen_gemeinde g2
        ON a.bfs_nr = g2.bfsnr
;